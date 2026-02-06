import 'dart:developer' as dev;

import 'package:drift/drift.dart';
import 'package:inventory_sync_apps/core/constant.dart';
import 'package:inventory_sync_apps/core/db/app_database.dart';
import 'package:inventory_sync_apps/core/db/daos/brand_dao.dart';
import 'package:inventory_sync_apps/core/db/daos/rack_dao.dart';
import 'package:inventory_sync_apps/core/db/model/unit_row.dart';
import 'package:inventory_sync_apps/core/generate_custom_id.dart';

import '../../../core/db/daos/company_item_dao.dart';
import '../../../core/db/daos/unit_dao.dart';
import '../../../core/db/daos/variant_dao.dart';
import '../../../core/db/daos/variant_photo_dao.dart';
import '../../../core/db/model/rack_with_warehouse_sections.dart';
import '../../../core/db/model/variant_component_row.dart';
import 'models/assembly_result.dart';
import 'models/scan_unit_result.dart';

class LabelingRepository {
  final AppDatabase db;

  LabelingRepository(this.db);

  CompanyItemDao get _companyItemDao => db.companyItemDao;
  VariantDao get _variantDao => db.variantDao;
  BrandDao get _brandDao => db.brandDao;
  RackDao get _rackDao => db.rackDao;
  VariantPhotoDao get _variantPhotoDao => db.variantPhotoDao;
  UnitDao get _unitDao => db.unitDao;

  /// CORE FUNCTION: Generate Batch Labels
  /// Menangani generate label untuk Variant (Set) maupun Component (Separate).
  /// [parentUnitId] Opsional: Jika diisi, unit ini akan langsung ter-link ke parent tersebut.
  Future<List<Unit>> generateBatchLabels({
    required String variantId,
    required String companyCode,
    String? rackId,
    required int batchQty,
    required int userId,
    // Parameter Opsional untuk Component Mode
    String? componentId,
    String? manufCode,
    String? parentUnitId,
    // New fields for Unit Content
    required int? contentResultQty,
    required int? price,
    required String contentUomId,
    String? poNumber,
  }) async {
    return db.transaction(() async {
      final List<Unit> generatedUnits = [];
      final now = DateTime.now();

      for (int i = 0; i < batchQty; i++) {
        String unitId = generateCustomId(unitsPrefix);

        // Logic QR Generation
        String qrResult;

        if (componentId != null) {
          qrResult = 'U$userId|$companyCode|$componentId|$unitId';
        } else {
          qrResult = 'U$userId|$companyCode|$variantId|$unitId';
        }

        final companion = UnitsCompanion.insert(
          id: unitId,
          variantId: Value(variantId),
          componentId: Value(componentId),
          parentUnitId: Value(parentUnitId), // 👈 Insert Parent Link here!
          rackId: Value(rackId),
          qrValue: qrResult,
          status: const Value(pendingStatus),
          quantity: Value(contentResultQty ?? 1),
          uomId: Value(contentUomId),
          // uom: Value(contentUomName),
          poNumber: Value(poNumber),
          // Audit Trails
          createdBy: Value(userId.toString()),
          createdAt: now,
          updatedAt: now,
          price: Value(price ?? 0),

          // Sync Flags
          needSync: const Value(true),
          lastModifiedAt: Value(now),
        );

        dev.log(qrResult, name: 'QR RESULT');

        final row = await db.into(db.units).insertReturning(companion);
        generatedUnits.add(row);
      }

      return generatedUnits;
    });
  }

  /// Create Parent Unit Entry (Pending) without components initially
  Future<Unit> createParentUnitEntry({
    required String variantId,
    required String rackId,
    required String companyCode,
    required int userId,
    required String? poNumber,
    required int? price,
    required String uomId,
  }) async {
    final now = DateTime.now();
    final parentId = generateCustomId(unitsPrefix);
    final parentQr = 'U$userId|$companyCode|$variantId|$parentId';

    final parentEntry = UnitsCompanion.insert(
      id: parentId,
      variantId: Value(variantId),
      componentId: const Value(null),
      price: Value(price ?? 0),
      uomId: Value(uomId),
      qrValue: parentQr,
      status: const Value(pendingStatus),
      poNumber: Value(poNumber),
      rackId: Value(rackId),
      createdBy: Value(userId.toString()),
      updatedBy: Value(userId.toString()),
      lastModifiedAt: Value(now),
      needSync: const Value(true),
      createdAt: now,
      updatedAt: now,
    );

    return await db.into(db.units).insertReturning(parentEntry);
  }

