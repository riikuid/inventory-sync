// lib/features/sync/data/sync_repository.dart
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
    final pendingPhotos = await db.variantPhotoDao.getPendingPhotos();
    final pendingUnits = await db.unitDao.getPendingUnits();
    // nanti: variant_components, buffer_stocks, dst

    if (pendingProducts.isEmpty &&
        pendingCompanyItems.isEmpty &&
        pendingVariants.isEmpty &&
        pendingComponents.isEmpty &&
        pendingPhotos.isEmpty &&
        pendingVariantComponents.isEmpty &&
        pendingUnits.isEmpty) {
      return const Result.success(null);
    }

    final productsPayload = pendingProducts
        .map(
          (p) => {
            'id': p.id,
            'name': p.name,
            'category_id': p.categoryId,
            'description': p.description,
            'is_active': p.isActive,
            'created_at': p.createdAt.toIso8601String(),
            'updated_at': p.updatedAt.toIso8601String(),
          },
        )
        .toList();

    final companyItemsPayload = pendingCompanyItems
        .map(
          (ci) => {
            'id': ci.id,
            'product_id': ci.productId,
            'company_code': ci.companyCode,
            'is_set': ci.isSet,
            'has_components': ci.hasComponents,
            'initialized_at': ci.initializedAt?.toIso8601String(),
            'initialized_by': ci.initializedBy,
            'notes': ci.notes,
            'created_at': ci.createdAt.toIso8601String(),
            'updated_at': ci.updatedAt.toIso8601String(),
            'deleted_at': ci.deletedAt?.toIso8601String(),
          },
        )
        .toList();

    // 2. Bentuk payload sesuai yang backendmu expect
    final variantsPayload = pendingVariants
        .map(
          (v) => {
            'id': v.id,
            'company_item_id': v.companyItemId,
            'brand_id': v.brandId,
            'name': v.name,
            'default_location': v.defaultLocation,
            'spec_json': v.specJson,
            'initialized_at': v.initializedAt?.toIso8601String(),
            'initialized_by': v.initializedBy,
            'is_active': v.isActive,
            'created_at': v.createdAt.toIso8601String(),
            'updated_at': v.updatedAt.toIso8601String(),
            'deleted_at': v.deletedAt?.toIso8601String(),
          },
        )
        .toList();

    final photosPayload = pendingPhotos
        .map(
          (p) => {
            'id': p.id,
            'variant_id': p.variantId,
            'local_path': p.localPath,
            'remote_url': p.remoteUrl,
            'position': p.position,
            'created_at': p.createdAt.toIso8601String(),
            'updated_at': p.updatedAt.toIso8601String(),
            'deleted_at': p.deletedAt?.toIso8601String(),
            'last_modified_at': p.lastModifiedAt.toIso8601String(),
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
            'spec_json': c.specJson,
            'is_active': c.isActive,
            'created_at': c.createdAt.toIso8601String(),
            'updated_at': c.updatedAt.toIso8601String(),
            'deleted_at': c.deletedAt?.toIso8601String(),
          },
        )
        .toList();

    final variantComponentsPayload = pendingVariantComponents
        .map(
          (vc) => {
            'id': vc.id,
            'variant_id': vc.variantId,
            'component_id': vc.componentId,
            'quantity': vc.quantity,
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
            'location': u.location,
            'print_count': u.printCount,
            'last_printed_at': u.lastPrintedAt?.toIso8601String(),
            'created_by': u.createdBy,
            'updated_by': u.updatedBy,
            'last_printed_by': u.lastPrintedBy,
            'synced_at': u.syncedAt?.toIso8601String(),
            'last_modified_at': u.lastModifiedAt.toIso8601String(),
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
      'variant_photos': photosPayload,
      'components': componentsPayload,
      'variant_components': variantComponentsPayload,
      'units': unitsPayload,
      // nanti: 'variant_components': ..., 'buffer_stocks': ...
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

    await db.variantPhotoDao.markPhotosSynced(
      pendingPhotos.map((p) => p.id).toList(),
    );
    await db.unitDao.markUnitsSynced(
      pendingUnits.map((u) => u.id).toList(),
      DateTime.now(),
    );
    return const Result.success(null);
  }

  /// Push pending changes (untuk iterasi awal: fokus units dulu).
  // Future<Result<void>> pushPendingUnits() async {
  //   final pendingUnits = await db.unitDao.getPendingUnits();

  //   if (pendingUnits.isEmpty) {
  //     return const Result.success(null);
  //   }

  //   final unitsPayload = pendingUnits.map((u) {
  //     return {
  //       'id': u.id,
  //       'variant_id': u.variantId,
  //       'component_id': u.componentId,
  //       'parent_unit_id': u.parentUnitId,
  //       'qr_value': u.qrValue,
  //       'status': u.status,
  //       'location': u.location,
  //       'print_count': u.printCount,
  //       'last_printed_at': u.lastPrintedAt?.toIso8601String(),
  //       'created_by': u.createdBy,
  //       'updated_by': u.updatedBy,
  //       'last_printed_by': u.lastPrintedBy,
  //       'synced_at': u.syncedAt?.toIso8601String(),
  //       'last_modified_at': u.lastModifiedAt.toIso8601String(),
  //       'created_at': u.createdAt.toIso8601String(),
  //       'updated_at': u.updatedAt.toIso8601String(),
  //       'deleted_at': u.deletedAt?.toIso8601String(),
  //     };
  //   }).toList();

  //   final payload = {
  //     'units': unitsPayload,
  //     // nanti bisa ditambah 'variants', 'components', dst kalau mau push juga
  //   };

  //   final res = await api.push(payload);

  //   if (!res.isSuccess) {
  //     return Result.failed(res.errorMessage ?? 'Failed to push units');
  //   }

  //   // kalau server sukses, kita tandai units sebagai sudah tersync
  //   final serverTimeIso = res.resultValue?['server_time'] as String?;
  //   final serverTime = serverTimeIso != null
  //       ? DateTime.parse(serverTimeIso)
  //       : DateTime.now();

  //   await db.unitDao.markUnitsSynced(
  //     pendingUnits.map((u) => u.id).toList(),
  //     serverTime,
  //   );

  //   return const Result.success(null);
  // }

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
      if (data['variant_components'] is List) {
        final list = (data['variant_components'] as List)
            .cast<Map<String, dynamic>>()
            .map(variantComponentFromJson)
            .toList();
        await db.batch((batch) {
          batch.insertAllOnConflictUpdate(db.variantComponents, list);
        });
      }

      // buffer_stocks
      if (data['buffer_stocks'] is List) {
        final list = (data['buffer_stocks'] as List)
            .cast<Map<String, dynamic>>()
            .map(bufferStockFromJson)
            .toList();
        await db.batch((batch) {
          batch.insertAllOnConflictUpdate(db.bufferStocks, list);
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
