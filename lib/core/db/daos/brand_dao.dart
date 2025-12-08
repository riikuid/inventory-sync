import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'brand_dao.g.dart';

@DriftAccessor(tables: [Products, Categories, Brands])
class BrandDao extends DatabaseAccessor<AppDatabase> with _$BrandDaoMixin {
  BrandDao(AppDatabase db) : super(db);

  /// Upsert banyak product sekaligus (dipakai saat pull)
  Future<void> upsertBrands(List<BrandsCompanion> list) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(brands, list);
    });
  }

  Stream<List<Brand>> watchBrands({String? search}) {
    final query = select(brands)
      ..orderBy([(b) => OrderingTerm(expression: b.name)]);
    if (search != null && search.isNotEmpty) {
      query.where((r) => r.name.like("%$search%"));
    }
    return query.watch();
  }

  /// Ambil 1 brand by id
  Future<Brand?> getById(String id) {
    return (select(brands)..where((b) => b.id.equals(id))).getSingleOrNull();
  }

  Future<List<Brand>> getAll() {
    return select(brands).get();
  }

  /// Semua produk yg perlu di-push (needSync = true)
  Future<List<Brand>> getPendingBrands() {
    return (select(brands)..where((b) => b.needSync.equals(true))).get();
  }

  /// Tandai produk sudah tersync (needSync = false)
  Future<void> markBrandsSynced(List<String> ids) async {
    if (ids.isEmpty) return;
    await (update(brands)..where((b) => b.id.isIn(ids))).write(
      const BrandsCompanion(needSync: Value(false)),
    );
  }
}
