// lib/core/db/daos/company_item_dao.dart
import 'package:drift/drift.dart';
import 'package:inventory_sync_apps/core/constant.dart';
import 'package:rxdart/rxdart.dart';

import '../../../features/inventory/data/model/inventory_search_item.dart';
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
    Sections,
  ],
)
class CompanyItemDao extends DatabaseAccessor<AppDatabase>
    with _$CompanyItemDaoMixin {
  CompanyItemDao(super.db);

  Stream<List<CompanyItemListRow>> watchDashboardItems({
    required List<String> sectionIds,
  }) {
    if (sectionIds.isEmpty) {
      return Stream.value([]);
    }

    final triggerStream = select(
      companyItems,
    ).watch().debounceTime(const Duration(milliseconds: 500));

    return triggerStream.switchMap((_) {
      return customSelect(
        '''
      SELECT
        ci.id as companyItemId,
        ci.company_code as companyCode,
        ci.category_id as categoryId,
        ci.section_id as sectionId,
        ci.specification,
        ci.machine_purchase as machinePurchase,
        ci.notes,
        p.name as productName,
        c.name as categoryName,
        s.name as sectionName,
        r.warehouse_id as warehouseId,
        r.name as defaultRackName,
        r.id as defaultRackId,
        (SELECT COUNT(*) FROM variants v WHERE v.company_item_id = ci.id) as totalVariants,
        CAST(COALESCE(total_unit.total_unit, 0) AS TEXT) as unit,
        CASE 
          WHEN total_unit.total_unit > 0 THEN 1 
          ELSE 0 
        END as isLabeled
      FROM company_items ci
      INNER JOIN products p ON ci.product_id = p.id
      LEFT JOIN categories c ON ci.category_id = c.id
      LEFT JOIN sections s ON ci.section_id = s.id
      LEFT JOIN racks r ON ci.default_rack_id = r.id
      LEFT JOIN (
        SELECT 
          v.company_item_id,
          COUNT(u.id) as total_unit
        FROM variants v
        LEFT JOIN units u ON u.variant_id = v.id 
          AND u.component_id IS NULL 
          AND u.deleted_at IS NULL
        GROUP BY v.company_item_id
      ) total_unit ON ci.id = total_unit.company_item_id
      WHERE ci.section_id IN (?${", ?" * (sectionIds.length - 1)})
      ORDER BY ci.company_code ASC
      ''',
        variables: sectionIds.map((id) => Variable(id)).toList(),
        readsFrom: {
          companyItems,
          products,
          categories,
          sections,
          racks,
          variants,
          units,
        },
      ).watch().map((rows) {
        return rows.map((row) {
          return CompanyItemListRow(
            companyItemId: row.read<String>('companyItemId'),
            companyCode: row.read<String>('companyCode'),
            productName: row.read<String>('productName'),
            categoryId: row.readNullable<String>('categoryId'),
            sectionId: row.readNullable<String>('sectionId'),
            warehouseId: row.readNullable<String>('warehouseId'),
            categoryName: row.readNullable<String>('categoryName') ?? '-',
            sectionName: row.readNullable<String>('sectionName'),
            defaultRackId: row.readNullable<String>('defaultRackId'),
            defaultRackName: row.readNullable<String>('defaultRackName'),
            totalVariants: row.read<int>('totalVariants'),
            specification: row.readNullable<String>('specification'),
            machinePurchase: row.readNullable<String>('machinePurchase'),
            notes: row.readNullable<String>('notes'),
            unit: row.read<String>('unit'),
            isLabeled: row.read<int>('isLabeled') == 1, // Convert 1/0 to bool
          );
        }).toList();
      });
    });
  }

  Future<List<InventorySearchItem>> searchItems(
    String query, {
    required List<String> sectionIds,
    int limit = 50,
    int offset = 0,
  }) async {
    if (query.trim().length < 2) return [];
    if (sectionIds.isEmpty) return [];

    final q = '%${query.trim()}%';

    final rows = await customSelect(
      '''
    SELECT
      ci.id                AS companyItemId,
      ci.company_code      AS companyCode,
      p.name               AS productName,
      ci.category_id       AS categoryId,
      c.name               AS categoryName,
      COUNT(DISTINCT v.id) AS variantCount
    FROM company_items ci
    INNER JOIN products p ON p.id = ci.product_id
    LEFT JOIN categories c ON c.id = ci.category_id
    LEFT JOIN variants v ON v.company_item_id = ci.id
    WHERE ci.section_id IN (?${", ?" * (sectionIds.length - 1)})
      AND (ci.company_code LIKE ? OR p.name LIKE ?)
    GROUP BY ci.id
    ORDER BY p.name
    LIMIT ? OFFSET ?
    ''',
      variables: [
        ...sectionIds.map((id) => Variable(id)),
        Variable(q),
        Variable(q),
        Variable(limit),
        Variable(offset),
      ],
      readsFrom: {companyItems, products, categories, variants},
    ).get();

    return rows.map((row) {
      return InventorySearchItem(
        companyItemId: row.read<String>('companyItemId'),
        companyCode: row.read<String>('companyCode'),
        productName: row.read<String>('productName'),
        categoryId: row.read<String?>('categoryId'),
        categoryName: row.read<String?>('categoryName'),
        rackName: null,
        warehouseName: null,
        variantCount: row.read<int>('variantCount'),
      );
    }).toList();
  }

  // Future<int> calculateStockForItem(String companyItemId) async {
  //   final variants = await (select(
  //     this.variants,
  //   )..where((v) => v.companyItemId.equals(companyItemId))).get();

  //   int totalStock = 0;

  //   for (final v in variants) {
  //     final components = await _getComponentsForVariants([v.id]);
  //     final units =
  //         await (select(this.units)
  //               ..where((u) => u.variantId.equals(v.id))
  //               ..where((u) => u.status.equals(activeStatus)))
  //             .get();

  //     totalStock += calculateVariantStock(
  //       variantId: v.id,
  //       components: components,
  //       activeUnits: units,
  //     );
  //   }

  //   return totalStock;
  // }

  /// Helper untuk mengambil komponen berdasarkan list variant ID
  // Future<List<VariantComponentRow>> _getComponentsForVariants(
  //   List<String> variantIds,
  // ) async {
  //   if (variantIds.isEmpty) return [];

  //   final query = select(variantComponents).join([
  //     innerJoin(
  //       components,
  //       components.id.equalsExp(variantComponents.componentId),
  //     ),
  //   ])..where(variantComponents.variantId.isIn(variantIds));

  //   final rows = await query.get();

  //   return rows.map((r) {
  //     final c = r.readTable(components);
  //     final vc = r.readTable(variantComponents);

  //     return VariantComponentRow(
  //       quantity: vc.quantity,
  //       variantId: vc.variantId,
  //       componentId: c.id,
  //       name: c.name,
  //       type: c.type,
  //       totalUnits: 0,
  //     );
  //   }).toList();
  // }

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

  Future<CompanyItem?> getById(String id) {
    return (select(
      companyItems,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<CompanyItem?> getCompanyItemByCode(String code) {
    return (select(
      companyItems,
    )..where((t) => t.companyCode.equals(code))).getSingleOrNull();
  }

  Future<CompanyItemListRow?> getCompanyItemByCompanyCode(
    String companyCode,
  ) async {
    final rows = await customSelect(
      '''
    SELECT
      ci.id as companyItemId,
      ci.company_code as companyCode,
      ci.category_id as categoryId,
      ci.section_id as sectionId,
      p.name as productName,
      c.name as categoryName,
      r.warehouse_id as warehouseId,
      r.name as defaultRackName,
      (SELECT COUNT(*) FROM variants v WHERE v.company_item_id = ci.id) as totalVariants
    FROM company_items ci
    INNER JOIN products p ON ci.product_id = p.id
    LEFT JOIN categories c ON ci.category_id = c.id
    LEFT JOIN racks r ON ci.default_rack_id = r.id
    WHERE ci.company_code = ?
    LIMIT 1
    ''',
      variables: [Variable(companyCode)],
      readsFrom: {companyItems, products, categories, racks, variants},
    ).get();

    if (rows.isEmpty) return null;

    final row = rows.first;

    return CompanyItemListRow(
      companyItemId: row.read<String>('companyItemId'),
      companyCode: row.read<String>('companyCode'),
      productName: row.read<String>('productName'),
      categoryId: row.readNullable<String>('categoryId'),
      sectionId: row.readNullable<String>('sectionId'),
      warehouseId: row.readNullable<String>('warehouseId'),
      categoryName: row.readNullable<String>('categoryName') ?? '-',
      defaultRackId: null,
      defaultRackName: row.readNullable<String>('defaultRackName'),
      totalVariants: row.read<int>('totalVariants'),
      unit: '',
      isLabeled: false,
    );
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
  final String? categoryId;
  final String? sectionId;
  final String? warehouseId;
  final String categoryName;
  final String? sectionName;
  final String? defaultRackId;
  final String? defaultRackName;
  final int totalVariants;
  final String? specification;
  final String? machinePurchase;
  final String? notes;
  final String unit;
  final bool isLabeled; // Properti baru

  CompanyItemListRow({
    required this.companyItemId,
    required this.companyCode,
    required this.productName,
    this.categoryId,
    this.sectionId,
    this.warehouseId,
    required this.categoryName,
    this.sectionName,
    this.defaultRackId,
    this.defaultRackName,
    required this.totalVariants,
    this.specification,
    this.machinePurchase,
    this.notes,
    required this.unit,
    required this.isLabeled,
  });
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
