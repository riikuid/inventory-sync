// lib/core/db/daos/company_item_dao.dart
import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart'; // ini yg nge-export tables + generated

part 'company_item_dao.g.dart';

@DriftAccessor(tables: [CompanyItems, Products, Variants, Units, Brands, Racks])
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
    String? productId,
  }) {
    final base = select(companyItems).join([
      innerJoin(products, products.id.equalsExp(companyItems.productId)),
      leftOuterJoin(racks, racks.id.equalsExp(companyItems.defaultRackId)),
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
      // map companyItemId -> Map dengan agregat
      final map = <String, Map<String, dynamic>>{};

      for (final row in rows) {
        final ci = row.readTable(companyItems);
        final p = row.readTable(products);
        final u = row.readTableOrNull(units);
        final v = row.readTableOrNull(variants);
        final r = row.readTableOrNull(racks);

        final id = ci.id;
        // jika belum ada, inisialisasi entri dengan struktur sederhana
        map.putIfAbsent(id, () {
          return {
            'companyItemId': ci.id,
            'companyCode': ci.companyCode,
            'productName': p.name,
            'defaultRackId': r?.id,
            'defaultRackName': r?.name,
            'totalUnits': 0,
            'variantIds': <String>{}, // Set untuk hindari double-count
          };
        });

        final entry = map[id]!;
        if (u != null) {
          entry['totalUnits'] = (entry['totalUnits'] as int) + 1;
        }
        if (v != null) {
          (entry['variantIds'] as Set<String>).add(v.id);
        }
      }

      final result = map.values.map((entry) {
        final variantIds = entry['variantIds'] as Set<String>;
        return CompanyItemListRow(
          companyItemId: entry['companyItemId'] as String,
          companyCode: entry['companyCode'] as String,
          productName: entry['productName'] as String,
          defaultRackId: entry['defaultRackId'] as String?,
          defaultRackName: entry['defaultRackName'] as String?,
          categoryName: null,
          totalUnits: entry['totalUnits'] as int,
          totalVariants: variantIds.length,
        );
      }).toList()..sort((a, b) => a.companyCode.compareTo(b.companyCode));

      return result;
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
        final r = row.readTableOrNull(racks);

        map.putIfAbsent(
          v.id,
          () => CompanyItemVariantRow(
            variantId: v.id,
            name: v.name,
            brandName: b?.name,
            rackName: r?.name,
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

  Future<void> updateDefaultRackCompanyItem({
    required String id,
    required String rackId,
  }) async {
    await (update(companyItems)..where((t) => t.id.equals(id))).write(
      CompanyItemsCompanion(
        defaultRackId: Value(rackId),
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
  final String? rackName;
  final int stock;

  CompanyItemVariantRow({
    required this.variantId,
    required this.name,
    this.brandName,
    this.rackName,
    required this.stock,
  });

  CompanyItemVariantRow copyWith({int? stock}) {
    return CompanyItemVariantRow(
      variantId: variantId,
      name: name,
      brandName: brandName,
      rackName: rackName,
      stock: stock ?? this.stock,
    );
  }
}

class CompanyItemListRow {
  final String companyItemId;
  final String companyCode;
  final String productName;
  final String? categoryName; // kalau mau sekalian
  final String? defaultRackId; // kalau mau sekalian
  final String? defaultRackName; // kalau mau sekalian
  final int totalUnits; // total unit aktif untuk kode ini
  final int totalVariants; // total unit aktif untuk kode ini

  CompanyItemListRow({
    required this.companyItemId,
    required this.companyCode,
    required this.productName,
    this.categoryName,
    this.defaultRackId,
    this.defaultRackName,
    required this.totalVariants,
    required this.totalUnits,
  });

  CompanyItemListRow copyWith({int? totalUnits, int? totalVariants}) {
    return CompanyItemListRow(
      companyItemId: companyItemId,
      companyCode: companyCode,
      productName: productName,
      categoryName: categoryName,
      defaultRackId: defaultRackId,
      defaultRackName: defaultRackName,
      totalVariants: totalVariants ?? this.totalVariants,
      totalUnits: totalUnits ?? this.totalUnits,
    );
  }
}
