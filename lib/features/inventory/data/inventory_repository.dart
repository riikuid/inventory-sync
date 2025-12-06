import 'package:drift/drift.dart' hide Component;
import 'package:inventory_sync_apps/core/db/app_database.dart';

import '../../../core/db/daos/category_dao.dart';
import '../../../core/db/daos/company_item_dao.dart';
import '../../../core/db/daos/variant_dao.dart';
import 'model/inventory_search_item.dart';

class InventoryRepository {
  final AppDatabase db;

  InventoryRepository(this.db);

  CompanyItemDao get _companyItemDao => db.companyItemDao;
  VariantDao get _variantDao => db.variantDao;
  CategoryDao get _categoryDao => db.categoryDao;
  // UnitDao get _unitDao => db.unitDao;

  Future<List<Brand>> getAllBrands() async {
    return db.brandDao.getAll(); // atau sesuai DAO mu
  }

  /// Dipakai di section "KATEGORI" di home
  Stream<List<CategorySummary>> watchRootCategories() {
    return _categoryDao.watchRootCategoriesWithItemCount();
  }

  Future<List<ProductSummary>> getProductList({String? search}) async {
    final q = search?.trim();
    final selectProducts = db.select(db.products);

    if (q != null && q.isNotEmpty) {
      selectProducts.where((p) => p.name.like('%$q%'));
    }

    final products = await selectProducts.get();

    // untuk iterasi ini: ambil hanya produk yang punya company_items
    final result = <ProductSummary>[];

    for (final p in products) {
      final companyItems = await (db.select(
        db.companyItems,
      )..where((ci) => ci.productId.equals(p.id))).get();

      if (companyItems.isEmpty) {
        // kalau benar2 mau semua product tampil, hapus if ini
        continue;
      }

      // hitung stok total aktif dari semua company_item di product ini
      final companyItemIds = companyItems.map((ci) => ci.id).toList();

      // ambil semua variant dari company_items ini
      final variants = await (db.select(
        db.variants,
      )..where((v) => v.companyItemId.isIn(companyItemIds))).get();

      final variantIds = variants.map((v) => v.id).toList();

      int totalStock = 0;
      if (variantIds.isNotEmpty) {
        final units =
            await (db.select(db.units)..where(
                  (u) =>
                      u.status.equals('ACTIVE') & u.variantId.isIn(variantIds),
                ))
                .get();
        totalStock = units.length;
      }

      result.add(
        ProductSummary(
          productId: p.id,
          productName: p.name,
          companyItemCount: companyItems.length,
          totalActiveStock: totalStock,
        ),
      );
    }

    return result;
  }

  // --- NEW: list company item per product ---
  Future<List<CompanyItemSummary>> getCompanyItemsByProduct(
    String productId,
  ) async {
    final items = await (db.select(
      db.companyItems,
    )..where((ci) => ci.productId.equals(productId))).get();

    final result = <CompanyItemSummary>[];

    for (final ci in items) {
      // hitung stok aktif untuk company_item ini
      final variants = await (db.select(
        db.variants,
      )..where((v) => v.companyItemId.equals(ci.id))).get();
      final product = await (db.select(
        db.products,
      )..where((p) => p.id.equals(ci.productId))).getSingleOrNull();
      final category =
          await (db.select(db.categories)
                ..where((c) => c.id.equals(product?.categoryId ?? '')))
              .getSingleOrNull();
      final variantIds = variants.map((v) => v.id).toList();

      int stock = 0;
      if (variantIds.isNotEmpty) {
        final units =
            await (db.select(db.units)..where(
                  (u) =>
                      u.status.equals('ACTIVE') & u.variantId.isIn(variantIds),
                ))
                .get();
        stock = units.length;
      }

      result.add(
        CompanyItemSummary(
          productId: ci.productId,
          productName: product?.name ?? '',
          categoryId: product?.categoryId ?? '',
          categoryName: category?.name ?? '',
          companyItemId: ci.id,
          companyCode: ci.companyCode,
          stock: stock,
        ),
      );
    }

    // bisa di-sort kalau mau
    result.sort((a, b) => a.companyCode.compareTo(b.companyCode));

    return result;
  }

