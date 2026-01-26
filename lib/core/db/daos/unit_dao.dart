// lib/core/db/daos/unit_dao.dart
import 'dart:developer' as dev;

import 'package:drift/drift.dart' hide Component;
import 'package:inventory_sync_apps/core/constant.dart';
import 'package:uuid/uuid.dart';

import '../app_database.dart';
import '../tables.dart';

part 'unit_dao.g.dart';

@DriftAccessor(tables: [Units, Components, Variants, CompanyItems, Products])
class UnitDao extends DatabaseAccessor<AppDatabase> with _$UnitDaoMixin {
  UnitDao(super.db);

  final _uuid = const Uuid();

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
  Future<List<Unit>> getPendingUnits() async {
    final pendings =
        await (select(units)
              ..where(
                (u) => u.status.isNotIn([
                  pendingStatus,
                  printedStatus,
                  validatedStatus,
                ]),
              )
              ..where((u) => u.needSync.equals(true))
              ..orderBy([
                // 1. parent dulu (NULL di atas)
                (u) => OrderingTerm(
                  expression: u.parentUnitId,
                  mode: OrderingMode.asc,
                  nulls: NullsOrder.first,
                ),
                // 2. baru urutkan by updatedAt
                (u) => OrderingTerm(
                  expression: u.updatedAt,
                  mode: OrderingMode.desc,
                ),
              ]))
            .get();

    dev.log('Total Pending Units: ${pendings.length}');
    return pendings;
  }

  Future<void> markUnitsSynced(List<String> ids, DateTime syncedAt) async {
    if (ids.isEmpty) return;
    await (update(units)..where((u) => u.id.isIn(ids))).write(
      UnitsCompanion(needSync: const Value(false), syncedAt: Value(syncedAt)),
    );
  }

  // =================== CREATE BATCH PENDING UNIT ===================

  Future<List<Unit>> createPendingUnits({
    required String variantId,
    required String companyCode,
    required String rackId,
    required int qty,
    required String userId,
  }) async {
    if (qty <= 0) return [];

    final now = DateTime.now();
    final entries = <UnitsCompanion>[];

    final baseMillis = DateTime.now().toUtc().millisecondsSinceEpoch;

    for (var i = 0; i < qty; i++) {
      final id = _uuid.v4();
      final serial = (i + 1).toString().padLeft(3, '0');
      final qrValue =
          '${userId.trim()}-${companyCode.trim()}-$baseMillis-$serial';
      entries.add(
        UnitsCompanion.insert(
          id: id,
          variantId: Value(variantId),
          componentId: const Value(null),
          parentUnitId: const Value(null),
          rackId: Value(rackId),
          qrValue: qrValue,
          status: const Value(pendingStatus),
          printCount: Value(0),
          lastPrintedAt: const Value(null),
          lastPrintedBy: const Value(null),
          createdBy: Value(userId),
          updatedBy: Value(userId),
          syncedAt: const Value(null),
          lastModifiedAt: Value(now),
          needSync: const Value(true),
          createdAt: now,
          updatedAt: now,
          deletedAt: const Value(null),
        ),
      );
    }

    // batch insert
    await batch((b) {
      b.insertAll(units, entries);
    });

    // ambil kembali inserted rows berdasarkan qrValue list (ordered)
    final qrValues = entries.map((e) => e.qrValue.value).toList();
    final rows = await (select(
      units,
    )..where((u) => u.qrValue.isIn(qrValues))).get();
    return rows;
  }

  /// Mark units as printed (increment printCount, update lastPrintedAt/by)
  Future<void> markUnitsPrinted(List<String> unitIds, int userId) async {
    if (unitIds.isEmpty) return;
    final now = DateTime.now();
    // read current values first (so we can increment)
    final current = await (select(
      units,
    )..where((u) => u.id.isIn(unitIds))).get();

    for (final u in current) {
      final newCount = (u.printCount ?? 0) + 1;
      await (update(units)..where((t) => t.id.equals(u.id))).write(
        UnitsCompanion(
          printCount: Value(newCount),
          lastPrintedAt: Value(now),
          lastPrintedBy: Value(userId.toString()),
          status: Value(printedStatus),
          updatedAt: Value(now),
          lastModifiedAt: Value(now),
          needSync: const Value(true),
        ),
      );
    }
  }

