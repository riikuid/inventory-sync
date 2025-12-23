import 'dart:developer' as dev;

import 'package:drift/drift.dart' hide Component;
import 'package:inventory_sync_apps/core/db/app_database.dart';
import 'package:inventory_sync_apps/core/db/daos/component_dao.dart';
import 'package:inventory_sync_apps/core/db/daos/component_photo_dao.dart';
import 'package:inventory_sync_apps/core/db/daos/variant_component_dao.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/daos/category_dao.dart';
import '../../../core/db/daos/company_item_dao.dart';
import '../../../core/db/daos/variant_dao.dart';
import '../../../core/db/model/variant_component_row.dart';
import '../../../core/db/model/variant_detail_row.dart';
import 'model/inventory_search_item.dart';

class InventoryRepository {
  final AppDatabase db;
  final _uuid = const Uuid();

  InventoryRepository(this.db);

  CompanyItemDao get _companyItemDao => db.companyItemDao;
  VariantDao get _variantDao => db.variantDao;
  VariantComponentDao get _variantComponentDao => db.variantComponentDao;

  ComponentDao get _componentDao => db.componentDao;
  ComponentPhotoDao get _componentPhotoDao => db.componentPhotoDao;

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
          variantCount: variants.length,
        ),
      );
    }

    return results;
  }

  /// Detail per company_item: list variant + stok masing-masing
  Future<CompanyItemDetail?> getCompanyItemDetail(String companyItemId) async {
    // 1. Ambil Item Utama
    final item = await _companyItemDao.getById(companyItemId);
    if (item == null) return null;

    // 2. Ambil Product
    final product = await (db.select(
      db.products,
    )..where((p) => p.id.equals(item.productId))).getSingleOrNull();

    // 3. Ambil Category Name
    String? categoryName;
    if (product != null && product.categoryId != null) {
      final category = await (db.select(
        db.categories,
      )..where((c) => c.id.equals(product.categoryId!))).getSingleOrNull();

      categoryName = category?.name;
    }

    // 4. Ambil Default Rack Name
    String? defaultRackName;
    if (item.defaultRackId != null) {
      final rack = await (db.select(
        db.racks,
      )..where((r) => r.id.equals(item.defaultRackId!))).getSingleOrNull();
      defaultRackName = rack?.name;
    }

    // 5. Ambil Semua Variant
    final variants = await (db.select(
      db.variants,
    )..where((v) => v.companyItemId.equals(companyItemId))).get();

    final variantSummaries = <VariantSummary>[];

    // --- LOOPING VARIANT (LOGIC STOCK BARU DI SINI) ---
    for (final v in variants) {
      // A. Ambil Definisi Komponen untuk Variant ini (Untuk cek Type IN_BOX/SEPARATE)
      final componentRows = await (db.select(db.variantComponents).join([
        innerJoin(
          db.components,
          db.components.id.equalsExp(db.variantComponents.componentId),
        ),
      ])..where(db.variantComponents.variantId.equals(v.id))).get();

      // Mapping ke DTO VariantComponentRow (agar bisa dibaca helper)
      final myComponents = componentRows.map((row) {
        final c = row.readTable(db.components);
        return VariantComponentRow(
          componentId: c.id,
          name: c.name,
          manufCode: c.manufCode,
          totalUnits: 0, // Dummy, tidak dipakai di helper ini
          type: c.type, // Penting: IN_BOX atau SEPARATE
        );
      }).toList();

      // B. Ambil Raw Active Units (Tanpa Join, agar data akurat)
      final activeUnits =
          await (db.select(db.units)..where(
                (u) => u.status.equals('ACTIVE') & u.variantId.equals(v.id),
              ))
              .get();

      // C. HITUNG STOK MENGGUNAKAN HELPER 'SAKTI'
      final calculatedStock = calculateVariantStock(
        variantId: v.id,
        components: myComponents,
        activeUnits: activeUnits,
      );

      // --- Sisa Logic (Ambil Brand & Rack) Tetap Sama ---

      // Ambil Brand
      String? brandName;
      if (v.brandId != null) {
        final brand = await (db.select(
          db.brands,
        )..where((b) => b.id.equals(v.brandId!))).getSingleOrNull();
        brandName = brand?.name;
      }

      // Ambil Rack Variant
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
          manufCode: v.manufCode,
          brandName: brandName,
          rackName: rackName,
          stock: calculatedStock, // <--- GUNAKAN HASIL PERHITUNGAN BARU
        ),
      );
    }

    return CompanyItemDetail(
      companyItemId: item.id,
      companyCode: item.companyCode,
      defaultRackId: item.defaultRackId,
      defaultRackName: defaultRackName,
      categoryName: categoryName ?? '',
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

  Future<Component> createComponentForProductWithType({
    required String productId,
    String? brandId,
    required String name,
    String? manufCode,
    String? specification,
    String type = 'SEPARATE',
  }) {
    return _variantDao.createComponentForProduct(
      productId: productId,
      brandId: brandId,
      name: name,
      manufCode: manufCode,
      specification: specification,
      type: type,
    );
  }

  // Future<Component> createInBoxPartAndAttach({
  //   required String variantId,
  //   required String productId,
  //   String? brandId,
  //   required String name,
  //   String? manufCode,
  //   String? specification,
  //   required List<String> photos,
  // }) {
  //   return _variantDao.createInBoxPartAndAttach(
  //     variantId: variantId,
  //     productId: productId,
  //     brandId: brandId,
  //     name: name,
  //     manufCode: manufCode,
  //     specification: specification,
  //   );
  // }

  Future<void> createComponentAndAttach({
    required String variantId,
    required String productId,
    String? brandId,
    required String name,
    required String type,
    String? manufCode,
    String? specification,
    required List<String> photos,
  }) async {
    final now = DateTime.now();

    if (photos.isEmpty) {
      throw Exception('Foto komponen tidak boleh kosong');
    }

    await db.transaction(() async {
      // 1. create component
      final component = _uuid.v4();

      final componentCompanion = ComponentsCompanion(
        id: Value(component),
        productId: Value(productId),
        type: Value(type),
        brandId: Value(brandId),
        name: Value(name),
        specification: Value(specification),
        manufCode: Value(manufCode),
        createdAt: Value(now),
        updatedAt: Value(now),
        lastModifiedAt: Value(now),
        needSync: const Value(true),
      );

      await _componentDao.upsertComponents([componentCompanion]);

      // 2. simpan photos
      final photoCompanions = <ComponentPhotosCompanion>[];
      for (var i = 0; i < photos.length; i++) {
        final photoId = _uuid.v4();
        photoCompanions.add(
          ComponentPhotosCompanion(
            id: Value(photoId),
            componentId: Value(component),
            localPath: Value(photos[i]),
            remoteUrl: const Value(null),
            sortOrder: Value(i),
            createdAt: Value(now),
            updatedAt: Value(now),
            lastModifiedAt: Value(now),
            needSync: const Value(true),
          ),
        );
      }
      await _componentPhotoDao.upsertPhotos(photoCompanions);

      // 3. attach ke variant
      await _variantDao.attachComponentToVariant(
        variantId: variantId,
        componentId: component,
      );
    });
  }

  Future<List<Component>> getComponentsByProductAndType({
    required String productId,
    required String type,
  }) {
    return _variantDao.getComponentsByProductAndType(
      productId: productId,
      type: type,
    );
  }

  Stream<List<VariantComponentRow>> watchVariantComponentsByType({
    required String variantId,
    required String type,
  }) {
    return _variantDao.watchVariantComponentsByType(
      variantId: variantId,
      type: type,
    );
  }

  Future<List<VariantComponentRow>> getVariantComponentsByType({
    required String variantId,
    required String type,
  }) {
    return _variantDao.getVariantComponentsByType(
      variantId: variantId,
      type: type,
    );
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
    String? type,
  }) {
    return _variantDao.createComponentForProduct(
      productId: productId,
      brandId: brandId,
      name: name,
      manufCode: manufCode,
      specification: specification,
      type: type ?? 'SEPARATE',
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
  final String? specification;
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
    this.specification,
    required this.stock,
  });
}

