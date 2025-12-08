// lib/features/sync/data/sync_repository.dart
import 'dart:developer' as dev;

import 'package:drift/drift.dart';
import 'package:inventory_sync_apps/core/db/app_database.dart';
import 'package:inventory_sync_apps/core/result.dart';

import 'sync_api.dart';
import 'sync_mapper.dart';

class SyncRepository {
  final AppDatabase db;
  final SyncApi api;

  SyncRepository({required this.db, required this.api});

  // Key untuk sync metadata
  static const _lastPullKey = 'last_pull_at';

  // ----------- PUBLIC API -----------

  /// Pertama kali login / install:
  /// tarik semua data (since = null), simpan last_pull_at.
  Future<Result<void>> initialPull() async {
    final res = await api.pull(); // tanpa since

    if (!res.isSuccess) {
      return Result.failed(res.errorMessage ?? 'Failed to pull initial data');
    }

    final data = res.resultValue!;
    await _applyPullPayload(data);

    final serverTimeIso = data['server_time'] as String?;
    if (serverTimeIso != null) {
      await _setLastPullAt(DateTime.parse(serverTimeIso));
    }

    return const Result.success(null);
  }

  /// Pull delta: hanya data yang updated sejak last_pull_at.
  Future<Result<void>> pullSinceLast() async {
    final last = await _getLastPullAt();
    final sinceIso = last?.toIso8601String();

    final res = await api.pull(sinceIso: sinceIso);

    if (!res.isSuccess) {
      dev.log('SYNC ERROR:\n${res.errorMessage}');
      return Result.failed(
        res.errorMessage ?? 'Failed to pull incremental data',
      );
    }

    final data = res.resultValue!;
    await _applyPullPayload(data);

    final serverTimeIso = data['server_time'] as String?;
    if (serverTimeIso != null) {
      await _setLastPullAt(DateTime.parse(serverTimeIso));
    }

    // Quick debug: print counts
    final productCount = await db.select(db.products).get();
    final companyItemCount = await db.select(db.companyItems).get();
    final categoryCount = await db.select(db.categories).get();
    final variantCount = await db.select(db.variants).get();
    final unitsCount = await db.select(db.units).get();

    dev.log(
      'DB after sync: products=${productCount.length}, company_items=${companyItemCount.length}, categories=${categoryCount.length}, variants=${variantCount.length}, units=${unitsCount.length}',
    );

    return const Result.success(null);
  }

