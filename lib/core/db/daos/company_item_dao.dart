// lib/core/db/daos/company_item_dao.dart
import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart'; // ini yg nge-export tables + generated

part 'company_item_dao.g.dart';

@DriftAccessor(tables: [CompanyItems, Products, Variants, Units, Brands])
class CompanyItemDao extends DatabaseAccessor<AppDatabase>
    with _$CompanyItemDaoMixin {
  CompanyItemDao(super.db);

  /// Cari berdasarkan company code atau nama produk
  Future<List<CompanyItemWithProduct>> searchByQuery(String query) async {
    final q = '%${query.trim()}%';

    final joinQuery = select(companyItems).join([
      innerJoin(products, products.id.equalsExp(companyItems.productId)),
    ])..where(companyItems.companyCode.like(q) | products.name.like(q));

    final rows = await joinQuery.get();

    return rows
        .map(
          (row) => CompanyItemWithProduct(
            item: row.readTable(companyItems), // -> CompanyItem
            product: row.readTable(products), // -> Product
          ),
        )
        .toList();
  }

  Stream<List<CompanyItemListRow>> watchCompanyItemsWithStock({
    String? productId, // optional, kalau mau filter per product
  }) {
    final base = select(companyItems).join([
      innerJoin(products, products.id.equalsExp(companyItems.productId)),
      leftOuterJoin(
        variants,
        variants.companyItemId.equalsExp(companyItems.id),
      ),
      leftOuterJoin(
        units,
        units.variantId.equalsExp(variants.id) & units.status.equals('ACTIVE'),
      ),
    ]);

    if (productId != null) {
      base.where(products.id.equals(productId));
    }

    return base.watch().map((rows) {
      final map = <String, CompanyItemListRow>{};

      for (final row in rows) {
        final ci = row.readTable(companyItems);
        final p = row.readTable(products);
        final u = row.readTableOrNull(units);

        map.putIfAbsent(
          ci.id,
          () => CompanyItemListRow(
            companyItemId: ci.id,
            companyCode: ci.companyCode,
            productName: p.name,
            categoryName:
                null, // atau ambil dari join category kalau kamu tambahkan
            totalUnits: 0,
          ),
        );

        if (u != null) {
          final current = map[ci.id]!;
          map[ci.id] = current.copyWith(totalUnits: current.totalUnits + 1);
        }
      }

      return map.values.toList()
        ..sort((a, b) => a.companyCode.compareTo(b.companyCode));
    });
  }

  Stream<List<CompanyItemVariantRow>> watchVariantsWithStock(
    String companyItemId,
  ) {
    // join variants (per company item) + brand + units aktif
    final query =
        (select(
          variants,
        )..where((v) => v.companyItemId.equals(companyItemId))).join([
          leftOuterJoin(brands, brands.id.equalsExp(variants.brandId)),
          leftOuterJoin(
            units,
            units.variantId.equalsExp(variants.id) &
                units.status.equals('ACTIVE'),
          ),
        ]);

    return query.watch().map((rows) {
      final map = <String, CompanyItemVariantRow>{};

      for (final row in rows) {
        final v = row.readTable(variants);
        final b = row.readTableOrNull(brands);
        final u = row.readTableOrNull(units);

        map.putIfAbsent(
          v.id,
          () => CompanyItemVariantRow(
            variantId: v.id,
            name: v.name,
            brandName: b?.name,
            defaultLocation: v.defaultLocation,
            stock: 0,
          ),
        );

        if (u != null) {
          final current = map[v.id]!;
          map[v.id] = current.copyWith(stock: current.stock + 1);
        }
      }

      return map.values.toList();
    });
  }

  Future<CompanyItem?> getById(String id) {
    return (select(
      companyItems,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> updateCompanyItem(
    String id, {
    required bool isSet,
    required bool hasComponents,
    required DateTime initializedAt,
    required String initializedBy,
  }) async {
    await (update(companyItems)..where((t) => t.id.equals(id))).write(
      CompanyItemsCompanion(
        isSet: Value(isSet),
        hasComponents: Value(hasComponents),
        initializedAt: Value(initializedAt),
        initializedBy: Value(initializedBy),
        lastModifiedAt: Value(initializedAt),
        needSync: const Value(true),
      ),
    );
  }

  Future<void> upsertCompanyItems(List<CompanyItemsCompanion> list) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(companyItems, list);
    });
  }

  /// Variants yang perlu di-push ke server
  Future<List<CompanyItem>> getPendingCompanyItems() {
    return (select(companyItems)..where((v) => v.needSync.equals(true))).get();
  }

  Future<void> markCompanyItemsSynced(List<String> ids) async {
    if (ids.isEmpty) return;
    await (update(companyItems)..where((v) => v.id.isIn(ids))).write(
      const CompanyItemsCompanion(needSync: Value(false)),
    );
  }
}

class CompanyItemWithProduct {
  final CompanyItem item;
  final Product product;

  CompanyItemWithProduct({required this.item, required this.product});
}

class CompanyItemVariantRow {
  final String variantId;
  final String name;
  final String? brandName;
  final String? defaultLocation;
  final int stock;

  CompanyItemVariantRow({
    required this.variantId,
    required this.name,
    this.brandName,
    this.defaultLocation,
    required this.stock,
  });

  CompanyItemVariantRow copyWith({int? stock}) {
    return CompanyItemVariantRow(
      variantId: variantId,
      name: name,
      brandName: brandName,
      defaultLocation: defaultLocation,
      stock: stock ?? this.stock,
    );
  }
}

class CompanyItemListRow {
  final String companyItemId;
  final String companyCode;
  final String productName;
  final String? categoryName; // kalau mau sekalian
  final int totalUnits; // total unit aktif untuk kode ini

  CompanyItemListRow({
    required this.companyItemId,
    required this.companyCode,
    required this.productName,
    this.categoryName,
    required this.totalUnits,
  });

  CompanyItemListRow copyWith({int? totalUnits}) {
    return CompanyItemListRow(
      companyItemId: companyItemId,
      companyCode: companyCode,
      productName: productName,
      categoryName: categoryName,
      totalUnits: totalUnits ?? this.totalUnits,
    );
  }
}
