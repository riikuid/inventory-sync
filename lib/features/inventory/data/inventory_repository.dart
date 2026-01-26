import 'dart:developer' as dev;

import 'package:drift/drift.dart' hide Component;
import 'package:inventory_sync_apps/core/constant.dart';
import 'package:inventory_sync_apps/core/db/app_database.dart';
import 'package:inventory_sync_apps/core/db/daos/component_dao.dart';
import 'package:inventory_sync_apps/core/db/daos/component_photo_dao.dart';
import 'package:inventory_sync_apps/core/db/daos/rack_dao.dart';
import 'package:inventory_sync_apps/core/generate_custom_id.dart';

import '../../../core/db/daos/category_dao.dart';
import '../../../core/db/daos/company_item_dao.dart';
import '../../../core/db/daos/variant_dao.dart';
import '../../../core/db/daos/variant_photo_dao.dart';
import '../../../core/db/model/variant_component_row.dart';
import '../../../core/db/model/variant_detail_row.dart';
import '../../../shared/services/photo_cache_service.dart';
import 'model/inventory_search_item.dart';

class InventoryRepository {
  final AppDatabase db;
  // final _uuid = const Uuid();

  InventoryRepository(this.db);

  CompanyItemDao get _companyItemDao => db.companyItemDao;
  VariantDao get _variantDao => db.variantDao;
  VariantPhotoDao get _variantPhotoDao => db.variantPhotoDao;
  // VariantComponentDao get _variantComponentDao => db.variantComponentDao;

  ComponentDao get _componentDao => db.componentDao;
  ComponentPhotoDao get _componentPhotoDao => db.componentPhotoDao;

  CategoryDao get _categoryDao => db.categoryDao;
  RackDao get _rackDao => db.rackDao;
  // UnitDao get _unitDao => db.unitDao;

  Future<List<Brand>> getAllBrands() async {
    return db.brandDao.getAll(); // atau sesuai DAO mu
  }

  Future<List<Warehouse>> getAllWarehouses() async {
    return db.select(db.warehouses).get();
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
                      u.status.equals(activeStatus) &
                      u.variantId.isIn(variantIds),
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

  /// Model hasil search sederhana
  /// Model hasil search sederhana (group by company_item, plus info kategori)
  Future<List<InventorySearchItem>> searchItems(
    String query, {
    required List<String> sectionIds,
  }) {
    return _companyItemDao.searchItems(query, sectionIds: sectionIds);
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
    if (item.categoryId != null) {
      final category = await (db.select(
        db.categories,
      )..where((c) => c.id.equals(item.categoryId!))).getSingleOrNull();

      categoryName = category?.name;
    }

    dev.log('cateogryId: ${item.toJsonString()}');

    // 4. Ambil Default Rack Name
    String? defaultRackName;
    if (item.defaultRackId != null) {
      final rack = await (db.select(
        db.racks,
      )..where((r) => r.id.equals(item.defaultRackId!))).getSingleOrNull();
      defaultRackName = rack?.name;
    }

    String? sectionName;
    if (item.sectionId != null) {
      final section = await (db.select(
        db.sections,
      )..where((s) => s.id.equals(item.sectionId!))).getSingleOrNull();
      sectionName = section?.name;
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
        final vc = row.readTable(db.variantComponents);
        final c = row.readTable(db.components);
        return VariantComponentRow(
          quantity: vc.quantity,
          variantId: v.id,
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
                (u) => u.status.equals(activeStatus) & u.variantId.equals(v.id),
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
      sectionName: sectionName ?? '',
      categoryName: categoryName ?? '',
      productId: item.productId,
      productName: product?.name ?? '-',
      variants: variantSummaries,
    );
  }

  /// Get company item by ID
  Future<CompanyItem?> getCompanyItemById(String companyItemId) async {
    return await _companyItemDao.getById(companyItemId);
  }

  Future<CompanyItem?> getCompanyItemByCode(String code) async {
    return await _companyItemDao.getCompanyItemByCode(code);
  }

  Future<CompanyItemListRow?> getCompanyItemByCompanyCode(String code) async {
    return await _companyItemDao.getCompanyItemByCompanyCode(code);
  }

  /// Get rack by ID with complete details
  Future<dynamic> getRackById(String rackId) async {
    return await _rackDao.getById(rackId);
  }

  /// Update default rack for company item
  Future<void> updateCompanyItemDefaultRack({
    required String companyItemId,
    required String rackId,
  }) async {
    await _companyItemDao.updateDefaultRackCompanyItem(
      id: companyItemId,
      rackId: rackId,
    );
  }

  Stream<List<CompanyItemListRow>> watchCompanyItems({
    required List<String> sectionIds,
  }) {
    return _companyItemDao.watchDashboardItems(sectionIds: sectionIds);
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
    int type = separateType,
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
    required int type,
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
      final component = generateCustomId(componentsPrefix);

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
        final photoId = generateCustomId(componentPhotosPrefix);
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
    required int type,
  }) {
    return _variantDao.getComponentsByProductAndType(
      productId: productId,
      type: type,
    );
  }

  Stream<List<VariantComponentRow>> watchVariantComponentsByType({
    required String variantId,
    required int type,
  }) {
    return _variantDao.watchVariantComponentsByType(
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
    int? type,
  }) {
    return _variantDao.createComponentForProduct(
      productId: productId,
      brandId: brandId,
      name: name,
      manufCode: manufCode,
      specification: specification,
      type: type ?? separateType,
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

  /// Update quantity komponen dalam variant
  Future<void> updateVariantComponentQuantity({
    required String variantId,
    required String componentId,
    required int quantity,
  }) {
    return _variantDao.updateVariantComponentQuantity(
      variantId: variantId,
      componentId: componentId,
      quantity: quantity,
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

  /// Update local path foto setelah download
  Future<void> updatePhotoLocalPath({
    required String photoId,
    required String localPath,
  }) async {
    await _variantPhotoDao.updateLocalPath(
      photoId: photoId,
      localPath: localPath,
    );
  }

  /// Batch download photos untuk variant tertentu
  /// Berguna untuk pre-cache semua foto saat user membuka detail
  Future<void> downloadVariantPhotos(String variantId) async {
    try {
      final photos = await _variantPhotoDao.getPhotosNeedDownload(variantId);

      for (final photo in photos) {
        if (photo.remoteUrl != null) {
          final String fullUrl = photo.remoteUrl!.startsWith('http')
              ? photo.remoteUrl!
              : '$baseUrl/${photo.remoteUrl}';

          final localPath = await PhotoCacheService.downloadAndCache(
            remoteUrl: fullUrl,
            photoId: photo.id,
          );

          if (localPath != null) {
            await updatePhotoLocalPath(photoId: photo.id, localPath: localPath);
          }
        }
      }
    } catch (e) {
      dev.log('Error batch downloading photos: $e');
    }
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
  final String? sectionName;
  final String? defaultRackId;
  final String? defaultRackName;
  final List<VariantSummary> variants;

  CompanyItemDetail({
    this.defaultRackId,
    this.defaultRackName,
    this.sectionName,
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
      sectionName: sectionName,
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