  Future<Result<void>> pushPendingAll() async {
    // 1. Ambil pending dari semua tabel
    final pendingProducts = await db.productDao.getPendingProducts();
    final pendingCompanyItems = await db.companyItemDao
        .getPendingCompanyItems();
    final pendingVariants = await db.variantDao.getPendingVariants();
    final pendingComponents = await db.componentDao.getPendingComponents();
    final pendingVariantComponents = await db.variantComponentDao
        .getPendingVariantComponents();

    final pendingVariantPhotos = await db.variantPhotoDao.getPendingPhotos();
    final pendingComponentPhotos = await db.componentPhotoDao
        .getPendingPhotos();

    final pendingUnits = await db.unitDao.getPendingUnits();

    // 🔧: include componentPhotos juga di pengecekan kosong
    if (pendingProducts.isEmpty &&
        pendingCompanyItems.isEmpty &&
        pendingVariants.isEmpty &&
        pendingComponents.isEmpty &&
        pendingVariantPhotos.isEmpty &&
        pendingComponentPhotos.isEmpty &&
        pendingVariantComponents.isEmpty &&
        pendingUnits.isEmpty) {
      return const Result.success(null);
    }

    // =========== Upload file dulu ==========
    // 🔧: siapkan pencatatan upload
    final failedUploads = <String, String>{}; // photoId -> error
    var uploadTriedCount = 0;

    // --- Variant photos ---
    for (final p in pendingVariantPhotos.where(
      (p) => p.remoteUrl == null && p.localPath != null,
    )) {
      uploadTriedCount++;

      final uploadRes = await api.uploadPhoto(
        id: p.id,
        type: 'variant',
        filePath: p.localPath!,
      );

      if (!uploadRes.isSuccess) {
        // 🔧: JANGAN langsung return, tapi kumpulkan error
        failedUploads[p.id] =
            uploadRes.errorMessage ?? 'Failed to upload variant photo ${p.id}';
        continue;
      }

      final resp = uploadRes.resultValue;
      await db.variantPhotoDao.markUploaded(
        id: p.id,
        uploadedUrl: resp?.filePath ?? '',
        lastModifiedAt: DateTime.now(),
      );
    }

    // --- Component photos ---
    for (final p in pendingComponentPhotos.where(
      (p) => p.remoteUrl == null && p.localPath != null,
    )) {
      uploadTriedCount++;

      final uploadRes = await api.uploadPhoto(
        id: p.id,
        type: 'component',
        filePath: p.localPath!,
      );

      if (!uploadRes.isSuccess) {
        // 🔧: lagi-lagi kumpulkan, bukan return
        failedUploads[p.id] =
            uploadRes.errorMessage ??
            'Failed to upload component photo ${p.id}';
        continue;
      }

      final resp = uploadRes.resultValue;
      await db.componentPhotoDao.markUploaded(
        id: p.id,
        uploadedUrl: resp?.filePath ?? '',
        lastModifiedAt: DateTime.now(),
      );
    }

    // 🔧: keputusan setelah percobaan upload foto
    if (uploadTriedCount > 0 && failedUploads.length == uploadTriedCount) {
      // Artinya semua upload foto gagal → percuma lanjut push
      final firstError = failedUploads.values.first;
      return Result.failed(
        'Failed to upload all photos (${failedUploads.length}). '
        'Example error: $firstError',
      );
    }

    // 🔧: re-fetch pending photos setelah markUploaded,
    // supaya remoteUrl terbaru ikut terpakai
    final updatedVariantPhotos = await db.variantPhotoDao.getPendingPhotos();
    final updatedComponentPhotos = await db.componentPhotoDao
        .getPendingPhotos();

    // 🔧: hanya foto yang SUDAH punya remoteUrl yang ikut di-push
    final variantPhotosForPush = updatedVariantPhotos
        .where((p) => p.remoteUrl != null && p.deletedAt == null)
        .toList();

    final componentPhotosForPush = updatedComponentPhotos
        .where((p) => p.remoteUrl != null && p.deletedAt == null)
        .toList();

    // =========== Build payload non-file ==========
    final productsPayload = pendingProducts
        .map(
          (p) => {
            'id': p.id,
            'name': p.name,
            'category_id': p.categoryId,
            'machine_purchase': p.machinePurchase,
            'description': p.description,
            'created_at': p.createdAt.toIso8601String(),
            'updated_at': p.updatedAt.toIso8601String(),
          },
        )
        .toList();

    final companyItemsPayload = pendingCompanyItems
        .map(
          (ci) => {
            'id': ci.id,
            'default_rack_id': ci.defaultRackId,
            'product_id': ci.productId,
            'company_code': ci.companyCode,
            'specification': ci.specification,
            'notes': ci.notes,
            'created_at': ci.createdAt.toIso8601String(),
            'updated_at': ci.updatedAt.toIso8601String(),
            'deleted_at': ci.deletedAt?.toIso8601String(),
          },
        )
        .toList();

    final variantsPayload = pendingVariants
        .map(
          (v) => {
            'id': v.id,
            'company_item_id': v.companyItemId,
            'rack_id': v.rackId,
            'brand_id': v.brandId,
            'name': v.name,
            'uom': v.uom,
            'manuf_code': v.manufCode,
            'specification': v.specification,
            'created_at': v.createdAt.toIso8601String(),
            'updated_at': v.updatedAt.toIso8601String(),
            'deleted_at': v.deletedAt?.toIso8601String(),
          },
        )
        .toList();

    // 🔧: pakai variantPhotosForPush, bukan updatedVariantPhotos mentah
    final variantPhotosPayload = variantPhotosForPush
        .map(
          (p) => {
            'id': p.id,
            'variant_id': p.variantId,
            'file_path': p.remoteUrl, // hasil uploadPhoto
            'sort_order': p.sortOrder,
            'created_at': p.createdAt.toIso8601String(),
            'updated_at': p.updatedAt.toIso8601String(),
            'deleted_at': p.deletedAt?.toIso8601String(),
          },
        )
        .toList();

    final componentsPayload = pendingComponents
        .map(
          (c) => {
            'id': c.id,
            'product_id': c.productId,
            'name': c.name,
            'brand_id': c.brandId,
            'manuf_code': c.manufCode,
            'specification': c.specification,
            'created_at': c.createdAt.toIso8601String(),
            'updated_at': c.updatedAt.toIso8601String(),
            'deleted_at': c.deletedAt?.toIso8601String(),
          },
        )
        .toList();

    // 🔧: pakai componentPhotosForPush
    final componentPhotosPayload = componentPhotosForPush
        .map(
          (p) => {
            'id': p.id,
            'component_id': p.componentId,
            'file_path': p.remoteUrl,
            'sort_order': p.sortOrder,
            'created_at': p.createdAt.toIso8601String(),
            'updated_at': p.updatedAt.toIso8601String(),
            'deleted_at': p.deletedAt?.toIso8601String(),
          },
        )
        .toList();

    final variantComponentsPayload = pendingVariantComponents
        .map(
          (vc) => {
            'id': vc.id,
            'variant_id': vc.variantId,
            'component_id': vc.componentId,
            'quantity_needed': vc.quantityNeeded,
            'created_at': vc.createdAt.toIso8601String(),
            'updated_at': vc.updatedAt.toIso8601String(),
          },
        )
        .toList();

    final unitsPayload = pendingUnits
        .map(
          (u) => {
            'id': u.id,
            'variant_id': u.variantId,
            'component_id': u.componentId,
            'parent_unit_id': u.parentUnitId,
            'qr_value': u.qrValue,
            'status': u.status,
            'rack_id': u.rackId,
            'print_count': u.printCount,
            'last_printed_at': u.lastPrintedAt?.toIso8601String(),
            'last_printed_by': u.lastPrintedBy,
            'created_by': u.createdBy,
            'updated_by': u.updatedBy,
            'synced_at': u.syncedAt?.toIso8601String(),
            'created_at': u.createdAt.toIso8601String(),
            'updated_at': u.updatedAt.toIso8601String(),
            'deleted_at': u.deletedAt?.toIso8601String(),
          },
        )
        .toList();

    final payload = {
      'products': productsPayload,
      'company_items': companyItemsPayload,
      'variants': variantsPayload,
      'variant_photos': variantPhotosPayload,
      'components': componentsPayload,
      'component_photos': componentPhotosPayload,
      'variant_components': variantComponentsPayload,
      'units': unitsPayload,
    };

    final res = await api.push(payload);

    if (!res.isSuccess) {
      return Result.failed(res.errorMessage ?? 'Failed to push changes');
    }

    // 3. Jika sukses, tandai mereka sebagai synced
    await db.productDao.markProductsSynced(
      pendingProducts.map((p) => p.id).toList(),
    );
    await db.companyItemDao.markCompanyItemsSynced(
      pendingCompanyItems.map((ci) => ci.id).toList(),
    );
    await db.variantDao.markVariantsSynced(
      pendingVariants.map((v) => v.id).toList(),
    );
    await db.componentDao.markComponentsSynced(
      pendingComponents.map((c) => c.id).toList(),
    );
    await db.variantComponentDao.markVariantComponentsSynced(
      pendingVariantComponents.map((vc) => vc.id).toList(),
    );

    // 🔧: hanya foto yang ikut di-push yang di-mark synced
    await db.variantPhotoDao.markPhotosSynced(
      variantPhotosForPush.map((p) => p.id).toList(),
    );
    await db.componentPhotoDao.markPhotosSynced(
      componentPhotosForPush.map((p) => p.id).toList(),
    );

    await db.unitDao.markUnitsSynced(
      pendingUnits.map((u) => u.id).toList(),
      DateTime.now(),
    );

    return const Result.success(null);
  }

