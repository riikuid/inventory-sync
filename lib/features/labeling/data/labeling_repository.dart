import 'package:drift/drift.dart';
import 'package:inventory_sync_apps/core/db/app_database.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/daos/company_item_dao.dart';
import '../../../core/db/daos/component_dao.dart';
import '../../../core/db/daos/unit_dao.dart';
import '../../../core/db/daos/variant_component_dao.dart';
import '../../../core/db/daos/variant_dao.dart';
import '../../../core/db/daos/variant_photo_dao.dart';

class LabelingRepository {
  final AppDatabase db;
  final _uuid = const Uuid();

  LabelingRepository(this.db);

  CompanyItemDao get _companyItemDao => db.companyItemDao;
  VariantDao get _variantDao => db.variantDao;
  ComponentDao get _componentDao => db.componentDao;
  VariantComponentDao get _variantComponentDao => db.variantComponentDao;
  VariantPhotoDao get _variantPhotoDao => db.variantPhotoDao;
  UnitDao get _unitDao => db.unitDao;

  /// Setup company_item (is_set, has_components) + create/update 1 variant + photos.
  Future<void> setupCompanyItem({
    required String companyItemId,
    required bool isSet,
    required bool hasComponents,
    required String? brandId,
    required String variantName,
    String? defaultLocation,
    String? specJson,
    required List<String> photoLocalPaths, // minimal 3
    required String userId,
  }) async {
    final now = DateTime.now();

    if (photoLocalPaths.length < 3) {
      throw Exception('Photo minimal 3');
    }

    await db.transaction(() async {
      // 1. update company_item
      final companyItem = await _companyItemDao.getById(
        companyItemId,
      ); // boleh null cek
      if (companyItem == null) {
        throw Exception('Company item not found');
      }

      await _companyItemDao.updateCompanyItem(
        companyItemId,
        isSet: isSet,
        hasComponents: hasComponents,
        initializedAt: now,
        initializedBy: userId,
      );

      // 2. create variant baru (untuk iterasi ini, kita buat 1 variant)
      final variantId = _uuid.v4();

      final variantCompanion = VariantsCompanion(
        id: Value(variantId),
        companyItemId: Value(companyItemId),
        brandId: Value(brandId),
        name: Value(variantName),
        defaultLocation: Value(defaultLocation),
        specJson: Value(specJson),
        initializedAt: Value(now),
        initializedBy: Value(userId),
        isActive: const Value(true),
        createdAt: Value(now),
        updatedAt: Value(now),
        lastModifiedAt: Value(now),
        needSync: const Value(true),
      );

      await _variantDao.upsertVariants([variantCompanion]);

      // 3. simpan photos
      final photoCompanions = <VariantPhotosCompanion>[];
      for (var i = 0; i < photoLocalPaths.length; i++) {
        final photoId = _uuid.v4();
        photoCompanions.add(
          VariantPhotosCompanion(
            id: Value(photoId),
            variantId: Value(variantId),
            localPath: Value(photoLocalPaths[i]),
            remoteUrl: const Value(null),
            position: Value(i),
            createdAt: Value(now),
            updatedAt: Value(now),
            lastModifiedAt: Value(now),
            needSync: const Value(true),
          ),
        );
      }
      await _variantPhotoDao.upsertPhotos(photoCompanions);
    });
  }

  /// Add or select components untuk 1 variant (dipanggil di Setup wizard)
  Future<void> configureComponentsForVariant({
    required String variantId,
    required String productId,
    required String? brandId,
    required List<ComponentInput> newComponents,
    required List<String> selectedComponentIds,
  }) async {
    final now = DateTime.now();

    await db.transaction(() async {
      final componentIds = <String>[];

      // 1. insert component baru (kalau ada)
      for (final c in newComponents) {
        final compId = _uuid.v4();
        final comp = ComponentsCompanion(
          id: Value(compId),
          productId: Value(productId),
          name: Value(c.name),
          brandId: Value(brandId),
          manufCode: Value(c.manufCode),
          specJson: Value(c.specJson),
          isActive: const Value(true),
          createdAt: Value(now),
          updatedAt: Value(now),
          deletedAt: const Value(null),
          lastModifiedAt: Value(now),
          needSync: const Value(true),
        );
        await _componentDao.upsertComponents([comp]);
        componentIds.add(compId);
      }

      // 2. plus component yang dipilih dari list existing
      componentIds.addAll(selectedComponentIds);

      // 3. hapus relasi variant_components lama, lalu buat baru
      await _variantComponentDao.deleteByVariant(variantId);

      final rels = <VariantComponentsCompanion>[];
      for (final compId in componentIds) {
        final id = _uuid.v4();
        rels.add(
          VariantComponentsCompanion(
            id: Value(id),
            variantId: Value(variantId),
            componentId: Value(compId),
            quantity: const Value(1),
            createdAt: Value(now),
            updatedAt: Value(now),
            lastModifiedAt: Value(now),
            needSync: const Value(true),
          ),
        );
      }
      await _variantComponentDao.upsertVariantComponents(rels);
    });
  }

  /// Membuat 1 unit SET untuk variant (label as set).
  /// qrValue didapat dari proses generate di Cubit/Screen.
  Future<String> createSetUnit({
    required String variantId,
    String? location,
    required String qrValue,
    required String userId,
  }) async {
    final now = DateTime.now();
    final unitId = _uuid.v4();

    final companion = UnitsCompanion(
      id: Value(unitId),
      variantId: Value(variantId),
      componentId: const Value(null),
      parentUnitId: const Value(null),
      qrValue: Value(qrValue),
      status: const Value('ACTIVE'),
      location: Value(location),
      // quantity default 1 (di schema kamu)
      printCount: const Value(1),
      lastPrintedAt: Value(now),
      createdBy: Value(userId),
      updatedBy: Value(userId),
      lastPrintedBy: Value(userId),
      syncedAt: const Value(null),
      lastModifiedAt: Value(now),
      needSync: const Value(true),
      createdAt: Value(now),
      updatedAt: Value(now),
      deletedAt: const Value(null),
    );

    await _unitDao.insertUnit(companion);
    return unitId;
  }
}

class ComponentInput {
  final String name;
  final String? manufCode;
  final String? specJson;

  ComponentInput({required this.name, this.manufCode, this.specJson});
}