  /// Model hasil search sederhana
  /// Model hasil search sederhana (group by company_item, plus info kategori)
  Future<List<InventorySearchItem>> searchItems(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    final rows = await _companyItemDao.searchByQuery(query);

    // Cache kategori biar nggak query berulang
    final Map<String, String> _categoryNameCache = {};

    final results = <InventorySearchItem>[];

    for (final row in rows) {
      final companyItemId = row.item.id;
      final product = row.product;

      // --- 1. Hitung stok aktif untuk company_item ini (semua variant) ---
      final variants = await (db.select(
        db.variants,
      )..where((v) => v.companyItemId.equals(companyItemId))).get();

      final variantIds = variants.map((v) => v.id).toList();

      int activeStock = 0;
      if (variantIds.isNotEmpty) {
        final unitsList =
            await (db.select(db.units)..where(
                  (u) =>
                      u.status.equals('ACTIVE') & u.variantId.isIn(variantIds),
                ))
                .get();
        activeStock = unitsList.length;
      }

      // --- 2. Ambil kategori utama dari product.categoryId ---
      String? categoryId = product.categoryId;
      String? categoryName;

      if (categoryId != null) {
        if (_categoryNameCache.containsKey(categoryId)) {
          categoryName = _categoryNameCache[categoryId];
        } else {
          final category = await (db.select(
            db.categories,
          )..where((c) => c.id.equals(categoryId))).getSingleOrNull();
          categoryName = category?.name;
          if (categoryName != null) {
            _categoryNameCache[categoryId] = categoryName;
          }
        }
      }

      results.add(
        InventorySearchItem(
          companyItemId: companyItemId,
          companyCode: row.item.companyCode,
          productName: product.name,
          categoryId: categoryId,
          categoryName: categoryName,
          rackName: null, // nanti kalau mau diisi lokasi fisik, bisa dilengkapi
          warehouseName: null,
          activeStock: activeStock,
        ),
      );
    }

    return results;
  }

  /// Detail per company_item: list variant + stok masing-masing
  Future<CompanyItemDetail?> getCompanyItemDetail(String companyItemId) async {
    final item = await _companyItemDao.getById(companyItemId);
    if (item == null) return null;

    final product = await (db.select(
      db.products,
    )..where((p) => p.id.equals(item.productId))).getSingleOrNull();

    // ambil semua variant untuk company_item ini
    final variants = await (db.select(
      db.variants,
    )..where((v) => v.companyItemId.equals(companyItemId))).get();

    final variantSummaries = <VariantSummary>[];

    for (final v in variants) {
      // hitung stok unit ACTIVE untuk variant ini
      final units =
          await (db.select(db.units)..where(
                (u) => u.status.equals('ACTIVE') & u.variantId.equals(v.id),
              ))
              .get();

      final stock = units.length;

      // ambil brand kalau ada
      String? brandName;
      if (v.brandId != null) {
        final brand = await (db.select(
          db.brands,
        )..where((b) => b.id.equals(v.brandId!))).getSingleOrNull();
        brandName = brand?.name;
      }

      String? rackName;
      if (v.rackId != null) {
        final rack = await (db.select(
          db.racks,
        )..where((r) => r.id.equals(v.rackId!))).getSingleOrNull();
        rackName = rack?.name;
      }

      variantSummaries.add(
        VariantSummary(
          variantId: v.id,
          name: v.name,
          brandName: brandName,
          rackName: rackName,
          stock: stock,
        ),
      );
    }

    return CompanyItemDetail(
      companyItemId: item.id,
      companyCode: item.companyCode,
      productId: item.productId,
      productName: product?.name ?? '-',
      variants: variantSummaries,
    );
  }