  /// Full sync sekali jalan: push dulu, lalu pull delta.
  Future<Result<void>> fullSync() async {
    final pushRes = await pushPendingAll();
    if (!pushRes.isSuccess) return pushRes;

    final pullRes = await pullSinceLast();
    return pullRes;
  }

  // ----------- INTERNAL HELPERS -----------

  Future<DateTime?> _getLastPullAt() async {
    final row = await (db.select(
      db.syncMetadata,
    )..where((tbl) => tbl.key.equals(_lastPullKey))).getSingleOrNull();

    if (row == null) return null;
    return DateTime.tryParse(row.value);
  }

  Future<void> _setLastPullAt(DateTime time) async {
    await db
        .into(db.syncMetadata)
        .insertOnConflictUpdate(
          SyncMetadataCompanion(
            key: const Value(_lastPullKey),
            value: Value(time.toIso8601String()),
          ),
        );
  }

  /// Terapkan payload /sync/pull ke DB lokal (upsert).
  Future<void> _applyPullPayload(Map<String, dynamic> data) async {
    // Kita wrap dalam transaction biar konsisten
    await db.transaction(() async {
      // categories
      if (data['categories'] is List) {
        final list = (data['categories'] as List)
            .cast<Map<String, dynamic>>()
            .map(categoryFromJson)
            .toList();
        await db.batch((batch) {
          batch.insertAllOnConflictUpdate(db.categories, list);
        });
      }

      // departments
      if (data['departments'] is List) {
        final list = (data['departments'] as List)
            .cast<Map<String, dynamic>>()
            .map(departmentFromJson)
            .toList();
        await db.batch((batch) {
          batch.insertAllOnConflictUpdate(db.departments, list);
        });
      }

      // sections
      if (data['sections'] is List) {
        final list = (data['sections'] as List)
            .cast<Map<String, dynamic>>()
            .map(sectionFromJson)
            .toList();
        await db.batch((batch) {
          batch.insertAllOnConflictUpdate(db.sections, list);
        });
      }

      // warehouses
      if (data['warehouses'] is List) {
        final list = (data['warehouses'] as List)
            .cast<Map<String, dynamic>>()
            .map(warehouseFromJson)
            .toList();
        await db.batch((batch) {
          batch.insertAllOnConflictUpdate(db.warehouses, list);
        });
      }

      // warehouses
      if (data['section_warehouses'] is List) {
        final list = (data['section_warehouses'] as List)
            .cast<Map<String, dynamic>>()
            .map(sectionWarehouseFromJson)
            .toList();
        await db.batch((batch) {
          batch.insertAllOnConflictUpdate(db.sectionWarehouses, list);
        });
      }

      // racks
      if (data['racks'] is List) {
        final list = (data['racks'] as List)
            .cast<Map<String, dynamic>>()
            .map(rackFromJson)
            .toList();
        await db.batch((batch) {
          batch.insertAllOnConflictUpdate(db.racks, list);
        });
      }

      // brands
      if (data['brands'] is List) {
        final list = (data['brands'] as List)
            .cast<Map<String, dynamic>>()
            .map(brandFromJson)
            .toList();
        await db.batch((batch) {
          batch.insertAllOnConflictUpdate(db.brands, list);
        });
      }

      // products
      if (data['products'] is List) {
        final list = (data['products'] as List)
            .cast<Map<String, dynamic>>()
            .map(productFromJson)
            .toList();
        await db.batch((batch) {
          batch.insertAllOnConflictUpdate(db.products, list);
        });
      }

      // company_items
      if (data['company_items'] is List) {
        final list = (data['company_items'] as List)
            .cast<Map<String, dynamic>>()
            .map(companyItemFromJson)
            .toList();
        await db.batch((batch) {
          batch.insertAllOnConflictUpdate(db.companyItems, list);
        });
      }

      // variants
      if (data['variants'] is List) {
        final list = (data['variants'] as List)
            .cast<Map<String, dynamic>>()
            .map(variantFromJson)
            .toList();
        await db.batch((batch) {
          batch.insertAllOnConflictUpdate(db.variants, list);
        });
      }

      if (data['variant_photos'] is List) {
        final list = (data['variant_photos'] as List)
            .cast<Map<String, dynamic>>()
            .map(variantPhotoFromJson)
            .toList();

        await db.batch((batch) {
          batch.insertAllOnConflictUpdate(db.variantPhotos, list);
        });
      }

      // components
      if (data['components'] is List) {
        final list = (data['components'] as List)
            .cast<Map<String, dynamic>>()
            .map(componentFromJson)
            .toList();
        await db.batch((batch) {
          batch.insertAllOnConflictUpdate(db.components, list);
        });
      }

      // variant_components
      if (data['component_photos'] is List) {
        final list = (data['component_photos'] as List)
            .cast<Map<String, dynamic>>()
            .map(componentPhotoFromJson)
            .toList();

        await db.batch((batch) {
          batch.insertAllOnConflictUpdate(db.componentPhotos, list);
        });
      }

      // variant_components
      if (data['variant_components'] is List) {
        final list = (data['variant_components'] as List)
            .cast<Map<String, dynamic>>()
            .map(variantComponentFromJson)
            .toList();
        await db.batch((batch) {
          batch.insertAllOnConflictUpdate(db.variantComponents, list);
        });
      }

      // units
      if (data['units'] is List) {
        final list = (data['units'] as List)
            .cast<Map<String, dynamic>>()
            .map(unitFromJson)
            .toList();
        await db.batch((batch) {
          batch.insertAllOnConflictUpdate(db.units, list);
        });
      }
    });
  }
}
