// lib/core/db/daos/variant_dao.dart
import 'dart:developer' as dev;

import 'package:drift/drift.dart' hide Component;
import 'package:inventory_sync_apps/core/constant.dart';
import 'package:inventory_sync_apps/core/db/model/photo_row.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import '../app_database.dart';
import '../model/variant_component_row.dart';
import '../model/variant_detail_row.dart';
import '../tables.dart';

part 'variant_dao.g.dart';

@DriftAccessor(
  tables: [
    Brands,
    Products,
    CompanyItems,
    Variants,
    VariantPhotos,
    Components,
    ComponentPhotos,
    VariantComponents,
    Units,
    Racks, // <- tambahkan Racks agar bisa query nama rak
    Warehouses, // <- tambahkan Warehouses agar bisa query nama warehouse
  ],
)
class VariantDao extends DatabaseAccessor<AppDatabase> with _$VariantDaoMixin {
  VariantDao(AppDatabase db) : super(db);

  Future<void> upsertVariants(List<VariantsCompanion> list) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(variants, list);
    });
  }

  /// Variants yang perlu di-push ke server
  Future<List<Variant>> getPendingVariants() {
    return (select(variants)..where((v) => v.needSync.equals(true))).get();
  }

  Future<void> markVariantsSynced(List<String> ids) async {
    if (ids.isEmpty) return;
    await (update(variants)..where((v) => v.id.isIn(ids))).write(
      const VariantsCompanion(needSync: Value(false)),
    );
  }

  /// Get variant by ID (single fetch)
  Future<Variant?> getVariantById(String variantId) async {
    return await (select(
      variants,
    )..where((v) => v.id.equals(variantId))).getSingleOrNull();
  }

  /// Update variant
  Future<void> updateVariant(VariantsCompanion companion) async {
    await (update(
      variants,
    )..where((v) => v.id.equals(companion.id.value))).write(companion);
  }

  Stream<int> watchUnitsCount(String variantId) {
    final q = selectOnly(units)
      ..addColumns([units.id.count()])
      ..where(
        units.variantId.equals(variantId) &
            units.componentId.isNull() &
            units.status.equals(activeStatus),
      );

    return q.watchSingle().map((row) => row.read(units.id.count()) ?? 0);
  }

  Stream<VariantDetailRow?> watchVariantDetail(String variantId) {
    // Join utama: variant + company_item + product + brand
    final base = select(variants).join([
      innerJoin(
        companyItems,
        companyItems.id.equalsExp(variants.companyItemId),
      ),
      innerJoin(products, products.id.equalsExp(companyItems.productId)),
      leftOuterJoin(brands, brands.id.equalsExp(variants.brandId)),
    ])..where(variants.id.equals(variantId));

    // 1) Stream info utama (variant, companyItem, product, brand)
    final infoStream = base.watchSingleOrNull().map((row) {
      if (row == null) return null;

      final v = row.readTable(variants);
      final ci = row.readTable(companyItems);
      final p = row.readTable(products);
      final b = row.readTableOrNull(brands);

      return _VariantBaseInfo(
        variant: v,
        companyItem: ci,
        product: p,
        brand: b,
      );
    });

    // 2) totalUnits reaktif (yang kamu udah bikin)
    final totalUnitsStream = watchUnitsCount(variantId);

    // 3) rackName reaktif (kalau rackId null => null)
    final rackNameStream = infoStream.switchMap((info) {
      final rackId = info?.variant.rackId;
      if (rackId == null) return Stream<String?>.value(null);

      final q = select(racks).join([
        leftOuterJoin(warehouses, warehouses.id.equalsExp(racks.warehouseId)),
      ])..where(racks.id.equals(rackId));

      return q.watchSingleOrNull().map((row) {
        if (row == null) return null;
        final r = row.readTable(racks);
        // Kalau mau pakai warehouse juga:
        // final w = row.readTableOrNull(warehouses);
        // return '${r.name} - ${w?.name}';
        return r.name;
      });
    });

    // 4) Definisi komponen (reaktif saat variantComponents/components berubah)
    final componentsDefStream =
        (select(variantComponents)..where(
              (vc) => vc.variantId.equals(variantId) & vc.deletedAt.isNull(),
            ))
            .join([
              innerJoin(
                components,
                components.id.equalsExp(variantComponents.componentId),
              ),
              leftOuterJoin(brands, brands.id.equalsExp(components.brandId)),
            ])
            .watch()
            .map((rows) {
              return rows.map((row) {
                final vc = row.readTable(variantComponents);
                final c = row.readTable(components);
                final b = row.readTableOrNull(brands);
                return _ComponentDef(vc: vc, c: c, brand: b);
              }).toList();
            });

    // 5) componentsStream FINAL: reaktif saat units berubah juga
    final componentsStream = componentsDefStream.switchMap((defs) {
      final componentIds = defs.map((d) => d.c.id).toList();

      // kalau ga ada komponen
      if (componentIds.isEmpty) return Stream.value(<VariantComponentRow>[]);

      // bikin stream count units ACTIVE per componentId (reaktif)
      final countsQuery = selectOnly(units)
        ..addColumns([units.componentId, units.id.count()])
        ..where(
          units.status.equals(activeStatus) &
              units.componentId.isIn(componentIds) &
              units.variantId.equals(variantId), // <--- TAMBAHAN DI SINI
        )
        ..groupBy([units.componentId]);

      final countsStream = countsQuery.watch().map((rows) {
        final map = <String, int>{};
        for (final row in rows) {
          final cid = row.read(units.componentId);
          final cnt = row.read(units.id.count()) ?? 0;
          if (cid != null) map[cid] = cnt;
        }
        return map;
      });

      // gabung defs + counts -> List<VariantComponentRow>
      return Rx.combineLatest2<
        List<_ComponentDef>,
        Map<String, int>,
        List<VariantComponentRow>
      >(Stream.value(defs), countsStream, (defs, countsMap) {
        return defs.map((d) {
          final c = d.c;
          final b = d.brand;

          final unitsCount = countsMap[c.id] ?? 0;

          return VariantComponentRow(
            quantity: d.vc.quantity,
            variantId: d.vc.variantId,
            componentId: c.id,
            name: c.name,
            manufCode: c.manufCode,
            brandName: b?.name,
            totalUnits: unitsCount,
            type: c.type, // IN_BOX / SEPARATE
          );
        }).toList();
      });
    });

    // 6) Gabung semuanya -> VariantDetailRow (return sama kayak punyamu)
    // --- REVISI: 6) Stream Photos dari tabel VariantPhotos ---
    final photosStream =
        (select(variantPhotos)
              ..where((t) => t.variantId.equals(variantId))
              ..orderBy([
                (t) => OrderingTerm(expression: t.sortOrder),
              ])) // Urutkan 0,1,2..
            .watch()
            .map((rows) {
              // print(
              //   'DEBUG DAO: Found ${rows.length} photos for variant $variantId',
              // );
              return rows.map((row) {
                // print(
                //   'DEBUG DAO: Photo ID: ${row.id}, Local: ${row.localPath}, Remote: ${row.remoteUrl}',
                // );
                return PhotoRow(
                  id: row.id,
                  localPath: row.localPath,
                  remoteUrl: row.remoteUrl,
                );
              }).toList();
            });

    // --- REVISI: 7) CombineLatest5 ---
    return Rx.combineLatest5<
      _VariantBaseInfo?,
      int,
      String?,
      List<VariantComponentRow>,
      List<PhotoRow>, // Tipe data berubah
      VariantDetailRow?
    >(
      infoStream,
      totalUnitsStream,
      rackNameStream,
      componentsStream,
      photosStream,
      (
        info,
        totalUnits,
        rackName,
        comps,
        photos, // Variable baru
      ) {
        if (info == null) return null;

        final variant = info.variant;
        final ci = info.companyItem;
        final p = info.product;
        final b = info.brand;

        final compsSeparate = comps
            .where((c) => c.type == separateType)
            .toList();
        final compsInBox = comps.where((c) => c.type == inBoxType).toList();

        return VariantDetailRow(
          variantId: variant.id,
          companyItemId: ci.id,
          productId: p.id,
          name: variant.name,
          uom: variant.uom,
          uomId: variant.uomId,
          manufCode: variant.manufCode,
          brandId: variant.brandId,
          brandName: b?.name,
          rackId: variant.rackId,
          rackName: rackName,
          specification: variant.specification,
          companyCode: ci.companyCode,
          totalUnits: totalUnits,
          componentsSeparate: compsSeparate,
          componentsInBox: compsInBox,
          photos: photos, // Masukkan list VariantPhotoRow
        );
      },
    );
  }

  Future<Component> createComponentForProduct({
    required String productId,
    String? brandId,
    required String name,
    String? manufCode,
    String? specification,
    int type = separateType, // default SEPARATE
  }) async {
    final companion = ComponentsCompanion.insert(
      id: Uuid().v4(),
      productId: productId,
      brandId: Value(brandId),
      name: name,
      manufCode: Value(manufCode),
      specification: Value(specification),
      type: Value(type),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return into(components).insertReturning(companion);
  }

  /// Ambil list komponen untuk product tertentu dan type tertentu (non-stream)
  Future<List<Component>> getComponentsByProductAndType({
    required String productId,
    required int type, // inBoxType atau separateType
  }) {
    return (select(
      components,
    )..where((c) => c.productId.equals(productId) & c.type.equals(type))).get();
  }

  Stream<List<VariantComponentRow>> watchVariantComponentsByType({
    required String variantId,
    required int type, // inBoxType atau separateType
  }) {
    final q =
        (select(
          variantComponents,
        )..where((vc) => vc.variantId.equals(variantId))).join([
          innerJoin(
            components,
            components.id.equalsExp(variantComponents.componentId),
          ),
          leftOuterJoin(brands, brands.id.equalsExp(components.brandId)),
        ]);

    return q.watch().asyncMap((rows) async {
      final List<VariantComponentRow> res = [];
      for (final row in rows) {
        final c = row.readTable(components);
        if (c.type != type) continue; // filter by type

        final b = row.readTableOrNull(brands);

        // 👇 FIX: Read variant_components table untuk ambil quantity
        final vc = row.readTable(variantComponents);

        final count =
            await (select(units)..where(
                  (u) =>
                      u.componentId.equals(c.id) &
                      u.status.equals(activeStatus),
                ))
                .get()
                .then((l) => l.length);

        res.add(
          VariantComponentRow(
            quantity: vc.quantity, // ✅ Ambil dari join result!
            variantId: variantId,
            componentId: c.id,
            name: c.name,
            manufCode: c.manufCode,
            brandName: b?.name,
            totalUnits: count,
            type: c.type,
          ),
        );
      }
      return res;
    });
  }

  Future<List<VariantComponentRow>> getVariantComponentsByType({
    required String variantId,
    required int type, // inBoxType atau separateType
  }) async {
    final q =
        (select(
          variantComponents,
        )..where((vc) => vc.variantId.equals(variantId))).join([
          innerJoin(
            components,
            components.id.equalsExp(variantComponents.componentId),
          ),
          leftOuterJoin(brands, brands.id.equalsExp(components.brandId)),
        ]);

    final rows = await q.get();
    final List<VariantComponentRow> res = [];

    for (final row in rows) {
      final c = row.readTable(components);
      if (c.type != type) continue; // filter by type

      final b = row.readTableOrNull(brands);

      // FIX: Read variant_components table untuk ambil quantity
      final vc = row.readTable(variantComponents);

      final count =
          await (select(units)..where(
                (u) =>
                    u.componentId.equals(c.id) & u.status.equals(activeStatus),
              ))
              .get()
              .then((l) => l.length);

      res.add(
        VariantComponentRow(
          quantity: vc.quantity, // Ambil dari join result!
          variantId: variantId,
          componentId: c.id,
          name: c.name,
          manufCode: c.manufCode,
          brandName: b?.name,
          totalUnits: count,
          type: c.type,
        ),
      );
    }
    return res;
  }

  Future<void> updateVariantComponentQuantity({
    required String variantId,
    required String componentId,
    required int quantity,
  }) async {
    await (update(variantComponents)..where(
          (vc) =>
              vc.variantId.equals(variantId) &
              vc.componentId.equals(componentId),
        ))
        .write(
          VariantComponentsCompanion(
            quantity: Value(quantity),
            updatedAt: Value(DateTime.now()),
            lastModifiedAt: Value(DateTime.now()),
            needSync: Value(true),
          ),
        );
  }

  /// Create in-box component AND attach to variant in ONE transaction.
  /// Berguna untuk flow "create in-box part then register it for variant".
  Future<Component> createComponentAndAttach({
    required String variantId,
    required String productId,
    String? brandId,
    required String name,
    String? manufCode,
    String? specification,
    required List<String> photos,
  }) async {
    return transaction<Component>(() async {
      // 1) buat komponen type IN_BOX
      final comp = await createComponentForProduct(
        productId: productId,
        brandId: brandId,
        name: name,
        manufCode: manufCode,
        specification: specification,
        type: inBoxType,
      );

      // 1.5) (optional) simpan photos ke tabel terpisah jika perlu
      for (final path in photos) {
        final photoCompanion = ComponentPhotosCompanion.insert(
          id: Uuid().v4(),
          componentId: comp.id,
          localPath: Value(path),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          needSync: const Value(true),
          lastModifiedAt: Value(DateTime.now()),
        );
        await into(componentPhotos).insert(photoCompanion);
      }

      // 2) attach ke variant
      final insertable = VariantComponentsCompanion.insert(
        id: Uuid().v4(),
        variantId: variantId,
        componentId: comp.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await into(variantComponents).insertOnConflictUpdate(insertable);

      return comp;
    });
  }

  /// List semua komponen untuk product tertentu (dipakai saat "Tambah Komponen")
  Future<List<Component>> getComponentsByProduct(String productId) {
    return (select(
      components,
    )..where((c) => c.productId.equals(productId))).get();
  }

  /// Hubungkan komponen ke variant (variant_components)
  Future<void> attachComponentToVariant({
    required String variantId,
    required String componentId,
  }) async {
    final insertable = VariantComponentsCompanion.insert(
      id: Uuid().v4(),
      variantId: variantId,
      componentId: componentId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      needSync: Value(true),
      lastModifiedAt: Value(DateTime.now()),
    );

    dev.log(insertable.toString(), name: 'VARIANT COMPONENT');

    await into(variantComponents).insertOnConflictUpdate(insertable);
  }

  /// Lepaskan komponen dari variant (tanpa menghapus component)
  Future<void> detachComponentFromVariant({
    required String variantId,
    required String componentId,
  }) async {
    await (update(variantComponents)..where(
          (vc) =>
              vc.variantId.equals(variantId) &
              vc.componentId.equals(componentId),
        ))
        .write(
          VariantComponentsCompanion(
            deletedAt: Value(DateTime.now()), // Tandai terhapus
            needSync: const Value(true), // Trigger sync
            lastModifiedAt: Value(DateTime.now()),
          ),
        );
  }

  /// Optional: hapus komponen (kalau yakin tidak dipakai di variant lain)
  Future<void> deleteComponent(String componentId) async {
    await (delete(components)..where((c) => c.id.equals(componentId))).go();
  }
}

/// Per-barisan komponen yang dikembalikan ke UI

/// DTO variant detail

class _VariantBaseInfo {
  final Variant variant;
  final CompanyItem companyItem;
  final Product product;
  final Brand? brand;

  _VariantBaseInfo({
    required this.variant,
    required this.companyItem,
    required this.product,
    required this.brand,
  });
}

class _ComponentDef {
  final VariantComponent vc;
  final Component c;
  final Brand? brand;

  _ComponentDef({required this.vc, required this.c, required this.brand});
}
