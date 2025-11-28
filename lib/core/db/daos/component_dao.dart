// lib/core/db/daos/component_dao.dart
import 'package:drift/drift.dart' hide Component;
import '../app_database.dart';
import '../tables.dart';

part 'component_dao.g.dart';

@DriftAccessor(tables: [Components, Products, Brands])
class ComponentDao extends DatabaseAccessor<AppDatabase>
    with _$ComponentDaoMixin {
  ComponentDao(AppDatabase db) : super(db);

  Future<void> upsertComponents(List<ComponentsCompanion> list) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(components, list);
    });
  }

  Future<List<Component>> getPendingComponents() {
    return (select(components)..where((c) => c.needSync.equals(true))).get();
  }

  Future<void> markComponentsSynced(List<String> ids) async {
    if (ids.isEmpty) return;
    await (update(components)..where((c) => c.id.isIn(ids))).write(
      const ComponentsCompanion(needSync: Value(false)),
    );
  }
}