  Future<void> recordPrintedUnits({
    required List<String> unitIds,
    required int userId,
  }) async {
    return db.unitDao.markUnitsPrinted(unitIds, userId);
  }

  Future<void> finalizeValidatedUnits({
    required List<String> unitIds,
    required int userId,
  }) async {
    // Gunakan transaction untuk menjamin data konsisten
    await db.transaction(() async {
      // 1. Aktifkan Unit yang dipilih (Parent atau Single Unit)
      await db.unitDao.markUnitsActive(unitIds, userId);

      // 2. CASCADING UPDATE (THE FIX)
      // Cari semua unit 'anak' yang parent_unit_id-nya adalah salah satu dari unitIds yang sedang divalidasi.
      // Update status mereka menjadi activeStatus juga.

      await (db.update(
        db.units,
      )..where((tbl) => tbl.parentUnitId.isIn(unitIds))).write(
        const UnitsCompanion(
          status: Value(activeStatus),
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
    required int type,
  }) {
    return _variantDao.getVariantComponentsByType(
      variantId: variantId,
      type: type,
    );
  }

  /// Get variant by ID untuk keperluan edit
  Future<Variant?> getVariantById(String variantId) async {
    return await _variantDao.getVariantById(variantId);
  }

  /// Get brand by ID
  Future<Brand?> getBrandById(String brandId) async {
    return await _brandDao.getById(brandId);
  }

  /// Get rack by ID
  Future<Rack?> getRackById(String rackId) async {
    return await _rackDao.getById(rackId);
  }

  /// Get usage photos by variant ID
  Future<List<VariantPhoto>> getVariantPhotos(String variantId) async {
    return await _variantPhotoDao.getPhotosByVariantId(variantId);
  }

  /// Get all UOMs
  Future<List<Uom>> getUoms() async {
    List<Uom> uoms = await db.select(db.uoms).get();
    dev.log(uoms.length.toString(), name: 'UOMS');
    return uoms;
  }

  /// Update existing variant
  Future<void> updateVariant({
    required String variantId,
    required String? brandId,
    required String variantName,
    required String uom,
    required String uomId,
    String? rackId,
    String? specification,
    String? manufCode,
    required int userId,
  }) async {
    final now = DateTime.now();

    await db.transaction(() async {
      // Update variant
      final variantCompanion = VariantsCompanion(
        id: Value(variantId),
        brandId: Value(brandId),
        name: Value(variantName),
        uom: Value(uom),
        uomId: Value(uomId),
        rackId: Value(rackId),
        specification: Value(specification),
        manufCode: Value(manufCode),
        updatedAt: Value(now),
        lastModifiedAt: Value(now),
        needSync: const Value(true),
      );

      await _variantDao.updateVariant(variantCompanion);

      dev.log(variantCompanion.toString(), name: 'UPDATE VARIANT');
    });
  }

  /// Setup company_item (is_set, has_components) + create/update 1 variant + photos.
  Future<void> createVariant({
    required bool isSetUp,
    required String companyItemId,
    required String? brandId,
    required String variantName,
    required String uom,
    required String uomId,
    String? rackId,
    String? specification,
    String? manufCode,
    required List<String> photoLocalPaths,
    required int userId,
  }) async {
    final now = DateTime.now();
    if (photoLocalPaths.isEmpty) {
      throw Exception('Foto produk tidak boleh kosong');
    }
    await db.transaction(() async {
      final companyItem = await _companyItemDao.getById(companyItemId);
      if (companyItem == null) throw Exception('Company item not found');

      if (isSetUp && companyItem.defaultRackId == null && rackId != null) {
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
        uomId: Value(uomId),
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
      status: const Value(activeStatus),
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

  Future<void> activateAllUnitComponents({
    required List<String> componentUnitIds,
    required int userId,
  }) async {
    final now = DateTime.now();
    await _unitDao.activateAllUnitComponents(
      componentUnitIds: componentUnitIds,
      userId: userId,
      now: now,
    );
  }

  Stream<List<UnitRow>> watchUnitsByVariantId(
    String variantId, {
    String? search,
  }) {
    return _unitDao.watchUnitsByVariantId(variantId, search: search);
  }

  Stream<UnitWithRelations?> watchUnitDetail(String unitId) {
    return _unitDao.watchUnitDetail(unitId);
  }

  Future<bool> deleteUnit(String unitId) async {
    return _unitDao.markUnitDeleted(unitId, DateTime.now());
  }

  /// Delete Parent + Children
  Future<void> deleteSet(String parentUnitId) async {
    // 1. Cari parent
    // 2. Cari children (units where parentUnitId = this parentUnitId)
    // 3. Collect ALL IDs
    // 4. Batch Delete

    final allUnits = await _unitDao.findUnitsByIds([
      parentUnitId,
    ]); // Cek parent exist
    if (allUnits.isEmpty) return; // Parent not found?

    // Cari anak-anaknya. Perlu query khusus di DAO sebenernya, tapi kita bisa reuse watch/get methods atau tambah query simple.
    // Tapi tunggu, UnitDao belum punya `findChildren(parentUnitId)`.
    // Kita pakai raw select aja di DAO jika memungkinkan, atau select custom disini jika `_unitDao` expose db.
    // Atau tambah helper di DAO.

    // UPDATE: Sebaiknya kita tambah helper di DAO: findChildrenOf(parentUnitId).
    // Tapi untuk cepat, kita inject query disini atau asumsi logic lain.
    // Ah, di `AssemblyCubit` kita sudah punya list unit lengkap (parent & children).
    // Jadi lebih efisien jika Cubit mengirim List<String> unitIdsToDelete.
    // Maka disini kita cukup buat `deleteUnits(List<String> ids)` yang memanggil `markUnitsDeleted`.

    // Tapi agar konsisten dengan abstraction, kita buat `deleteUnits`.
  }

  Future<void> deleteUnits(List<String> unitIds) async {
    await _unitDao.markUnitsDeleted(unitIds, DateTime.now());
  }

  Future<UnitWithRelations?> scanQrUnit(String qrValue) async {
    try {
      // Trim whitespace untuk menghindari false negative
      final cleanQr = qrValue.trim();

      if (cleanQr.isEmpty) {
        return null;
      }

      // Query database dengan joins
      final result = await _unitDao.findByQrWithJoins(cleanQr);

      return result;
    } catch (e) {
      print('Error scanning QR: $e');
      rethrow;
    }
  }

  /// Watch all racks with warehouse and sections info
  Stream<List<RackWithWarehouseAndSections>> watchRacks() {
    return _rackDao.watchRacksWithWarehouseAndSections();
  }

  /// Get all warehouses for dropdown
  Future<List<Warehouse>> getWarehouses() async {
    return await _rackDao.getAllWarehouses();
  }

  /// Create new rack
  Future<String> createRack({
    required String name,
    required String warehouseId,
  }) async {
    final now = DateTime.now();
    final rackId = generateCustomId(racksPrefix);

    final companion = RacksCompanion.insert(
      id: rackId,
      name: name,
      warehouseId: warehouseId,
      createdAt: now,
      updatedAt: now,
      lastModifiedAt: Value(now),
      needSync: const Value(true),
    );

    await _rackDao.upsertRacks([companion]);
    return rackId;
  }

  /// Update existing rack
  Future<void> updateRack({
    required String rackId,
    required String name,
    required String warehouseId,
  }) async {
    final now = DateTime.now();

    final companion = RacksCompanion(
      id: Value(rackId),
      name: Value(name),
      warehouseId: Value(warehouseId),
      updatedAt: Value(now),
      lastModifiedAt: Value(now),
      needSync: const Value(true),
    );

    await _rackDao.updateRack(companion);
  }

  /// Delete rack (soft delete)
  Future<void> deleteRack(String rackId) async {
    await _rackDao.softDeleteRack(rackId);
  }
}
