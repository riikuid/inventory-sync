// lib/core/db/daos/variant_dao.dart
import 'package:drift/drift.dart' hide Component;
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import '../app_database.dart';
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

    // Stream pertama: info variant + stok total per variant (unit yang component_id IS NULL)
    final variantStream = base.watchSingleOrNull().asyncMap((row) async {
      if (row == null) return null;

      final v = row.readTable(variants);
      final ci = row.readTable(companyItems);
      final p = row.readTable(products);
      final b = row.readTableOrNull(brands);

      // hitung total unit ACTIVE untuk variant ini, hanya untuk unit yang merupakan parent (component_id IS NULL)
      final unitsCount =
          await (select(units)..where(
                (u) =>
                    u.variantId.equals(v.id) &
                    u.componentId.isNull() &
                    u.status.equals('ACTIVE'),
              ))
              .get()
              .then((list) => list.length);

      // ambil rack name jika ada
      String? rackName;
      if (v.rackId != null) {
        final r = await (select(
          racks,
        )..where((rk) => rk.id.equals(v.rackId!))).getSingleOrNull();
        if (r != null) {
          final w = await (select(
            warehouses,
          )..where((w) => w.id.equals(r.warehouseId))).getSingleOrNull();
          rackName = '${r.name} - ${w?.name}';
        }
      }

      return {
        'variant': v,
        'companyItem': ci,
        'product': p,
        'brand': b,
        'totalUnits': unitsCount,
        'rackName': rackName,
      };
    });

    // Stream kedua: list komponen + stok per komponen + type (IN_BOX / SEPARATE)
    final componentsStream =
        (select(variantComponents)
              ..where((vc) => vc.variantId.equals(variantId)))
            .join([
              innerJoin(
                components,
                components.id.equalsExp(variantComponents.componentId),
              ),
              leftOuterJoin(brands, brands.id.equalsExp(components.brandId)),
            ])
            .watch()
            .asyncMap((rows) async {
              final List<VariantComponentRow> result = [];

              for (final row in rows) {
                final vc = row.readTable(variantComponents);
                final c = row.readTable(components);
                final b = row.readTableOrNull(brands);

                final unitsCount =
                    await (select(units)..where(
                          (u) =>
                              u.componentId.equals(c.id) &
                              u.status.equals('ACTIVE'),
                        ))
                        .get()
                        .then((list) => list.length);

                result.add(
                  VariantComponentRow(
                    componentId: c.id,
                    name: c.name,
                    manufCode: c.manufCode,
                    brandName: b?.name,
                    totalUnits: unitsCount,
                    type: c.type, // ambil type dari kolom components.type
                  ),
                );
              }

              return result;
            });

    // gabung dua stream
    return Rx.combineLatest2(variantStream, componentsStream, (
      dynamic a,
      List<VariantComponentRow> comps,
    ) {
      if (a == null) return null;
      final variant = a['variant'] as Variant;
      final ci = a['companyItem'] as CompanyItem;
      final p = a['product'] as Product;
      final b = a['brand'] as Brand?;
      final totalUnits = a['totalUnits'] as int;
      final rackName = a['rackName'] as String?;

      final compsSeparate = comps.where((c) => c.type == 'SEPARATE').toList();
      final compsInBox = comps.where((c) => c.type == 'IN_BOX').toList();

      // Pada saat mengembalikan komponen, kita bisa serahkan semuanya dan UI nanti memfilter berdasarkan VariantComponentRow.type
      return VariantDetailRow(
        variantId: variant.id,
        companyItemId: ci.id,
        productId: p.id,
        name: variant.name,
        uom: variant.uom,
        brandId: variant.brandId,
        brandName: b?.name,
        rackId: variant.rackId,
        rackName: rackName,
        specification: variant.specification,
        companyCode: ci.companyCode,
        totalUnits: totalUnits,
        componentsSeparate: compsSeparate,
        componentsInBox: compsInBox,
      );
    });
  }

  Future<Component> createComponentForProduct({
    required String productId,
    String? brandId,
    required String name,
    String? manufCode,
    String? specification,
    String type = 'SEPARATE', // default SEPARATE
  }) async {
    final companion = ComponentsCompanion.insert(
      id: Uuid().v4(),
      productId: productId,
      brandId: Value(brandId),
      name: name,
      manufCode: Value(manufCode),
      specification: Value(specification),
      type: type,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return into(components).insertReturning(companion);
  }

  /// Ambil list komponen untuk product tertentu dan type tertentu (non-stream)
  Future<List<Component>> getComponentsByProductAndType({
    required String productId,
    required String type, // 'IN_BOX' atau 'SEPARATE'
  }) {
    return (select(
      components,
    )..where((c) => c.productId.equals(productId) & c.type.equals(type))).get();
  }

  /// Watch variant_components (join) tapi hanya yang komponen type == given type
  Stream<List<VariantComponentRow>> watchVariantComponentsByType({
    required String variantId,
    required String type, // 'IN_BOX' atau 'SEPARATE'
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

        final count =
            await (select(units)..where(
                  (u) => u.componentId.equals(c.id) & u.status.equals('ACTIVE'),
                ))
                .get()
                .then((l) => l.length);

        res.add(
          VariantComponentRow(
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
        type: 'IN_BOX',
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
    );

    await into(variantComponents).insertOnConflictUpdate(insertable);
  }

  /// Lepaskan komponen dari variant (tanpa menghapus component)
  Future<void> detachComponentFromVariant({
    required String variantId,
    required String componentId,
  }) async {
    await (delete(variantComponents)..where(
          (vc) =>
              vc.variantId.equals(variantId) &
              vc.componentId.equals(componentId),
        ))
        .go();
  }

  /// Optional: hapus komponen (kalau yakin tidak dipakai di variant lain)
  Future<void> deleteComponent(String componentId) async {
    await (delete(components)..where((c) => c.id.equals(componentId))).go();
  }
}

/// Per-barisan komponen yang dikembalikan ke UI
class VariantComponentRow {
  final String componentId;
  final String name;
  final String? manufCode;
  final String? brandName;
  final int totalUnits; // unit ACTIVE untuk komponen ini
  final String type; // 'IN_BOX' or 'SEPARATE'

  VariantComponentRow({
    required this.componentId,
    required this.name,
    this.manufCode,
    this.brandName,
    required this.totalUnits,
    required this.type,
  });
}

/// DTO variant detail
class VariantDetailRow {
  final String variantId;
  final String companyItemId;
  final String productId;
  final String name;
  final String uom;
  final String? specification;
  final String? rackId;
  final String? rackName;
  final String? brandId;
  final String? brandName;
  final String companyCode;
  final int
  totalUnits; // semua unit ACTIVE untuk variant ini (component_id IS NULL)
  final List<VariantComponentRow> componentsInBox;
  final List<VariantComponentRow> componentsSeparate;

  VariantDetailRow({
    required this.variantId,
    required this.companyItemId,
    required this.productId,
    required this.name,
    required this.uom,
    this.brandId,
    this.brandName,
    this.rackId,
    this.rackName,
    this.specification,
    required this.companyCode,
    required this.totalUnits,
    required this.componentsSeparate,
    required this.componentsInBox,
  });
}
