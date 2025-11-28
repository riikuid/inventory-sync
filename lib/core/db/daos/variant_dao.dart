// lib/core/db/daos/variant_dao.dart
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'variant_dao.g.dart';

@DriftAccessor(tables: [Variants, CompanyItems, Products, Brands])
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
}
