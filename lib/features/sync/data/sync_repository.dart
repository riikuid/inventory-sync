// lib/features/sync/data/sync_repository.dart
import 'dart:developer' as dev;

import 'package:drift/drift.dart';
import 'package:inventory_sync_apps/core/db/app_database.dart';
import 'package:inventory_sync_apps/core/result.dart';
import 'package:rxdart/rxdart.dart';

import '../bloc/sync_cubit.dart';
import 'sync_service.dart';
import 'sync_mapper.dart';

class SyncRepository {
  final AppDatabase db;
  final SyncService api;

  // 1. TAMBAHKAN VARIABLE INI (GEMBOK)
  bool _isSyncing = false;

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

  Stream<SyncCounts> watchAllPending() {
    // 1. Stream Product
    final s1 = (db.select(db.products)..where((t) => t.needSync.equals(true)))
        .watch()
        .map((rows) => rows.length);

    // 2. Stream Company Items
    final s2 =
        (db.select(db.companyItems)..where((t) => t.needSync.equals(true)))
            .watch()
            .map((rows) => rows.length);

    // 3. Stream Variants
    final s3 = (db.select(db.variants)..where((t) => t.needSync.equals(true)))
        .watch()
        .map((rows) => rows.length);

    // 4. Stream Components
    final s4 = (db.select(db.components)..where((t) => t.needSync.equals(true)))
        .watch()
        .map((rows) => rows.length);

    // 5. Stream Units
    final s5 =
        (db.select(db.units)
              ..where((t) => t.needSync.equals(true))
              ..where((u) => u.status.isNotIn([-2, -1, 0])))
            .watch()
            .map((rows) => rows.length);

    // 6. Stream Photos (Variant + Component)
    final sPhoto1 =
        (db.select(db.variantPhotos)..where((t) => t.needSync.equals(true)))
            .watch()
            .map((rows) => rows.length);
    final sPhoto2 =
        (db.select(db.componentPhotos)..where((t) => t.needSync.equals(true)))
            .watch()
            .map((rows) => rows.length);

    // Gabung Stream Photo jadi satu
    final sTotalPhotos = Rx.combineLatest2<int, int, int>(
      sPhoto1,
      sPhoto2,
      (a, b) => a + b,
    );

    // 7. Stream Variant Components
    final s7 =
        (db.select(db.variantComponents)..where((t) => t.needSync.equals(true)))
            .watch()
            .map((rows) => rows.length);

    // GABUNGKAN SEMUANYA MENGGUNAKAN RXDART
    return Rx.combineLatest7(s1, s2, s3, s4, s5, sTotalPhotos, s7, (
      products,
      items,
      variants,
      components,
      units,
      photos,
      variantComponents,
    ) {
      return SyncCounts(
        products: products,
        companyItems: items,
        variants: variants,
        components: components,
        units: units,
        photos: photos,
        variantComponents: variantComponents,
      );
    });
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
    dev.log('MASUK REPO SYNC PUSH');
    // 2. CEK GEMBOK DI AWAL
    if (_isSyncing) {
      dev.log('Sync already in progress. Skipping duplicate trigger.');
      return const Result.success(null); // Abaikan trigger kedua
    }

    // 3. KUNCI GEMBOK
    _isSyncing = true;
    try {
      dev.log('MASUK TRY');
      // -----------------------------------------------------------
      // PART 1: AMBIL DATA PENDING DARI DATABASE LOKAL
      // -----------------------------------------------------------
      final pendingProducts = await db.productDao.getPendingProducts();
      final pendingCompanyItems = await db.companyItemDao
          .getPendingCompanyItems();
      final pendingVariants = await db.variantDao.getPendingVariants();
      final pendingComponents = await db.componentDao.getPendingComponents();
      final pendingVariantComponents = await db.variantComponentDao
          .getPendingVariantComponents();
      final pendingUnits = await db.unitDao.getPendingUnits();

      // Khusus Foto
      final pendingVariantPhotos = await db.variantPhotoDao.getPendingPhotos();
      final pendingComponentPhotos = await db.componentPhotoDao
          .getPendingPhotos();

      // Cek apakah ada data yang perlu dikirim?
      if (pendingProducts.isEmpty &&
          pendingCompanyItems.isEmpty &&
          pendingVariants.isEmpty &&
          pendingComponents.isEmpty &&
          pendingVariantComponents.isEmpty &&
          pendingUnits.isEmpty &&
          pendingVariantPhotos.isEmpty &&
          pendingComponentPhotos.isEmpty) {
        dev.log('TIDAK ADA DATA');
        return const Result.success(null);
      }

      // -----------------------------------------------------------
      // PART 2: UPLOAD FOTO TERLEBIH DAHULU (Logic Lama Dipertahankan)
      // -----------------------------------------------------------
      final failedUploads = <String, String>{};
      var uploadTriedCount = 0;

      // A. Upload Variant Photos
      for (final p in pendingVariantPhotos.where(
        (p) => p.remoteUrl == null && p.localPath != null,
      )) {
        uploadTriedCount++;
        final uploadRes = await api.uploadPhoto(
          id: p.id,
          type: 'variant',
          filePath: p.localPath!,
        );

        if (uploadRes.isSuccess) {
          await db.variantPhotoDao.markUploaded(
            id: p.id,
            uploadedUrl: uploadRes.resultValue?.filePath ?? '',
            lastModifiedAt: DateTime.now(),
          );
        } else {
          failedUploads[p.id] = uploadRes.errorMessage ?? 'Upload failed';
        }
      }

      // B. Upload Component Photos
      for (final p in pendingComponentPhotos.where(
        (p) => p.remoteUrl == null && p.localPath != null,
      )) {
        uploadTriedCount++;
        final uploadRes = await api.uploadPhoto(
          id: p.id,
          type: 'component',
          filePath: p.localPath!,
        );

        if (uploadRes.isSuccess) {
          await db.componentPhotoDao.markUploaded(
            id: p.id,
            uploadedUrl: uploadRes.resultValue?.filePath ?? '',
            lastModifiedAt: DateTime.now(),
          );
        } else {
          failedUploads[p.id] = uploadRes.errorMessage ?? 'Upload failed';
        }
      }

      // Ambil ulang foto yang sudah punya remoteUrl (siap sync data)
      final readyVariantPhotos = await db.variantPhotoDao.getPendingPhotos();
      final variantPhotosPayload = readyVariantPhotos
          .where((p) => p.remoteUrl != null)
          .map((p) => variantPhotoToSyncJson(p, p.remoteUrl!))
          .toList();

      final readyComponentPhotos = await db.componentPhotoDao
          .getPendingPhotos();
      final componentPhotosPayload = readyComponentPhotos
          .where((p) => p.remoteUrl != null)
          .map((p) => componentPhotoToSyncJson(p, p.remoteUrl!))
          .toList();

      // -----------------------------------------------------------
      // PART 3: BUILD PAYLOAD (MENGGUNAKAN EXTENSIONS BARU)
      // -----------------------------------------------------------
      final payload = {
        'products': pendingProducts.map((e) => e.toSyncJson()).toList(),
        'company_items': pendingCompanyItems
            .map((e) => e.toSyncJson())
            .toList(),
        'variants': pendingVariants.map((e) => e.toSyncJson()).toList(),
        'components': pendingComponents.map((e) => e.toSyncJson()).toList(),
        'variant_components': pendingVariantComponents
            .map((e) => e.toSyncJson())
            .toList(),
        'units': pendingUnits.map((e) => e.toSyncJson()).toList(),
        'variant_photos': variantPhotosPayload,
        'component_photos': componentPhotosPayload,
      };

      // KIRIM KE SERVER
      final res = await api.push(payload);

      if (!res.isSuccess) {
        return Result.failed(res.errorMessage ?? 'Failed to push changes');
      }

      // -----------------------------------------------------------
      // PART 4: SMART ACKNOWLEDGEMENT (PROCESS SUCCESS_IDS)
      // -----------------------------------------------------------
      // Kita baca return dari server, ambil array 'success_ids' per tabel,
      // lalu hanya update data lokal yang ID-nya ada di array tersebut.

      final results = res.resultValue?['results'] as Map<String, dynamic>?;
      final now = DateTime.now();

      if (results != null) {
        await db.transaction(() async {
          // Helper kecil untuk extract success IDs
          List<String> getSuccessIds(String key) {
            if (results[key] is Map && results[key]['success_ids'] is List) {
              return List<String>.from(results[key]['success_ids']);
            }
            return [];
          }

          // 1. Products
          final successProducts = getSuccessIds(
            'products',
          ); // Sesuaikan key response controller
          if (successProducts.isNotEmpty) {
            await db.productDao.markProductsSynced(successProducts);
          }

          // 2. Company Items
          final successCI = getSuccessIds('company_items');
          if (successCI.isNotEmpty) {
            await db.companyItemDao.markCompanyItemsSynced(successCI);
          }

          // 3. Variants
          final successVariants = getSuccessIds('variants');
          if (successVariants.isNotEmpty) {
            await db.variantDao.markVariantsSynced(successVariants);
          }

          // 4. Components
          final successComponents = getSuccessIds('components');
          if (successComponents.isNotEmpty) {
            await db.componentDao.markComponentsSynced(successComponents);
          }

          // 5. Variant Components
          final successVC = getSuccessIds('variant_components');
          if (successVC.isNotEmpty) {
            await db.variantComponentDao.markVariantComponentsSynced(successVC);
          }

          // 6. Units (Paling Penting)
          final successUnits = getSuccessIds('units');
          if (successUnits.isNotEmpty) {
            await db.unitDao.markUnitsSynced(successUnits, now);
          }

          // 7. Variant Photos
          final successVariantPhotos = getSuccessIds('variant_photos');
          if (successVariantPhotos.isNotEmpty) {
            await db.variantPhotoDao.markPhotosSynced(successVariantPhotos);
          }

          // 8. Component Photos
          final successComponentPhotos = getSuccessIds('component_photos');
          if (successComponentPhotos.isNotEmpty) {
            await db.componentPhotoDao.markPhotosSynced(successComponentPhotos);
          }
        });
      }

      return const Result.success(null);
    } catch (e) {
      return Result.failed(e.toString());
    } finally {
      // 4. BUKA GEMBOK (APAPUN YANG TERJADI)
      // Ini wajib ditaruh di finally agar gembok terbuka meski error
      _isSyncing = false;
    }
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
