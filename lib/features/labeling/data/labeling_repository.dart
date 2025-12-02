import 'package:drift/drift.dart';
import 'package:inventory_sync_apps/core/db/app_database.dart';
import 'package:inventory_sync_apps/features/labeling/data/models/label_component_result.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/daos/company_item_dao.dart';
import '../../../core/db/daos/component_dao.dart';
import '../../../core/db/daos/unit_dao.dart';
import '../../../core/db/daos/variant_component_dao.dart';
import '../../../core/db/daos/variant_dao.dart';
import '../../../core/db/daos/variant_photo_dao.dart';
import 'models/assembly_result.dart';
import 'models/scan_unit_result.dart';

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

  @override
  Future<LabelComponentResult> createComponentUnits({
    required String variantId,
    required String componentId,
    required int quantity,
    String? location,
    required String userId,
  }) async {
    final now = DateTime.now();
    final uuid = const Uuid();

    final List<String> generatedQr = [];
    final List<UnitsCompanion> entries = [];

    for (int i = 0; i < quantity; i++) {
      final unitId = uuid.v4();
      // Sementara format QR simple; nanti bisa kamu ganti pakai skema final
      final qr = 'U-$unitId';
      generatedQr.add(qr);

      entries.add(
        UnitsCompanion(
          id: Value(unitId),
          variantId: Value(variantId),
          componentId: Value(componentId),
          parentUnitId: const Value(null),
          qrValue: Value(qr),
          status: const Value('ACTIVE'),
          location: Value(location),
          printCount: const Value(0),
          lastPrintedAt: const Value(null),
          createdBy: Value(userId),
          updatedBy: Value(userId),
          lastPrintedBy: const Value(null),
          syncedAt: const Value(null),
          lastModifiedAt: Value(now),
          needSync: const Value(true),
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );
    }

    await _unitDao.insertUnits(entries);

    return LabelComponentResult(
      generatedCount: quantity,
      sampleQrValue: generatedQr.isNotEmpty ? generatedQr.first : null,
    );
  }

  @override
  Future<ScanUnitResult?> scanUnitByQr(String qrValue) async {
    final joined = await _unitDao.findByQrWithJoins(qrValue);
    if (joined == null) return null;

    final u = joined.unit;
    final c = joined.component;
    final v = joined.variant;

    return ScanUnitResult(
      unitId: u.id,
      qrValue: u.qrValue,
      status: u.status,
      componentId: c?.id,
      componentName: c?.name,
      variantId: v?.id,
      variantName: v?.name,
    );
  }

  @override
  Future<AssemblyResult> assembleComponents({
    required String variantId,
    required List<String> componentUnitIds,
    required String userId,
    String? location,
  }) async {
    if (componentUnitIds.length < 2) {
      throw Exception('Minimal butuh 2 komponen untuk assembly');
    }

    final now = DateTime.now();
    final uuid = const Uuid();

    // Jalankan dalam transaction supaya konsisten
    return _unitDao.transaction(() async {
      // 1) Buat unit SET baru
      final parentId = uuid.v4();
      final parentQr = 'SET-$parentId'; // sementara, silakan ganti pattern

      final parentEntry = UnitsCompanion(
        id: Value(parentId),
        variantId: Value(variantId),
        componentId: const Value(null),
        parentUnitId: const Value(null),
        qrValue: Value(parentQr),
        status: const Value('ACTIVE'),
        location: Value(location),
        printCount: const Value(0),
        lastPrintedAt: const Value(null),
        createdBy: Value(userId),
        updatedBy: Value(userId),
        lastPrintedBy: const Value(null),
        syncedAt: const Value(null),
        lastModifiedAt: Value(now),
        needSync: const Value(true),
        createdAt: Value(now),
        updatedAt: Value(now),
      );

      final parentUnit = await _unitDao.insertParentUnit(parentEntry);

      // 2) Tandai semua komponen jadi BOUND + set parent_unit_id
      await _unitDao.bindUnitsToParent(
        parentUnitId: parentUnit.id,
        componentUnitIds: componentUnitIds,
        userId: userId,
        now: now,
      );

      return AssemblyResult(
        parentUnitId: parentUnit.id,
        parentQrValue: parentUnit.qrValue,
        boundComponentUnitIds: componentUnitIds,
      );
    });
  }
}

class ComponentInput {
  final String name;
  final String? manufCode;
  final String? specJson;

  ComponentInput({required this.name, this.manufCode, this.specJson});
}
