// lib/core/db/daos/unit_dao.dart
import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'unit_dao.g.dart';

@DriftAccessor(tables: [Units, Variants, CompanyItems, Products])
class UnitDao extends DatabaseAccessor<AppDatabase> with _$UnitDaoMixin {
  UnitDao(super.db);

  Future<void> insertUnit(UnitsCompanion unit) async {
    await into(units).insert(unit);
  }

  Future<void> updateUnit(UnitsCompanion unit) async {
    await update(units).replace(unit);
  }

  Future<UnitWithRelations?> getUnitDetail(String id) async {
    final query = select(units).join([
      leftOuterJoin(variants, variants.id.equalsExp(units.variantId)),
      leftOuterJoin(
        companyItems,
        companyItems.id.equalsExp(variants.companyItemId),
      ),
      leftOuterJoin(products, products.id.equalsExp(companyItems.productId)),
    ])..where(units.id.equals(id));

    final row = await query.getSingleOrNull();
    if (row == null) return null;

    final unit = row.readTable(units); // Unit
    final variant = row.readTableOrNull(variants); // Varian?
    final companyItem = row.readTableOrNull(companyItems); // CompanyItem?
    final product = row.readTableOrNull(products); // Product?

    return UnitWithRelations(
      unit: unit,
      variant: variant,
      companyItem: companyItem,
      product: product,
    );
  }

  /// Semua unit yang butuh sync (needSync == true)
  Future<List<Unit>> getPendingUnits() {
    return (select(units)..where((u) => u.needSync.equals(true))).get();
  }

  Future<void> markUnitsSynced(List<String> ids, DateTime syncedAt) async {
    if (ids.isEmpty) return;
    await (update(units)..where((u) => u.id.isIn(ids))).write(
      UnitsCompanion(needSync: const Value(false), syncedAt: Value(syncedAt)),
    );
  }
}

class UnitWithRelations {
  final Unit unit;
  final Variant? variant;
  final CompanyItem? companyItem;
  final Product? product;

  UnitWithRelations({
    required this.unit,
    this.variant,
    this.companyItem,
    this.product,
  });
}
