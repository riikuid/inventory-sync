import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'product_dao.g.dart';

@DriftAccessor(tables: [Products, Categories, Brands])
class ProductDao extends DatabaseAccessor<AppDatabase> with _$ProductDaoMixin {
  ProductDao(AppDatabase db) : super(db);

  /// Upsert banyak product sekaligus (dipakai saat pull)
  Future<void> upsertProducts(List<ProductsCompanion> list) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(products, list);
    });
  }

  /// Ambil 1 product by id
  Future<Product?> getById(String id) {
    return (select(products)..where((p) => p.id.equals(id))).getSingleOrNull();
  }

  /// Semua produk yg perlu di-push (needSync = true)
  Future<List<Product>> getPendingProducts() {
    return (select(products)..where((p) => p.needSync.equals(true))).get();
  }

  /// Tandai produk sudah tersync (needSync = false)
  Future<void> markProductsSynced(List<String> ids) async {
    if (ids.isEmpty) return;
    await (update(products)..where((p) => p.id.isIn(ids))).write(
      const ProductsCompanion(needSync: Value(false)),
    );
  }
}