/// DTO untuk detail 1 company_item
class CompanyItemDetail {
  final String companyItemId;
  final String companyCode;
  final String categoryName;
  final String productId;
  final String productName;
  final String? defaultRackId;
  final String? defaultRackName;
  final List<VariantSummary> variants;

  CompanyItemDetail({
    this.defaultRackId,
    this.defaultRackName,
    required this.companyItemId,
    required this.companyCode,
    required this.categoryName,
    required this.productId,
    required this.productName,
    required this.variants,
  });

  CompanyItemDetail copyWith({List<VariantSummary>? variants}) {
    return CompanyItemDetail(
      companyItemId: companyItemId,
      companyCode: companyCode,
      categoryName: categoryName,
      productId: productId,
      productName: productName,
      defaultRackId: defaultRackId,
      defaultRackName: defaultRackName,
      variants: variants ?? this.variants,
    );
  }
}

/// DTO variant di detail screen
class VariantSummary {
  final String variantId;
  final String name;
  final String? brandName;
  final String? manufCode;
  final String? brandId;
  final String? rackId;
  final String? rackName;
  final String? warehouseName;
  final String? specification;
  final int stock;

  VariantSummary({
    required this.variantId,
    required this.name,
    this.brandName,
    this.manufCode,
    this.brandId,
    this.rackId,
    this.rackName,
    this.warehouseName,
    this.specification,
    required this.stock,
  });

  VariantSummary copyWith({
    String? name,
    String? brandName,
    String? manufCode,
    String? brandId,
    String? rackId,
    String? rackName,
    String? warehouseName,
    String? specification,
    int? stock,
  }) {
    return VariantSummary(
      variantId: variantId,
      name: name ?? this.name,
      brandName: brandName ?? this.brandName,
      manufCode: manufCode ?? this.manufCode,
      brandId: brandId ?? this.brandId,
      rackId: rackId ?? this.rackId,
      rackName: rackName ?? this.rackName,
      warehouseName: warehouseName ?? this.warehouseName,
      specification: specification ?? this.specification,
      stock: stock ?? this.stock,
    );
  }
}
