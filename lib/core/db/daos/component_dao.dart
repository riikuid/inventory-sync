// lib/core/db/daos/component_dao.dart
import 'package:drift/drift.dart' hide Component;
import 'package:inventory_sync_apps/core/constant.dart';
import '../app_database.dart';
import '../tables.dart';

part 'component_dao.g.dart';

@DriftAccessor(tables: [Components, Products, Brands, Units])
class ComponentDao extends DatabaseAccessor<AppDatabase>
    with _$ComponentDaoMixin {
  ComponentDao(AppDatabase db) : super(db);

  Future<void> upsertComponents(List<ComponentsCompanion> list) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(components, list);
    });
  }

  /// Watch komponen untuk product + type (stream) — dipakai UI yang butuh realtime
  Stream<List<ComponentWithBrandAndStock>> watchComponentsByProductAndType({
    required String productId,
    required int type,
    required String? search,
  }) {
    final hasSearch = search != null && search.trim().isNotEmpty;
    final pattern = hasSearch ? '%${search.trim()}%' : null;

    // Select components (so we can filter by productId & type in SQL)
    final q =
        (select(components)..where(
              (c) => c.productId.equals(productId) & c.type.equals(type),
            ))
            .join([
              // join brands to get brand name and to allow searching by brand
              leftOuterJoin(brands, brands.id.equalsExp(components.brandId)),
            ]);

    // Optional search across component name, manufCode, or brand name
    if (hasSearch) {
      q.where(
        components.name.like(pattern!) |
            components.manufCode.like(pattern) |
            brands.name.like(pattern),
      );
    }

    // watch() returns Stream<List<JoinedRow>>; map -> ComponentWithBrandAndStock
    return q.watch().asyncMap((rows) async {
      final comps = <Component>[]; // Drift-generated component row model
      final brandFor = <String, String?>{};
      final compIds = <String>[];

      for (final row in rows) {
        final c = row.readTable(components);
        final b = row.readTableOrNull(brands);

        // avoid duplicates if join returns duplicates (depends on schema)
        if (!compIds.contains(c.id)) {
          comps.add(c);
          compIds.add(c.id);
          brandFor[c.id] = b?.name;
        }
      }

      if (compIds.isEmpty) return <ComponentWithBrandAndStock>[];

      // Batch-fetch active units for all componentIds
      final unitRows =
          await (select(units)..where(
                (u) =>
                    u.status.equals(activeStatus) & u.componentId.isIn(compIds),
              ))
              .get();

      // Count per componentId
      final counts = <String, int>{};
      for (final u in unitRows) {
        if (u.componentId == null) continue;
        counts[u.componentId!] = (counts[u.componentId!] ?? 0) + 1;
      }

      // Build final list preserving order
      final res = comps.map((c) {
        return ComponentWithBrandAndStock(
          component: c,
          brandName: brandFor[c.id],
          totalUnits: counts[c.id] ?? 0,
        );
      }).toList();

      return res;
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

class ComponentWithBrandAndStock {
  final Component component;
  final String? brandName;
  final int totalUnits;

  ComponentWithBrandAndStock({
    required this.component,
    required this.brandName,
    required this.totalUnits,
  });
}
