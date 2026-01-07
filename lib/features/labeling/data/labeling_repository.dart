import 'dart:developer' as dev;

import 'package:drift/drift.dart';
import 'package:inventory_sync_apps/core/constant.dart';
import 'package:inventory_sync_apps/core/db/app_database.dart';
import 'package:inventory_sync_apps/core/generate_custom_id.dart';

import '../../../core/db/daos/company_item_dao.dart';
import '../../../core/db/daos/unit_dao.dart';
import '../../../core/db/daos/variant_dao.dart';
import '../../../core/db/daos/variant_photo_dao.dart';
import '../../../core/db/model/variant_component_row.dart';
import 'models/assembly_result.dart';
import 'models/scan_unit_result.dart';

class LabelingRepository {
  final AppDatabase db;

  LabelingRepository(this.db);

  CompanyItemDao get _companyItemDao => db.companyItemDao;
  VariantDao get _variantDao => db.variantDao;
  VariantPhotoDao get _variantPhotoDao => db.variantPhotoDao;
  UnitDao get _unitDao => db.unitDao;

  /// CORE FUNCTION: Generate Batch Labels
  /// Menangani generate label untuk Variant (Set) maupun Component (Separate).
  Future<List<Unit>> generateBatchLabels({
    required String variantId,
    required String companyCode,
    required String rackId,
    required int qty,
    required String userId,
    // Parameter Opsional untuk Component Mode
    String? componentId,
    String? manufCode,
  }) async {
    return db.transaction(() async {
      final List<Unit> generatedUnits = [];
      final now = DateTime.now();

      // final batchTimestamp = now.millisecondsSinceEpoch.toString().substring(5);

      for (int i = 0; i < qty; i++) {
        String unitId = generateCustomId(unitsPrefix);

        // Logic QR Generation
        String qrResult;
        // Serial unik per item dalam batch ini

        if (componentId != null) {
          // --- CASE 1B: LABEL COMPONENT SEPARATE ---
          qrResult = 'U1|$companyCode|$componentId';
        } else {
          // --- CASE 1A: LABEL VARIANT (SET) ---
          qrResult = 'U1|$companyCode|$variantId';
        }

        dev.log(qrResult, name: 'QR RESULT');
        final companion = UnitsCompanion.insert(
          id: unitId,
          variantId: Value(
            variantId,
          ), // Variant ID tetap diisi untuk tracking grouping
          componentId: Value(
            componentId,
          ), // Null jika Variant, Terisi jika Component
          rackId: Value(rackId),
          qrValue: qrResult,
          status: const Value('PENDING'),

          // Audit Trails
          createdBy: Value(userId),
          createdAt: now,
          updatedAt: now,

          // Sync Flags
          needSync: const Value(true),
          lastModifiedAt: Value(now),
        );

        // Insert menggunakan DAO atau direct table insert untuk memastikan return value
        // Kita akses table 'units' langsung dari db instance agar return Row object
        final row = await db.into(db.units).insertReturning(companion);
        generatedUnits.add(row);
      }

      return generatedUnits;
    });
  }

  Future<void> recordPrintedUnits({
    required List<String> unitIds,
    required String userId,
  }) async {
    return db.unitDao.markUnitsPrinted(unitIds, userId);
  }

  Future<void> finalizeValidatedUnits({
    required List<String> unitIds,
    required String userId,
  }) async {
    // Gunakan transaction untuk menjamin data konsisten
    await db.transaction(() async {
      // 1. Aktifkan Unit yang dipilih (Parent atau Single Unit)
      await db.unitDao.markUnitsActive(unitIds, userId);

      // 2. CASCADING UPDATE (THE FIX)
      // Cari semua unit 'anak' yang parent_unit_id-nya adalah salah satu dari unitIds yang sedang divalidasi.
      // Update status mereka menjadi 'ACTIVE' juga.

      await (db.update(
        db.units,
      )..where((tbl) => tbl.parentUnitId.isIn(unitIds))).write(
        const UnitsCompanion(
          status: Value('ACTIVE'),
          // Opsional: update lastModifiedAt agar ter-sync ke server
          // lastModifiedAt: Value(DateTime.now()),
        ),
      );
    });
  }

  Future<void> cancelGeneratedUnits({required List<String> unitIds}) async {
    return db.unitDao.deletePendingUnits(unitIds);
  }

  Future<UnitWithRelations?> findUnitByQr(String qr) async {
    return db.unitDao.findByQrWithJoins(qr);
  }

