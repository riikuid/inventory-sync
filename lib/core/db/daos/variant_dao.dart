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
    Components,
    VariantComponents,
    Units,
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

    // Stream pertama: info variant + stok total per variant
    final variantStream = base.watchSingleOrNull().asyncMap((row) async {
      if (row == null) return null;

      final v = row.readTable(variants);
      final ci = row.readTable(companyItems);
      final p = row.readTable(products);
      final b = row.readTableOrNull(brands);

      // hitung total unit ACTIVE untuk variant ini
      final unitsCount =
          await (select(units)..where(
                (u) => u.variantId.equals(v.id) & u.status.equals('ACTIVE'),
              ))
              .get()
              .then((list) => list.length);

      return {
        'variant': v,
        'companyItem': ci,
        'product': p,
        'brand': b,
        'totalUnits': unitsCount,
      };
    });

    // Stream kedua: list komponen + stok per komponen
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

      return VariantDetailRow(
        variantId: variant.id,
        companyItemId: ci.id,
        productId: p.id,
        name: variant.name,
        uom: variant.uom,
        brandId: variant.brandId,
        brandName: b?.name,
        companyCode: ci.companyCode,
        rackId: variant.rackId,
        rackName: null, // You might want to fetch this from somewhere
        specification: variant.specification,
        totalUnits: totalUnits,
        components: comps,
      );
    });
  }

  /// List semua komponen untuk product tertentu (dipakai saat "Tambah Komponen")
  Future<List<Component>> getComponentsByProduct(String productId) {
    return (select(
      components,
    )..where((c) => c.productId.equals(productId))).get();
  }

  /// Buat komponen baru untuk product (brand default mengikuti variant)
  Future<Component> createComponentForProduct({
    required String productId,
    String? brandId,
    required String name,
    String? manufCode,
    String? specification,
  }) async {
    final companion = ComponentsCompanion.insert(
      id: Uuid().v4(), // kalau pakai uuid manual, isi Value(uuid)
      productId: productId,
      brandId: Value(brandId),
      name: name,
      manufCode: Value(manufCode),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      specification: Value(specification), type: 'SEPARATE',
    );

    return into(components).insertReturning(companion);
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

class VariantComponentRow {
  final String componentId;
  final String name;
  final String? manufCode;
  final String? brandName;
  final int totalUnits; // unit ACTIVE untuk komponen ini

  VariantComponentRow({
    required this.componentId,
    required this.name,
    this.manufCode,
    this.brandName,
    required this.totalUnits,
  });
}

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
  final int totalUnits; // semua unit ACTIVE untuk variant ini
  final List<VariantComponentRow> components;

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
    required this.components,
  });
}