  Stream<List<CompanyItemListRow>> watchCompanyItems({String? productId}) {
    return _companyItemDao.watchCompanyItemsWithStock(productId: productId);
  }

  Stream<List<CompanyItemVariantRow>> watchVariantsWithStockForItem(
    String companyItemId,
  ) {
    return _companyItemDao.watchVariantsWithStock(companyItemId);
  }

  Stream<VariantDetailRow?> watchVariantDetail(String variantId) {
    return _variantDao.watchVariantDetail(variantId);
  }

  Future<List<Component>> getComponentsForProduct(String productId) {
    return _variantDao.getComponentsByProduct(productId);
  }

  Future<Component> createComponentForVariantProduct({
    required String productId,
    required String? brandId,
    required String name,
    String? manufCode,
    String? specification,
  }) {
    return _variantDao.createComponentForProduct(
      productId: productId,
      brandId: brandId,
      name: name,
      manufCode: manufCode,
      specification: specification,
    );
  }

  Future<void> attachComponentToVariant({
    required String variantId,
    required String componentId,
  }) {
    return _variantDao.attachComponentToVariant(
      variantId: variantId,
      componentId: componentId,
    );
  }

  Future<void> detachComponentFromVariant({
    required String variantId,
    required String componentId,
  }) {
    return _variantDao.detachComponentFromVariant(
      variantId: variantId,
      componentId: componentId,
    );
  }

  Future<void> deleteComponent(String componentId) {
    return _variantDao.deleteComponent(componentId);
  }
}

class ProductSummary {
  final String productId;
  final String productName;
  final int companyItemCount;
  final int totalActiveStock;

  ProductSummary({
    required this.productId,
    required this.productName,
    required this.companyItemCount,
    required this.totalActiveStock,
  });
}

class CompanyItemSummary {
  final String companyItemId;
  final String companyCode;
  final String productId;
  final String productName;
  final String categoryId;
  final String categoryName;
  final String? rackName;
  final String? warehouseName;
  final int stock;

  CompanyItemSummary({
    required this.companyItemId,
    required this.companyCode,
    required this.productId,
    required this.productName,
    required this.categoryId,
    required this.categoryName,
    this.rackName,
    this.warehouseName,
    required this.stock,
  });
}

/// DTO untuk detail 1 company_item
class CompanyItemDetail {
  final String companyItemId;
  final String companyCode;
  final String productId;
  final String productName;
  final List<VariantSummary> variants;

  CompanyItemDetail({
    required this.companyItemId,
    required this.companyCode,
    required this.productId,
    required this.productName,
    required this.variants,
  });

  CompanyItemDetail copyWith({List<VariantSummary>? variants}) {
    return CompanyItemDetail(
      companyItemId: companyItemId,
      companyCode: companyCode,
      productId: productId,
      productName: productName,
      variants: variants ?? this.variants,
    );
  }
}

/// DTO variant di detail screen
class VariantSummary {
  final String variantId;
  final String name;
  final String? brandName;
  final String? brandId;
  final String? rackId;
  final String? rackName;
  final String? warehouseName;
  final int stock;

  VariantSummary({
    required this.variantId,
    required this.name,
    this.brandName,
    this.brandId,
    this.rackId,
    this.rackName,
    this.warehouseName,
    required this.stock,
  });

  VariantSummary copyWith({
    String? name,
    String? brandName,
    String? brandId,
    String? rackId,
    String? rackName,
    String? warehouseName,
    int? stock,
  }) {
    return VariantSummary(
      variantId: variantId,
      name: name ?? this.name,
      brandName: brandName ?? this.brandName,
      brandId: brandId ?? this.brandId,
      rackId: rackId ?? this.rackId,
      rackName: rackName ?? this.rackName,
      warehouseName: warehouseName ?? this.warehouseName,
      stock: stock ?? this.stock,
    );
  }
}