  Future<List<VariantComponentRow>> getVariantComponentsByType({
    required String variantId,
    required String type,
  }) {
    return _variantDao.getVariantComponentsByType(
      variantId: variantId,
      type: type,
    );
  }

  // ... (Sisa method createVariant, createSetUnit, dll biarkan tetap ada seperti sebelumnya)

  /// Setup company_item (is_set, has_components) + create/update 1 variant + photos.
  Future<void> createVariant({
    required bool isSetUp,
    required String companyItemId,
    required String? brandId,
    required String variantName,
    required String uom,
    required String rackId,
    String? specification,
    String? manufCode,
    required List<String> photoLocalPaths,
    required String userId,
  }) async {
    final now = DateTime.now();
    if (photoLocalPaths.isEmpty) {
      throw Exception('Foto produk tidak boleh kosong');
    }
    await db.transaction(() async {
      final companyItem = await _companyItemDao.getById(companyItemId);
      if (companyItem == null) throw Exception('Company item not found');

      if (isSetUp) {
        await _companyItemDao.updateDefaultRackCompanyItem(
          id: companyItemId,
          rackId: rackId,
        );
      }

      final variantId = generateCustomId(variantsPrefix);
      final variantCompanion = VariantsCompanion(
        id: Value(variantId),
        companyItemId: Value(companyItemId),
        brandId: Value(brandId),
        name: Value(variantName),
        uom: Value(uom),
        rackId: Value(rackId),
        specification: Value(specification),
        manufCode: Value(manufCode),
        createdAt: Value(now),
        updatedAt: Value(now),
        lastModifiedAt: Value(now),
        needSync: const Value(true),
      );

      await _variantDao.upsertVariants([variantCompanion]);

      dev.log(variantCompanion.toString(), name: 'CREATE VARIANT');

      final photoCompanions = <VariantPhotosCompanion>[];
      for (var i = 0; i < photoLocalPaths.length; i++) {
        final photoId = generateCustomId(variantPhotosPrefix);
        photoCompanions.add(
          VariantPhotosCompanion(
            id: Value(photoId),
            variantId: Value(variantId),
            localPath: Value(photoLocalPaths[i]),
            remoteUrl: const Value(null),
            sortOrder: Value(i),
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

  /// Membuat 1 unit SET untuk variant (label as set) - Single.
  Future<String> createSetUnit({
    required String variantId,
    String? rackId,
    required String qrValue,
    required String userId,
  }) async {
    final now = DateTime.now();
    final unitId = generateCustomId(unitsPrefix);

    final companion = UnitsCompanion(
      id: Value(unitId),
      variantId: Value(variantId),
      componentId: const Value(null),
      qrValue: Value(qrValue),
      status: const Value('ACTIVE'),
      rackId: Value(rackId),
      printCount: const Value(1),
      lastPrintedAt: Value(now),
      createdBy: Value(userId),
      updatedBy: Value(userId),
      lastPrintedBy: Value(userId),
      lastModifiedAt: Value(now),
      needSync: const Value(true),
      createdAt: Value(now),
      updatedAt: Value(now),
    );

    await _unitDao.insertUnit(companion);
    return unitId;
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

  // (Fitur Assembly / The Boss akan kita update setelah ini)
  @override
  Future<AssemblyResult> assembleComponents({
    required String variantId,
    required List<String> componentUnitIds,
    required String userId,
    required String rackId,
    required String rackName,
  }) async {
    // ... Logic The Boss (Assembly) nanti di sini
    // Saya biarkan dulu agar tidak error
    if (componentUnitIds.length < 2) {
      throw Exception('Minimal butuh 2 komponen untuk assembly');
    }
    final now = DateTime.now();
    return _unitDao.transaction(() async {
      final parentId = generateCustomId(unitsPrefix);
      final parentQr = 'SET-$parentId';

      final parentEntry = UnitsCompanion(
        id: Value(parentId),
        variantId: Value(variantId),
        componentId: const Value(null),
        qrValue: Value(parentQr),
        status: const Value('PENDING'),
        rackId: Value(rackId),
        createdBy: Value(userId),
        updatedBy: Value(userId),
        lastModifiedAt: Value(now),
        needSync: const Value(true),
        createdAt: Value(now),
        updatedAt: Value(now),
      );

      final parentUnit = await _unitDao.insertParentUnit(parentEntry);

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
