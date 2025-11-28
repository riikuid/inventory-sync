// lib/core/db/daos/company_item_dao.dart
import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart'; // ini yg nge-export tables + generated

part 'company_item_dao.g.dart';

@DriftAccessor(tables: [CompanyItems, Products])
class CompanyItemDao extends DatabaseAccessor<AppDatabase>
    with _$CompanyItemDaoMixin {
  CompanyItemDao(AppDatabase db) : super(db);

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
