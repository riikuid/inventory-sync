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
    // join categories -> products -> company_items
    final joinQuery =
        select(categories).join([
            leftOuterJoin(
              products,
              products.categoryId.equalsExp(categories.id),
            ),
            leftOuterJoin(
              companyItems,
              companyItems.productId.equalsExp(products.id) &
                  companyItems.deletedAt.isNull(),
            ),
          ])
          // hanya kategori utama (tidak punya parent)
          ..where(categories.categoryParentId.isNull());

    return joinQuery.watch().map((rows) {
      final Map<String, CategorySummary> summaries = {};
      final Map<String, Set<String>> companyItemIdsPerCategory = {};

      for (final row in rows) {
        final c = row.readTable(categories);
        final ci = row.readTableOrNull(companyItems);

        // init summary kalau belum ada
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
          // pastikan 1 company_item tidak dihitung 2x
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
      leftOuterJoin(products, products.categoryId.equalsExp(categories.id)),
      leftOuterJoin(
        companyItems,
        companyItems.productId.equalsExp(products.id) &
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
