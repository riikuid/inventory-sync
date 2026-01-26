import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'variant_component_dao.g.dart';

@DriftAccessor(tables: [VariantComponents, Variants, Components])
class VariantComponentDao extends DatabaseAccessor<AppDatabase>
    with _$VariantComponentDaoMixin {
  VariantComponentDao(AppDatabase db) : super(db);

  /// Upsert banyak relasi variant_component (dipakai saat pull)
  Future<void> upsertVariantComponents(
    List<VariantComponentsCompanion> list,
  ) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(variantComponents, list);
    });
  }

  /// Ambil semua komponen utk 1 variant
  Future<List<VariantComponent>> getByVariantId(String variantId) {
    return (select(
      variantComponents,
    )..where((vc) => vc.variantId.equals(variantId))).get();
  }

  Future<void> deleteByVariant(String variantId) async {
    await (delete(
      variantComponents,
    )..where((vc) => vc.variantId.equals(variantId))).go();
  }

  /// Semua relasi yg perlu di-push
  Future<List<VariantComponent>> getPendingVariantComponents() {
    return (select(
      variantComponents,
    )..where((vc) => vc.needSync.equals(true))).get();
  }

  /// Tandai relasi sudah tersync
  Future<void> markVariantComponentsSynced(List<String> ids) async {
    if (ids.isEmpty) return;
    await (update(variantComponents)..where((vc) => vc.id.isIn(ids))).write(
      const VariantComponentsCompanion(needSync: Value(false)),
    );
  }
}
