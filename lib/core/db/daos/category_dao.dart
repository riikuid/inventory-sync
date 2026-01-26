import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'category_dao.g.dart';

@DriftAccessor(tables: [Categories, Products, CompanyItems])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(AppDatabase db) : super(db);

  /// Ambil kategori utama (parent = null) + jumlah company item di dalamnya.
  ///
  /// Untuk iterasi ini:
  /// - hitung banyaknya `company_items` yang product-nya punya `category_id = categories.id`
  /// - belum include sub-category; nanti bisa kita extend kalau perlu.
  Stream<List<CategorySummary>> watchRootCategoriesWithItemCount() {
    // 1. Join langsung: categories -> company_items
    // Kita membuang tabel 'products' dari persamaan ini.
    final joinQuery =
        select(categories).join([
            leftOuterJoin(
              companyItems,
              // Hubungkan langsung categoryId di companyItems ke categories.id
              companyItems.categoryId.equalsExp(categories.id) &
                  companyItems.deletedAt.isNull(),
            ),
          ])
          // Tetap hanya ambil kategori utama
          ..where(categories.categoryParentId.isNull());

    return joinQuery.watch().map((rows) {
      final Map<String, CategorySummary> summaries = {};

      // Set ini menjaga agar jika ada duplikasi row dari SQL (jarang di left join simpel,
      // tapi tetap good practice), hitungan tetap akurat.
      final Map<String, Set<String>> companyItemIdsPerCategory = {};

      for (final row in rows) {
        final c = row.readTable(categories);
        final ci = row.readTableOrNull(companyItems);

        // Init summary
        summaries.putIfAbsent(
          c.id,
          () => CategorySummary(
            categoryId: c.id,
            name: c.name,
            code: c.code,
            companyItemCount: 0,
          ),
        );

        if (ci != null) {
          final set = companyItemIdsPerCategory.putIfAbsent(
            c.id,
            () => <String>{},
          );

          // Logika counting tetap sama
          if (set.add(ci.id)) {
            final current = summaries[c.id]!;
            summaries[c.id] = current.copyWith(
              companyItemCount: current.companyItemCount + 1,
            );
          }
        }
      }

      final list = summaries.values.toList()
        ..sort((a, b) => a.name.compareTo(b.name));

      return list;
    });
  }

  /// Kalau mau fetch sekali tanpa stream (jarang dipakai di home, tapi siapa tahu perlu).
  Future<List<CategorySummary>> getRootCategoriesWithItemCount() async {
    final joinQuery = select(categories).join([
      leftOuterJoin(
        companyItems,
        // Hubungkan langsung categoryId di companyItems ke categories.id
        companyItems.categoryId.equalsExp(categories.id) &
            companyItems.deletedAt.isNull(),
      ),
    ])..where(categories.categoryParentId.isNull());

    final rows = await joinQuery.get();

    final Map<String, CategorySummary> summaries = {};
    final Map<String, Set<String>> companyItemIdsPerCategory = {};

    for (final row in rows) {
      final c = row.readTable(categories);
      final ci = row.readTableOrNull(companyItems);

      summaries.putIfAbsent(
        c.id,
        () => CategorySummary(
          categoryId: c.id,
          name: c.name,
          code: c.code,
          companyItemCount: 0,
        ),
      );

      if (ci != null) {
        final set = companyItemIdsPerCategory.putIfAbsent(
          c.id,
          () => <String>{},
        );
        if (set.add(ci.id)) {
          final current = summaries[c.id]!;
          summaries[c.id] = current.copyWith(
            companyItemCount: current.companyItemCount + 1,
          );
        }
      }
    }

    final list = summaries.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    return list;
  }
}

class CategorySummary {
  final String categoryId;
  final String name;
  final String code;
  final int companyItemCount;

  CategorySummary({
    required this.categoryId,
    required this.name,
    required this.code,
    required this.companyItemCount,
  });

  CategorySummary copyWith({
    String? name,
    String? code,
    int? companyItemCount,
  }) {
    return CategorySummary(
      categoryId: categoryId,
      name: name ?? this.name,
      code: code ?? this.code,
      companyItemCount: companyItemCount ?? this.companyItemCount,
    );
  }
}
