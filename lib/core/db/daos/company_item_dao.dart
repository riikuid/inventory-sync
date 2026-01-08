// lib/core/db/daos/company_item_dao.dart
import 'package:drift/drift.dart';
import 'package:inventory_sync_apps/core/constant.dart';
import 'package:rxdart/rxdart.dart';

import '../app_database.dart';
import '../model/variant_component_row.dart';
import '../tables.dart'; // ini yg nge-export tables + generated

part 'company_item_dao.g.dart';

@DriftAccessor(
  tables: [
    CompanyItems,
    Products,
    Variants,
    VariantComponents,
    Components,
    Units,
    Brands,
    Racks,
  ],
)
class CompanyItemDao extends DatabaseAccessor<AppDatabase>
    with _$CompanyItemDaoMixin {
  CompanyItemDao(super.db);

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

  Stream<List<CompanyItemListRow>> watchCompanyItemsWithStock({
    String? productId,
  }) {
    // 1. Query Base CompanyItems
    var queryCI = select(companyItems).join([
      innerJoin(products, products.id.equalsExp(companyItems.productId)),
      leftOuterJoin(racks, racks.id.equalsExp(companyItems.defaultRackId)),
    ]);

    if (productId != null) {
      queryCI.where(products.id.equals(productId));
    }

    final ciStream = queryCI.watch();

    // 2. Kita butuh data variants, components, dan units untuk menghitung stok agregat
    // Peringatan: Jika datanya ribuan, query ini harus dioptimasi.
    // Tapi untuk penggunaan wajar, kita fetch "Active Units" dan "Structure" nya.

    // Ambil semua variant related (untuk mapping ID)
    final variantsStream = select(variants).watch();

    // Ambil structure component (type is important)
    final componentsStream = select(variantComponents).join([
      innerJoin(
        components,
        components.id.equalsExp(variantComponents.componentId),
      ),
    ]).watch();

    // Ambil Active Units
    final unitsStream = (select(
      units,
    )..where((u) => u.status.equals(activeStatus))).watch();

    return Rx.combineLatest4(
      ciStream,
      variantsStream,
      componentsStream,
      unitsStream,
      (ciRows, allVariants, allCompsRows, allUnits) {
        // A. Pre-process Variants per CompanyItem
        final varsByCI = <String, List<Variant>>{};
        for (final v in allVariants) {
          varsByCI.putIfAbsent(v.companyItemId, () => []).add(v);
        }

        // B. Pre-process Components per Variant
        final compsByVar = <String, List<VariantComponentRow>>{};
        for (final row in allCompsRows) {
          final vc = row.readTable(variantComponents);
          final c = row.readTable(components);
          compsByVar
              .putIfAbsent(vc.variantId, () => [])
              .add(
                VariantComponentRow(
                  componentId: c.id,
                  name: c.name,
                  type: c.type,
                  // fields lain ignore dulu
                  totalUnits: 0,
                ),
              );
        }

        // C. Pre-process Units per Variant
        final unitsByVar = <String, List<Unit>>{};
        for (final u in allUnits) {
          unitsByVar.putIfAbsent(u.variantId!, () => []).add(u);
        }

        // D. Build Result
        final result = <CompanyItemListRow>[];

        for (final row in ciRows) {
          final ci = row.readTable(companyItems);
          final p = row.readTable(products);
          final r = row.readTableOrNull(racks);

          final myVariants = varsByCI[ci.id] ?? [];
          int totalAggregatedStock = 0;

          // Loop tiap variant di company item ini, hitung stok cerdas-nya, lalu jumlahkan
          for (final v in myVariants) {
            final stock = calculateVariantStock(
              variantId: v.id,
              components: compsByVar[v.id] ?? [],
              activeUnits: unitsByVar[v.id] ?? [],
            );
            totalAggregatedStock += stock;
          }

          result.add(
            CompanyItemListRow(
              companyItemId: ci.id,
              companyCode: ci.companyCode,
              productName: p.name,
              defaultRackId: r?.id,
              defaultRackName: r?.name,
              categoryName: null, // Isi sesuai query category jika ada
              totalUnits: totalAggregatedStock, // Total Stok Cerdas
              totalVariants: myVariants.length,
            ),
          );
        }

        // Sort
        result.sort((a, b) => a.companyCode.compareTo(b.companyCode));
        return result;
      },
    );
  }

  Stream<List<CompanyItemVariantRow>> watchVariantsWithStock(
    String companyItemId,
  ) {
    // ... (STREAM A: Variants - Tetap Sama)
    final variantsStream =
        (select(
          variants,
        )..where((v) => v.companyItemId.equals(companyItemId))).join([
          leftOuterJoin(brands, brands.id.equalsExp(variants.brandId)),
          leftOuterJoin(racks, racks.id.equalsExp(variants.rackId)),
        ]).watch();

    // ... (STREAM B: Components Definition - BALIK KE LOGIC LAMA TANPA QTY)
    final componentsDefStream =
        (select(variantComponents).join([
          innerJoin(
            components,
            components.id.equalsExp(variantComponents.componentId),
          ),
          innerJoin(
            variants,
            variants.id.equalsExp(variantComponents.variantId),
          ),
        ])..where(variants.companyItemId.equals(companyItemId))).watch().map((
          rows,
        ) {
          final map = <String, List<VariantComponentRow>>{};

          for (final row in rows) {
            final vc = row.readTable(variantComponents);
            final c = row.readTable(components);

            if (!map.containsKey(vc.variantId)) map[vc.variantId] = [];

            map[vc.variantId]!.add(
              VariantComponentRow(
                componentId: c.id,
                name: c.name,
                manufCode: c.manufCode,
                totalUnits: 0,
                type: c.type,
                // HAPUS quantityNeeded di sini
              ),
            );
          }
          return map;
        });

    // ... (STREAM C: Units - Tetap Sama)
    // 3. Stream C (Units) -> 🔴 GANTI BAGIAN INI DENGAN KODE DI BAWAH 🔴
    // Kita hapus .join() dan gunakan .isInQuery().
    // Ini menjamin data yang didapat adalah object Unit murni, bukan hasil mapping Join.
    final unitsStream =
        (select(units)..where(
              (u) =>
                  u.status.equals(activeStatus) &
                  // Ambil semua unit yang variantId-nya ada di dalam Variant milik CompanyItem ini
                  u.variantId.isInQuery(
                    selectOnly(variants)
                      ..addColumns([variants.id])
                      ..where(variants.companyItemId.equals(companyItemId)),
                  ),
            ))
            .watch()
            .map((rows) {
              final map = <String, List<Unit>>{};
              for (final u in rows) {
                // Karena ini query langsung ke tabel 'units', variable 'u' sudah bertipe 'Unit'
                // Tidak perlu lagi 'row.readTable(units)'
                if (u.variantId != null) {
                  if (!map.containsKey(u.variantId)) map[u.variantId!] = [];
                  map[u.variantId]!.add(u);
                }
              }
              return map;
            });

    // GABUNGKAN
    return Rx.combineLatest3(variantsStream, componentsDefStream, unitsStream, (
      variantRows,
      compsMap,
      unitsMap,
    ) {
      return variantRows.map((row) {
        final v = row.readTable(variants);
        final b = row.readTableOrNull(brands);
        final r = row.readTableOrNull(racks);

        final variantComps = compsMap[v.id] ?? [];
        final variantUnits = unitsMap[v.id] ?? [];

        // Panggil Logic Baru
        final calculatedStock = calculateVariantStock(
          variantId: v.id,
          components: variantComps,
          activeUnits: variantUnits,
        );

        return CompanyItemVariantRow(
          variantId: v.id,
          name: v.name,
          brandName: b?.name,
          rackName: r?.name,
          stock: calculatedStock,
        );
      }).toList();
    });
  }

  Future<CompanyItem?> getById(String id) {
    return (select(
      companyItems,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> updateDefaultRackCompanyItem({
    required String id,
    required String rackId,
  }) async {
    await (update(companyItems)..where((t) => t.id.equals(id))).write(
      CompanyItemsCompanion(
        defaultRackId: Value(rackId),
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

class CompanyItemVariantRow {
  final String variantId;
  final String name;
  final String? brandName;
  final String? rackName;
  final int stock;

  CompanyItemVariantRow({
    required this.variantId,
    required this.name,
    this.brandName,
    this.rackName,
    required this.stock,
  });

  CompanyItemVariantRow copyWith({int? stock}) {
    return CompanyItemVariantRow(
      variantId: variantId,
      name: name,
      brandName: brandName,
      rackName: rackName,
      stock: stock ?? this.stock,
    );
  }
}

class CompanyItemListRow {
  final String companyItemId;
  final String companyCode;
  final String productName;
  final String? categoryName; // kalau mau sekalian
  final String? defaultRackId; // kalau mau sekalian
  final String? defaultRackName; // kalau mau sekalian
  final int totalUnits; // total unit aktif untuk kode ini
  final int totalVariants; // total unit aktif untuk kode ini

  CompanyItemListRow({
    required this.companyItemId,
    required this.companyCode,
    required this.productName,
    this.categoryName,
    this.defaultRackId,
    this.defaultRackName,
    required this.totalVariants,
    required this.totalUnits,
  });

  CompanyItemListRow copyWith({int? totalUnits, int? totalVariants}) {
    return CompanyItemListRow(
      companyItemId: companyItemId,
      companyCode: companyCode,
      productName: productName,
      categoryName: categoryName,
      defaultRackId: defaultRackId,
      defaultRackName: defaultRackName,
      totalVariants: totalVariants ?? this.totalVariants,
      totalUnits: totalUnits ?? this.totalUnits,
    );
  }
}

/// Helper untuk menghitung stok berdasarkan Rules Anda
int calculateVariantStock({
  required String variantId,
  required List<VariantComponentRow> components,
  required List<Unit> activeUnits,
}) {
  // --- STEP 0: DEBUG HEADER ---
  // // print("\n=== DEBUG STOCK CALCULATION: $variantId ===");
  // // print("Total Active Units: ${activeUnits.length}");
  // // print("Total Defined Components: ${components.length}");

  // --- STEP 1: HITUNG PARENT ---
  int parentUnitsCount = 0;
  for (var u in activeUnits) {
    final cId = u.componentId;
    // Kita debug setiap unit untuk melihat kenapa dia lolos/gagal filter
    // bool isParent = cId == null || cId.trim().isEmpty || cId == "null";
    // ^ Jaga-jaga jika ada string "null"

    bool isNull = cId == null;
    bool isEmpty = cId != null && cId.trim().isEmpty;
    bool isLiteralNull = cId == "null"; // Cek string "null"

    if (isNull || isEmpty || isLiteralNull) {
      parentUnitsCount++;
    } else {
      // Ini unit komponen
      // // print(">> Unit ${u.id.substring(0,4)}... adalah KOMPONEN (ID: $cId)");
    }
  }
  // print("STEP 1 Result (Parent Count): $parentUnitsCount");

  // Jika tidak punya komponen, langsung return
  if (components.isEmpty) {
    // print("-> No components defined. Return: $parentUnitsCount");
    return parentUnitsCount;
  }

  // --- STEP 2: CEK TIPE ---
  final hasInBox = components.any((c) {
    final type = c.type.trim().toUpperCase();
    return type == 'IN_BOX';
  });
  // print("STEP 2 Type Check (hasInBox): $hasInBox");

  if (hasInBox) {
    // print("-> IN_BOX detected. Return: $parentUnitsCount");
    return parentUnitsCount;
  }

  // --- STEP 3: SEPARATE CALCULATION ---

  // A. Definisi Kebutuhan
  final definitionMap = <String, int>{};
  for (final c in components) {
    definitionMap[c.componentId] = (definitionMap[c.componentId] ?? 0) + 1;
  }
  // print("STEP 3A Definition: $definitionMap");

  // B. Stok Real
  final stockMap = <String, int>{};
  for (final u in activeUnits) {
    final cId = u.componentId;
    if (cId != null && cId.trim().isNotEmpty && cId != "null") {
      stockMap[cId] = (stockMap[cId] ?? 0) + 1;
    }
  }
  // print("STEP 3B Stock Map: $stockMap");

  // C. Min Sets
  int minComponentSets = 999999;

  if (stockMap.isEmpty) {
    minComponentSets = 0;
  } else {
    for (final entry in definitionMap.entries) {
      final compId = entry.key;
      final qtyNeeded = entry.value;
      final qtyAvailable = stockMap[compId] ?? 0;

      final possibleSets = qtyAvailable ~/ qtyNeeded;
      // print(
      //   "   -> Comp $compId: Available $qtyAvailable / Need $qtyNeeded = $possibleSets sets",
      // );

      if (possibleSets < minComponentSets) {
        minComponentSets = possibleSets;
      }
    }
  }

  if (minComponentSets == 999999) minComponentSets = 0;
  // print("STEP 3C Min Sets: $minComponentSets");

  final finalTotal = parentUnitsCount + minComponentSets;
  // print("=== FINAL RESULT: $finalTotal ===\n");

  return finalTotal;
}
