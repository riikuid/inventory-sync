// lib/core/db/daos/rack_dao.dart
import 'dart:developer';

import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'rack_dao.g.dart';

@DriftAccessor(
  tables: [Racks, Warehouses, SectionWarehouses, Sections, Departments],
)
class RackDao extends DatabaseAccessor<AppDatabase> with _$RackDaoMixin {
  RackDao(AppDatabase db) : super(db);

  /// Ambil semua rack (sinkronisasi / UI picker)
  Future<List<Rack>> getAll() {
    return select(racks).get();
  }

  /// Ambil satu rack by id
  Future<Rack?> getById(String id) {
    return (select(racks)..where((r) => r.id.equals(id))).getSingleOrNull();
  }

  /// Cari rack berdasarkan nama atau department code atau lokasi
  // Future<List<Rack>> searchByQuery(String query) {
  //   final q = '%${query.trim()}%';
  //   return (select(racks)..where(
  //         (r) => r.name.like(q) | r.code.like(q) | r.departmentCode.like(q),
  //       ))
  //       .get();
  // }

  Stream<List<RackWithContext>> watchRacks({String? search}) {
    final base = select(racks).join([
      leftOuterJoin(warehouses, warehouses.id.equalsExp(racks.warehouseId)),

      // 1. Join ke SW (Harus menggunakan warehouses.id)
      leftOuterJoin(
        sectionWarehouses,
        // Pastikan ini adalah warehouses.id, bukan racks.warehouseId
        sectionWarehouses.warehouseId.equalsExp(warehouses.id),
      ),

      // 2. Join ke Sections (menggunakan sectionWarehouses.sectionId)
      leftOuterJoin(
        sections,
        sections.id.equalsExp(sectionWarehouses.sectionId),
      ),

      // 3. Join ke Departments
      leftOuterJoin(
        departments,
        departments.id.equalsExp(sections.departmentId),
      ),
    ]);

    if (search != null && search.trim().isNotEmpty) {
      final q = '%${search.trim()}%';

      // build predicate: any of these like q
      final predicate =
          racks.name.like(q) |
          warehouses.name.like(q) |
          sections.name.like(q) |
          sections.code.like(q) |
          departments.name.like(q) |
          departments.code.like(q);

      base.where(predicate);
    }

    return base.watch().map((rows) {
      // Map rows to distinct racks (because join can duplicate rows)
      final map = <String, RackWithContext>{};

      for (final row in rows) {
        log('Row data: ${row.rawData.data}');
        final r = row.readTable(racks);
        final w = row.readTableOrNull(warehouses);
        final sw = row.readTableOrNull(sectionWarehouses);
        final s = row.readTableOrNull(sections);
        final d = row.readTableOrNull(departments);

        map.putIfAbsent(
          r.id,
          () => RackWithContext(
            rack: r,
            warehouseName: w?.name,
            sectionName: s?.name,
            sectionCode: s?.code,
            departmentName: d?.name,
            departmentCode: d?.code,
          ),
        );
      }

      return map.values.toList()
        ..sort((a, b) => (a.rack.name).compareTo(b.rack.name));
    });
  }

  /// Watch untuk picker atau list realtime
  Stream<List<Rack>> watchAll() {
    return select(racks).watch();
  }

  /// Insert or update many on conflict
  Future<void> upsertRacks(List<RacksCompanion> list) async {
    if (list.isEmpty) return;
    await batch((b) {
      b.insertAllOnConflictUpdate(racks, list);
    });
  }

  /// Mark some racks synced (optional)
  // Future<void> markRacksSynced(List<String> ids) async {
  //   if (ids.isEmpty) return;
  //   await (update(racks)..where((r) => r.id.isIn(ids))).write(
  //     const RacksCompanion(needSync: Value(false)),
  //   );
  // }

  /// Delete (if needed)
  Future<void> deleteById(String id) async {
    await (delete(racks)..where((r) => r.id.equals(id))).go();
  }
}

class RackWithContext {
  final Rack rack;
  final String? warehouseName;
  final String? sectionName;
  final String? sectionCode;
  final String? departmentName;
  final String? departmentCode;

  RackWithContext({
    required this.rack,
    this.warehouseName,
    this.sectionName,
    this.sectionCode,
    this.departmentName,
    this.departmentCode,
  });
}
