// lib/core/db/daos/company_item_dao.dart
import 'package:drift/drift.dart';
import 'package:inventory_sync_apps/core/constant.dart';
import 'package:rxdart/rxdart.dart';

import '../app_database.dart';
import '../model/variant_component_row.dart';
import '../tables.dart';

part 'company_item_dao.g.dart';

@DriftAccessor(
  tables: [
    CompanyItems,
    Products,
    Categories,
    Variants,
    VariantComponents,
    Components,
    Units,
    Brands,
    Racks,
  ],
)
class CompanyItemDao extends DatabaseAccessor<AppDatabase>
    with _$CompanyItemDaoMixin {
  CompanyItemDao(super.db);

  /// ✅ SOLUSI SEDERHANA: Query ringan dengan raw SQL
  /// Hanya ambil data dasar, stock dihitung on-demand
  Stream<List<CompanyItemListRow>> watchDashboardItems() {
    // Debounce untuk mencegah query berlebihan saat sync
    final triggerStream = Rx.merge([
      select(companyItems).watch(),
      select(units).watch(),
    ]).debounceTime(const Duration(milliseconds: 500));

    return triggerStream.switchMap((_) {
      // Query sederhana dengan raw SQL (JAUH LEBIH CEPAT!)
      return customSelect(
        '''
        SELECT 
          ci.id as companyItemId,
          ci.company_code as companyCode,
          p.name as productName,
          c.name as categoryName,
          r.name as defaultRackName,
          (SELECT COUNT(*) FROM variants v WHERE v.company_item_id = ci.id) as totalVariants,
          (SELECT COUNT(*) FROM units u 
           INNER JOIN variants v ON u.variant_id = v.id 
           WHERE v.company_item_id = ci.id AND u.status = ?) as totalUnits,
          COALESCE(
            (SELECT MAX(u.updated_at) 
             FROM units u 
             INNER JOIN variants v ON u.variant_id = v.id 
             WHERE v.company_item_id = ci.id AND u.status = ?), 
            0
          ) as lastUnitUpdate
        FROM company_items ci
        INNER JOIN products p ON ci.product_id = p.id
        LEFT JOIN categories c ON ci.category_id = c.id
        LEFT JOIN racks r ON ci.default_rack_id = r.id
        ORDER BY 
          CASE WHEN lastUnitUpdate > 0 THEN 1 ELSE 0 END DESC,
          lastUnitUpdate DESC,
          ci.company_code ASC
        LIMIT 50
        ''',
        variables: [Variable(activeStatus), Variable(activeStatus)],
        readsFrom: {companyItems, products, categories, racks, variants, units},
      ).watch().map((rows) {
        return rows.map((row) {
          return CompanyItemListRow(
            companyItemId: row.read<String>('companyItemId'),
            companyCode: row.read<String>('companyCode'),
            productName: row.read<String>('productName'),
            categoryName: row.readNullable<String>('categoryName') ?? '-',
            defaultRackId: null,
            defaultRackName: row.readNullable<String>('defaultRackName'),
            totalUnits: row.read<int>('totalUnits'),
            totalVariants: row.read<int>('totalVariants'),
          );
        }).toList();
      });
    });
  }

  /// ✅ Optimized: Kalkulasi stock hanya untuk 1 item saat dibutuhkan
  Future<int> calculateStockForItem(String companyItemId) async {
    final variants = await (select(
      this.variants,
    )..where((v) => v.companyItemId.equals(companyItemId))).get();

    int totalStock = 0;

    for (final v in variants) {
      final components = await _getComponentsForVariants([v.id]);
      final units =
          await (select(this.units)
                ..where((u) => u.variantId.equals(v.id))
                ..where((u) => u.status.equals(activeStatus)))
              .get();

      totalStock += calculateVariantStock(
        variantId: v.id,
        components: components,
        activeUnits: units,
      );
    }

    return totalStock;
  }

  /// Helper untuk mengambil komponen berdasarkan list variant ID
  Future<List<VariantComponentRow>> _getComponentsForVariants(
    List<String> variantIds,
  ) async {
    if (variantIds.isEmpty) return [];

    final query = select(variantComponents).join([
      innerJoin(
        components,
        components.id.equalsExp(variantComponents.componentId),
      ),
    ])..where(variantComponents.variantId.isIn(variantIds));

    final rows = await query.get();

    return rows.map((r) {
      final c = r.readTable(components);
      final vc = r.readTable(variantComponents);

      return VariantComponentRow(
        variantId: vc.variantId,
        componentId: c.id,
        name: c.name,
        type: c.type,
        totalUnits: 0,
      );
    }).toList();
  }

  /// ✅ Optimized: Watch variants dengan raw SQL
  Stream<List<CompanyItemVariantRow>> watchVariantsWithStock(
    String companyItemId,
  ) {
    return customSelect(
      '''
      SELECT 
        v.id as variantId,
        v.name as name,
        b.name as brandName,
        r.name as rackName,
        COALESCE(u.unit_count, 0) as stock
      FROM variants v
      LEFT JOIN brands b ON v.brand_id = b.id
      LEFT JOIN racks r ON v.rack_id = r.id
      LEFT JOIN (
        SELECT variant_id, COUNT(*) as unit_count
        FROM units
        WHERE status = ? AND variant_id IS NOT NULL
        GROUP BY variant_id
      ) u ON v.id = u.variant_id
      WHERE v.company_item_id = ?
      ORDER BY v.name
      ''',
      variables: [Variable(activeStatus), Variable(companyItemId)],
      readsFrom: {variants, brands, racks, units},
    ).watch().map((rows) {
      return rows.map((row) {
        return CompanyItemVariantRow(
          variantId: row.read<String>('variantId'),
          name: row.read<String>('name'),
          brandName: row.readNullable<String>('brandName'),
          rackName: row.readNullable<String>('rackName'),
          stock: row.read<int>('stock'),
        );
      }).toList();
    });
  }

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
            item: row.readTable(companyItems),
            product: row.readTable(products),
          ),
        )
        .toList();
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

