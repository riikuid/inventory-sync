// lib/features/sync/data/sync_repository.dart
import 'dart:async';
import 'dart:developer' as dev;

import 'package:drift/drift.dart';
import 'package:inventory_sync_apps/core/db/app_database.dart';
import 'package:inventory_sync_apps/core/result.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/foundation.dart';

import '../bloc/sync_cubit.dart';
import 'sync_service.dart';
import 'sync_mapper.dart';

class SyncRepository {
  final AppDatabase db;
  final SyncService api;

  bool _isSyncing = false;
  final _progressController = StreamController<double>.broadcast();
  Stream<double> get onSyncProgress => _progressController.stream;

  SyncRepository({required this.db, required this.api});

  static const _lastPullKey = 'last_pull_at';

  // ==================== WATCH PENDING ====================

  Stream<SyncCounts> watchAllPending() {
    final s1 = (db.select(db.products)..where((t) => t.needSync.equals(true)))
        .watch()
        .map((rows) => rows.length);

    final s2 =
        (db.select(db.companyItems)..where((t) => t.needSync.equals(true)))
            .watch()
            .map((rows) => rows.length);

    final s3 = (db.select(db.variants)..where((t) => t.needSync.equals(true)))
        .watch()
        .map((rows) => rows.length);

    final s4 = (db.select(db.components)..where((t) => t.needSync.equals(true)))
        .watch()
        .map((rows) => rows.length);

    final s5 =
        (db.select(db.units)
              ..where((t) => t.needSync.equals(true))
              ..where((u) => u.status.isNotIn([-2, -1, 0])))
            .watch()
            .map((rows) => rows.length);

    final sPhoto1 =
        (db.select(db.variantPhotos)..where((t) => t.needSync.equals(true)))
            .watch()
            .map((rows) => rows.length);
    final sPhoto2 =
        (db.select(db.componentPhotos)..where((t) => t.needSync.equals(true)))
            .watch()
            .map((rows) => rows.length);

    final sTotalPhotos = Rx.combineLatest2<int, int, int>(
      sPhoto1,
      sPhoto2,
      (a, b) => a + b,
    );

    final s7 =
        (db.select(db.variantComponents)..where((t) => t.needSync.equals(true)))
            .watch()
            .map((rows) => rows.length);

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

  // ==================== PULL SINCE LAST ====================

  Future<Result<void>> pullSinceLast() async {
    final last = await _getLastPullAt();
    final sinceIso = last?.toIso8601String();

    _progressController.add(0.1);
    dev.log('🔄 Starting pull...');

    final res = await api.pull(sinceIso: sinceIso);

    if (!res.isSuccess) {
      return Result.failed(
        res.errorMessage ?? 'Failed to pull incremental data',
      );
    }

    final data = res.resultValue!;
    _progressController.add(0.3);

    // Apply data ke database
    await _applyPullPayload(data);
    _progressController.add(0.9);

    final serverTimeIso = data['server_time'] as String?;
    if (serverTimeIso != null) {
      await _setLastPullAt(DateTime.parse(serverTimeIso));
    }

    _progressController.add(1.0);

    // Debug counts
    final productCount = await db.select(db.products).get();
    final companyItemCount = await db.select(db.companyItems).get();
    final variantCount = await db.select(db.variants).get();
    final unitsCount = await db.select(db.units).get();

    dev.log(
      'DB after sync: products=${productCount.length}, '
      'company_items=${companyItemCount.length}, '
      'variants=${variantCount.length}, '
      'units=${unitsCount.length}',
    );

    return const Result.success(null);
  }

  // ==================== PUSH PENDING ====================

  Future<Result<void>> pushPendingAll() async {
    if (_isSyncing) {
      dev.log('⚠️ Sync already in progress. Skipping duplicate trigger.');
      return const Result.success(null);
    }

    _isSyncing = true;
    try {
      final pendingProducts = await db.productDao.getPendingProducts();
      final pendingCompanyItems = await db.companyItemDao
          .getPendingCompanyItems();
      final pendingVariants = await db.variantDao.getPendingVariants();
      final pendingComponents = await db.componentDao.getPendingComponents();
      final pendingVariantComponents = await db.variantComponentDao
          .getPendingVariantComponents();
      final pendingUnits = await db.unitDao.getPendingUnits();
      final pendingVariantPhotos = await db.variantPhotoDao.getPendingPhotos();
      final pendingComponentPhotos = await db.componentPhotoDao
          .getPendingPhotos();

      if (pendingProducts.isEmpty &&
          pendingCompanyItems.isEmpty &&
          pendingVariants.isEmpty &&
          pendingComponents.isEmpty &&
          pendingVariantComponents.isEmpty &&
          pendingUnits.isEmpty &&
          pendingVariantPhotos.isEmpty &&
          pendingComponentPhotos.isEmpty) {
        return const Result.success(null);
      }

      // Upload photos first
      final failedUploads = <String, String>{};

      for (final p in pendingVariantPhotos.where(
        (p) => p.remoteUrl == null && p.localPath != null,
      )) {
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

      for (final p in pendingComponentPhotos.where(
        (p) => p.remoteUrl == null && p.localPath != null,
      )) {
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

      final res = await api.push(payload);

      if (!res.isSuccess) {
        return Result.failed(res.errorMessage ?? 'Failed to push changes');
      }

      final results = res.resultValue?['results'] as Map<String, dynamic>?;
      final now = DateTime.now();

      if (results != null) {
        await db.transaction(() async {
          List<String> getSuccessIds(String key) {
            if (results[key] is Map && results[key]['success_ids'] is List) {
              return List<String>.from(results[key]['success_ids']);
            }
            return [];
          }

          final successProducts = getSuccessIds('products');
          if (successProducts.isNotEmpty) {
            await db.productDao.markProductsSynced(successProducts);
          }

          final successCI = getSuccessIds('company_items');
          if (successCI.isNotEmpty) {
            await db.companyItemDao.markCompanyItemsSynced(successCI);
          }

          final successVariants = getSuccessIds('variants');
          if (successVariants.isNotEmpty) {
            await db.variantDao.markVariantsSynced(successVariants);
          }

          final successComponents = getSuccessIds('components');
          if (successComponents.isNotEmpty) {
            await db.componentDao.markComponentsSynced(successComponents);
          }

          final successVC = getSuccessIds('variant_components');
          if (successVC.isNotEmpty) {
            await db.variantComponentDao.markVariantComponentsSynced(successVC);
          }

          final successUnits = getSuccessIds('units');
          if (successUnits.isNotEmpty) {
            await db.unitDao.markUnitsSynced(successUnits, now);
          }

          final successVariantPhotos = getSuccessIds('variant_photos');
          if (successVariantPhotos.isNotEmpty) {
            await db.variantPhotoDao.markPhotosSynced(successVariantPhotos);
          }

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
      _isSyncing = false;
    }
  }

  // ==================== FULL SYNC ====================

  Future<Result<void>> fullSync() async {
    final pushRes = await pushPendingAll();
    if (!pushRes.isSuccess) return pushRes;

    final pullRes = await pullSinceLast();
    return pullRes;
  }

  // ==================== INTERNAL HELPERS ====================

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

  Future<void> _applyPullPayload(Map<String, dynamic> data) async {
    int totalSteps = 15;
    int currentStep = 0;

    void updateProgress() {
      currentStep++;
      double progress = 0.3 + (currentStep / totalSteps * 0.6);
      _progressController.add(progress);
    }

    await db.transaction(() async {
      if (data['categories'] is List) {
        final list = await compute(
          _parseCategories,
          data['categories'] as List,
        );
        await db.batch(
          (batch) => batch.insertAllOnConflictUpdate(db.categories, list),
        );
      }
      updateProgress();

      if (data['departments'] is List) {
        final list = await compute(
          _parseDepartments,
          data['departments'] as List,
        );
        await db.batch(
          (batch) => batch.insertAllOnConflictUpdate(db.departments, list),
        );
      }
      updateProgress();

      if (data['sections'] is List) {
        final list = await compute(_parseSections, data['sections'] as List);
        await db.batch(
          (batch) => batch.insertAllOnConflictUpdate(db.sections, list),
        );
      }
      updateProgress();

      if (data['warehouses'] is List) {
        final list = await compute(
          _parseWarehouses,
          data['warehouses'] as List,
        );
        await db.batch(
          (batch) => batch.insertAllOnConflictUpdate(db.warehouses, list),
        );
      }
      updateProgress();

      if (data['section_warehouses'] is List) {
        final list = await compute(
          _parseSectionWarehouses,
          data['section_warehouses'] as List,
        );
        await db.batch(
          (batch) =>
              batch.insertAllOnConflictUpdate(db.sectionWarehouses, list),
        );
      }
      updateProgress();

      if (data['racks'] is List) {
        final list = await compute(_parseRacks, data['racks'] as List);
        await db.batch(
          (batch) => batch.insertAllOnConflictUpdate(db.racks, list),
        );
      }
      updateProgress();

      if (data['brands'] is List) {
        final list = await compute(_parseBrands, data['brands'] as List);
        await db.batch(
          (batch) => batch.insertAllOnConflictUpdate(db.brands, list),
        );
      }
      updateProgress();

      if (data['products'] is List) {
        final list = await compute(_parseProducts, data['products'] as List);
        await db.batch(
          (batch) => batch.insertAllOnConflictUpdate(db.products, list),
        );
      }
      updateProgress();

      if (data['company_items'] is List) {
        final list = await compute(
          _parseCompanyItems,
          data['company_items'] as List,
        );
        await db.batch(
          (batch) => batch.insertAllOnConflictUpdate(db.companyItems, list),
        );
      }
      updateProgress();

      if (data['variants'] is List) {
        final list = await compute(_parseVariants, data['variants'] as List);
        await db.batch(
          (batch) => batch.insertAllOnConflictUpdate(db.variants, list),
        );
      }
      updateProgress();

      if (data['variant_photos'] is List) {
        final list = await compute(
          _parseVariantPhotos,
          data['variant_photos'] as List,
        );
        await db.batch(
          (batch) => batch.insertAllOnConflictUpdate(db.variantPhotos, list),
        );
      }
      updateProgress();

      if (data['components'] is List) {
        final list = await compute(
          _parseComponents,
          data['components'] as List,
        );
        await db.batch(
          (batch) => batch.insertAllOnConflictUpdate(db.components, list),
        );
      }
      updateProgress();

      if (data['component_photos'] is List) {
        final list = await compute(
          _parseComponentPhotos,
          data['component_photos'] as List,
        );
        await db.batch(
          (batch) => batch.insertAllOnConflictUpdate(db.componentPhotos, list),
        );
      }
      updateProgress();

      if (data['variant_components'] is List) {
        final list = await compute(
          _parseVariantComponents,
          data['variant_components'] as List,
        );
        await db.batch(
          (batch) =>
              batch.insertAllOnConflictUpdate(db.variantComponents, list),
        );
      }
      updateProgress();

      if (data['units'] is List) {
        final list = await compute(_parseUnits, data['units'] as List);
        await db.batch(
          (batch) => batch.insertAllOnConflictUpdate(db.units, list),
        );
      }
      updateProgress();
    });
  }

  void dispose() {
    _progressController.close();
  }
}

// ==================== HELPER FUNCTIONS ====================

List<CategoriesCompanion> _parseCategories(List<dynamic> rawList) {
  return rawList.cast<Map<String, dynamic>>().map(categoryFromJson).toList();
}

List<DepartmentsCompanion> _parseDepartments(List<dynamic> rawList) {
  return rawList.cast<Map<String, dynamic>>().map(departmentFromJson).toList();
}

List<SectionsCompanion> _parseSections(List<dynamic> rawList) {
  return rawList.cast<Map<String, dynamic>>().map(sectionFromJson).toList();
}

List<WarehousesCompanion> _parseWarehouses(List<dynamic> rawList) {
  return rawList.cast<Map<String, dynamic>>().map(warehouseFromJson).toList();
}

List<SectionWarehousesCompanion> _parseSectionWarehouses(
  List<dynamic> rawList,
) {
  return rawList
      .cast<Map<String, dynamic>>()
      .map(sectionWarehouseFromJson)
      .toList();
}

List<BrandsCompanion> _parseBrands(List<dynamic> rawList) {
  return rawList.cast<Map<String, dynamic>>().map(brandFromJson).toList();
}

List<RacksCompanion> _parseRacks(List<dynamic> rawList) {
  return rawList.cast<Map<String, dynamic>>().map(rackFromJson).toList();
}

List<ProductsCompanion> _parseProducts(List<dynamic> rawList) {
  return rawList.cast<Map<String, dynamic>>().map(productFromJson).toList();
}

List<CompanyItemsCompanion> _parseCompanyItems(List<dynamic> rawList) {
  return rawList.cast<Map<String, dynamic>>().map(companyItemFromJson).toList();
}

List<VariantsCompanion> _parseVariants(List<dynamic> rawList) {
  return rawList.cast<Map<String, dynamic>>().map(variantFromJson).toList();
}

List<VariantPhotosCompanion> _parseVariantPhotos(List<dynamic> rawList) {
  return rawList
      .cast<Map<String, dynamic>>()
      .map(variantPhotoFromJson)
      .toList();
}

List<ComponentsCompanion> _parseComponents(List<dynamic> rawList) {
  return rawList.cast<Map<String, dynamic>>().map(componentFromJson).toList();
}

List<ComponentPhotosCompanion> _parseComponentPhotos(List<dynamic> rawList) {
  return rawList
      .cast<Map<String, dynamic>>()
      .map(componentPhotoFromJson)
      .toList();
}

List<VariantComponentsCompanion> _parseVariantComponents(
  List<dynamic> rawList,
) {
  return rawList
      .cast<Map<String, dynamic>>()
      .map(variantComponentFromJson)
      .toList();
}

List<UnitsCompanion> _parseUnits(List<dynamic> rawList) {
  return rawList.cast<Map<String, dynamic>>().map(unitFromJson).toList();
}