  /// After validation (when all scanned), mark units ACTIVE
  Future<void> markUnitsActive(List<String> unitIds, int userId) async {
    if (unitIds.isEmpty) return;
    final now = DateTime.now();
    await (update(units)..where((u) => u.id.isIn(unitIds))).write(
      UnitsCompanion(
        status: Value(activeStatus),
        updatedBy: Value(userId.toString()),
        updatedAt: Value(now),
        lastModifiedAt: Value(now),
        needSync: const Value(true),
      ),
    );
  }

  /// Hapus pending units (dipakai saat user batal sebelum final)
  Future<void> deletePendingUnits(List<String> unitIds) async {
    if (unitIds.isEmpty) return;
    await (delete(units)..where(
          (u) =>
              u.id.isIn(unitIds) &
              u.status.isIn([pendingStatus, printedStatus, validatedStatus]),
        ))
        .go();
  }

  /// Ambil unit rows by ids
  Future<List<Unit>> findUnitsByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    return (select(units)..where((u) => u.id.isIn(ids))).get();
  }

  // =================== INSERT BANYAK UNIT ===================

  Future<void> insertUnits(List<UnitsCompanion> entries) async {
    if (entries.isEmpty) return;
    await batch((batch) {
      batch.insertAll(units, entries);
    });
  }

  // =================== INSERT PARENT UNIT SET ===================

  Future<Unit> insertParentUnit(UnitsCompanion entry) {
    dev.log('create unit parent: ${DateTime.now()}');
    // butuh drift >=2.10 untuk insertReturning; kalau belum ada, bisa pakai insert lalu getSingle
    return into(units).insertReturning(entry);
  }

  // =================== CARI UNIT BERDASARKAN QR ===================

  Future<UnitWithRelations?> findByQrWithJoins(String qrValue) async {
    final query = (select(units)..where((u) => u.qrValue.equals(qrValue)))
        .join([
          leftOuterJoin(components, components.id.equalsExp(units.componentId)),
          leftOuterJoin(variants, variants.id.equalsExp(units.variantId)),
        ]);

    final row = await query.getSingleOrNull();
    if (row == null) return null;

    return UnitWithRelations(
      unit: row.readTable(units),
      component: row.readTableOrNull(components),
      variant: row.readTableOrNull(variants),
    );
  }

  /// Bind multiple component units to a parent unit set.
  ///
  /// This will update the component units with the given parent unit ID,
  /// set their status to active, and update the last modified timestamp.
  ///
  /// All units will be marked as needing sync.
  ///
  /// [parentUnitId] ID of the parent unit set
  /// [componentUnitIds] List of IDs of the component units to bind
  /// [userId] ID of the user performing the action
  /// [now] Current DateTime object, used to set last modified timestamp
  Future<void> bindUnitsToParent({
    required String parentUnitId,
    required List<String> componentUnitIds,
    required int userId,
    required DateTime now,
  }) async {
    if (componentUnitIds.isEmpty) return;

    await (update(units)..where((u) => u.id.isIn(componentUnitIds))).write(
      UnitsCompanion(
        parentUnitId: Value(parentUnitId),
        updatedBy: Value(userId.toString()),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> activateAllUnitComponents({
    required List<String> componentUnitIds,
    required int userId,
    required DateTime now,
  }) async {
    if (componentUnitIds.isEmpty) return;

    await (update(units)..where((u) => u.id.isIn(componentUnitIds))).write(
      UnitsCompanion(
        status: Value(activeStatus),
        updatedBy: Value(userId.toString()),
        updatedAt: Value(now),
        lastModifiedAt: Value(now),
        needSync: const Value(true),
      ),
    );
  }
}

class UnitWithRelations {
  final Unit unit;
  final Component? component;
  final Variant? variant;
  final CompanyItem? companyItem;
  final Product? product;

  UnitWithRelations({
    required this.unit,
    this.component,
    this.variant,
    this.companyItem,
    this.product,
  });
}