// ==================== MODEL CLASSES ====================

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
  final String? categoryName;
  final String? defaultRackId;
  final String? defaultRackName;
  final int totalUnits;
  final int totalVariants;

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

// ==================== HELPER FUNCTIONS ====================

/// Helper untuk menghitung stok berdasarkan Rules
int calculateVariantStock({
  required String variantId,
  required List<VariantComponentRow> components,
  required List<Unit> activeUnits,
}) {
  int parentUnitsCount = 0;
  for (var u in activeUnits) {
    final cId = u.componentId;
    bool isNull = cId == null;
    bool isEmpty = cId != null && cId.trim().isEmpty;
    bool isLiteralNull = cId == "null";

    if (isNull || isEmpty || isLiteralNull) {
      parentUnitsCount++;
    }
  }

  if (components.isEmpty) return parentUnitsCount;

  final hasInBox = components.any((c) => c.type == inBoxType);
  if (hasInBox) return parentUnitsCount;

  final definitionMap = <String, int>{};
  for (final c in components) {
    definitionMap[c.componentId] = (definitionMap[c.componentId] ?? 0) + 1;
  }

  final stockMap = <String, int>{};
  for (final u in activeUnits) {
    final cId = u.componentId;
    if (cId != null && cId.trim().isNotEmpty && cId != "null") {
      stockMap[cId] = (stockMap[cId] ?? 0) + 1;
    }
  }

  int minComponentSets = 999999;

  if (stockMap.isEmpty) {
    minComponentSets = 0;
  } else {
    for (final entry in definitionMap.entries) {
      final compId = entry.key;
      final qtyNeeded = entry.value;
      final qtyAvailable = stockMap[compId] ?? 0;
      final possibleSets = qtyAvailable ~/ qtyNeeded;

      if (possibleSets < minComponentSets) {
        minComponentSets = possibleSets;
      }
    }
  }

  if (minComponentSets == 999999) minComponentSets = 0;

  return parentUnitsCount + minComponentSets;
}
