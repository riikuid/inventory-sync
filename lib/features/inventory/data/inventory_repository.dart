import 'package:drift/drift.dart' hide Component;
import 'package:inventory_sync_apps/core/db/app_database.dart';

import '../../../core/db/daos/company_item_dao.dart';
import '../../../core/db/daos/variant_dao.dart';

class InventoryRepository {
  final AppDatabase db;

  InventoryRepository(this.db);

  CompanyItemDao get _companyItemDao => db.companyItemDao;
  VariantDao get _variantDao => db.variantDao;
  // UnitDao get _unitDao => db.unitDao;

  Future<List<Brand>> getAllBrands() async {
    return db.brandDao.getAll(); // atau sesuai DAO mu
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
  Future<List<InventorySearchItem>> searchItems(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    final rows = await _companyItemDao.searchByQuery(query);

    // Untuk iterasi ini: stok = count unit ACTIVE per company_item (di semua variant).
    final results = <InventorySearchItem>[];

    for (final row in rows) {
      final companyItemId = row.item.id;

      // ambil semua variant untuk company_item ini
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

      results.add(
        InventorySearchItem(
          companyItemId: companyItemId,
          companyCode: row.item.companyCode,
          productName: row.product.name,
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

      variantSummaries.add(
        VariantSummary(
          variantId: v.id,
          name: v.name,
          brandName: brandName,
          defaultLocation: v.defaultLocation,
          stock: stock,
        ),
      );
    }

    return CompanyItemDetail(
      companyItemId: item.id,
      isSet: item.isSet,
      hasComponents: item.hasComponents,
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
    String? specJson,
  }) {
    return _variantDao.createComponentForProduct(
      productId: productId,
      brandId: brandId,
      name: name,
      manufCode: manufCode,
      specJson: specJson,
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
  final int stock;

  CompanyItemSummary({
    required this.companyItemId,
    required this.companyCode,
    required this.stock,
  });
}

/// DTO untuk list hasil search
class InventorySearchItem {
  final String companyItemId;
  final String companyCode;
  final String productName;
  final int activeStock;

  InventorySearchItem({
    required this.companyItemId,
    required this.companyCode,
    required this.productName,
    required this.activeStock,
  });
}

/// DTO untuk detail 1 company_item
class CompanyItemDetail {
  final String companyItemId;
  final String companyCode;
  final String productId;
  final String productName;
  final bool? isSet;
  final bool? hasComponents;
  final List<VariantSummary> variants;

  CompanyItemDetail({
    required this.companyItemId,
    required this.companyCode,
    required this.productId,
    required this.productName,
    required this.variants,
    required this.isSet,
    required this.hasComponents,
  });

  CompanyItemDetail copyWith({List<VariantSummary>? variants}) {
    return CompanyItemDetail(
      companyItemId: companyItemId,
      companyCode: companyCode,
      productId: productId,
      productName: productName,
      isSet: isSet,
      hasComponents: hasComponents,
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
  final String? defaultLocation;
  final int stock;

  VariantSummary({
    required this.variantId,
    required this.name,
    this.brandName,
    this.brandId,
    this.defaultLocation,
    required this.stock,
  });

  VariantSummary copyWith({
    String? name,
    String? brandName,
    String? brandId,
    String? defaultLocation,
    int? stock,
  }) {
    return VariantSummary(
      variantId: variantId,
      name: name ?? this.name,
      brandName: brandName ?? this.brandName,
      brandId: brandId ?? this.brandId,
      defaultLocation: defaultLocation ?? this.defaultLocation,
      stock: stock ?? this.stock,
    );
  }
}
