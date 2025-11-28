// lib/features/sync/data/sync_mapper.dart
import 'package:drift/drift.dart';
import 'package:inventory_sync_apps/core/db/app_database.dart';

T? _cast<T>(dynamic v) => v == null ? null : v as T;

DateTime? _parseDate(dynamic v) {
  if (v == null) return null;
  if (v is String) return DateTime.tryParse(v);
  return null;
}

bool? _parseBool(dynamic v) {
  if (v == null) return null;
  if (v is bool) return v; // Jika backend sudah mengirim true/false
  if (v is int) return v == 1; // Jika backend mengirim 1 (true) atau 0 (false)
  if (v is String) {
    // Jaga-jaga jika backend mengirim string "1" atau "true"
    return v == '1' || v.toLowerCase() == 'true';
  }
  return false; // Fallback default
}

// ---------- CATEGORIES ----------
CategoriesCompanion categoryFromJson(Map<String, dynamic> json) {
  return CategoriesCompanion(
    id: Value(json['id'] as String),
    name: Value(json['name'] as String),
  );
}

// ---------- BRANDS ----------
BrandsCompanion brandFromJson(Map<String, dynamic> json) {
  return BrandsCompanion(
    id: Value(json['id'] as String),
    name: Value(json['name'] as String),
    lastModifiedAt: Value(
      _parseDate(json['last_modified_at']) ?? DateTime.now(),
    ),
    needSync: const Value(false),
  );
}

// ---------- PRODUCTS ----------
ProductsCompanion productFromJson(Map<String, dynamic> json) {
  return ProductsCompanion(
    id: Value(json['id'] as String),
    name: Value(json['name'] as String),
    categoryId: Value(json['category_id'] as String),
    description: Value(_cast<String>(json['description'])),
    isActive: Value(_parseBool(json['is_active']) ?? true),
    createdAt: Value(_parseDate(json['created_at']) ?? DateTime.now()),
    updatedAt: Value(_parseDate(json['updated_at']) ?? DateTime.now()),
    lastModifiedAt: Value(
      _parseDate(json['last_modified_at']) ?? DateTime.now(),
    ),
    needSync: const Value(false),
  );
}

// ---------- COMPANY ITEMS ----------
CompanyItemsCompanion companyItemFromJson(Map<String, dynamic> json) {
  return CompanyItemsCompanion(
    id: Value(json['id'] as String),
    productId: Value(json['product_id'] as String),
    companyCode: Value(json['company_code'] as String),
    isSet: Value(_parseBool(json['is_set']) ?? true),
    hasComponents: Value(_parseBool(json['has_components']) ?? true),
    initializedAt: Value(_parseDate(json['initialized_at'])),
    initializedBy: Value(_cast<String>(json['initialized_by'])),
    notes: Value(_cast<String>(json['notes'])),
    createdAt: Value(_parseDate(json['created_at']) ?? DateTime.now()),
    updatedAt: Value(_parseDate(json['updated_at']) ?? DateTime.now()),
    lastModifiedAt: Value(
      _parseDate(json['last_modified_at']) ?? DateTime.now(),
    ),
    deletedAt: Value(_parseDate(json['deleted_at'])),
    needSync: const Value(false),
  );
}

// ---------- VARIANTS ----------
VariantsCompanion variantFromJson(Map<String, dynamic> json) {
  return VariantsCompanion(
    id: Value(json['id'] as String),
    companyItemId: Value(json['company_item_id'] as String),
    brandId: Value(_cast<String>(json['brand_id'])),
    name: Value(json['name'] as String),
    defaultLocation: Value(_cast<String>(json['default_location'])),
    specJson: Value(_cast<String>(json['spec_json'])),
    initializedAt: Value(_parseDate(json['initialized_at'])),
    initializedBy: Value(_cast<String>(json['initialized_by'])),
    isActive: Value(_parseBool(json['is_active']) ?? true),
    createdAt: Value(_parseDate(json['created_at']) ?? DateTime.now()),
    updatedAt: Value(_parseDate(json['updated_at']) ?? DateTime.now()),
    deletedAt: Value(_parseDate(json['deleted_at'])),
    lastModifiedAt: Value(
      _parseDate(json['last_modified_at']) ?? DateTime.now(),
    ),
    needSync: const Value(false),
  );
}

// ---------- VARIANT PHOTOS ----------
VariantPhotosCompanion variantPhotoFromJson(Map<String, dynamic> json) {
  return VariantPhotosCompanion(
    id: Value(json['id'] as String),
    variantId: Value(json['variant_id'] as String),
    localPath: Value(_cast<String>(json['local_path']) ?? ''), // optional
    remoteUrl: Value(_cast<String>(json['remote_url'])),
    position: Value(json['position'] as int? ?? 0),
    createdAt: Value(_parseDate(json['created_at']) ?? DateTime.now()),
    updatedAt: Value(_parseDate(json['updated_at']) ?? DateTime.now()),
    deletedAt: Value(_parseDate(json['deleted_at'])),
    lastModifiedAt: Value(
      _parseDate(json['last_modified_at']) ?? DateTime.now(),
    ),
    needSync: const Value(false),
  );
}

// ---------- COMPONENTS ----------
ComponentsCompanion componentFromJson(Map<String, dynamic> json) {
  return ComponentsCompanion(
    id: Value(json['id'] as String),
    productId: Value(json['product_id'] as String),
    name: Value(json['name'] as String),
    brandId: Value(_cast<String>(json['brand_id'])),
    manufCode: Value(_cast<String>(json['manuf_code'])),
    specJson: Value(_cast<String>(json['spec_json'])),
    isActive: Value(_parseBool(json['is_active']) ?? true),
    createdAt: Value(_parseDate(json['created_at']) ?? DateTime.now()),
    updatedAt: Value(_parseDate(json['updated_at']) ?? DateTime.now()),
    deletedAt: Value(_parseDate(json['deleted_at'])),
    lastModifiedAt: Value(
      _parseDate(json['last_modified_at']) ?? DateTime.now(),
    ),
    needSync: const Value(false),
  );
}

// ---------- VARIANT COMPONENTS ----------
VariantComponentsCompanion variantComponentFromJson(Map<String, dynamic> json) {
  return VariantComponentsCompanion(
    id: Value(json['id'] as String),
    variantId: Value(json['variant_id'] as String),
    componentId: Value(json['component_id'] as String),
    quantity: Value(json['quantity'] as int? ?? 1),
    createdAt: Value(_parseDate(json['created_at']) ?? DateTime.now()),
    updatedAt: Value(_parseDate(json['updated_at']) ?? DateTime.now()),
    lastModifiedAt: Value(
      _parseDate(json['last_modified_at']) ?? DateTime.now(),
    ),
    needSync: const Value(false),
  );
}

// ---------- BUFFER STOCKS ----------
BufferStocksCompanion bufferStockFromJson(Map<String, dynamic> json) {
  return BufferStocksCompanion(
    id: Value(json['id'] as String),
    companyItemId: Value(json['company_item_id'] as String),
    brandId: Value(_cast<String>(json['brand_id'])),
    location: Value(_cast<String>(json['location'])),
    minQuantity: Value(json['min_quantity'] as int),
    createdAt: Value(_parseDate(json['created_at']) ?? DateTime.now()),
    updatedAt: Value(_parseDate(json['updated_at']) ?? DateTime.now()),
  );
}

// ---------- UNITS ----------
UnitsCompanion unitFromJson(Map<String, dynamic> json) {
  return UnitsCompanion(
    id: Value(json['id'] as String),
    variantId: Value(_cast<String>(json['variant_id'])),
    componentId: Value(_cast<String>(json['component_id'])),
    parentUnitId: Value(_cast<String>(json['parent_unit_id'])),
    qrValue: Value(json['qr_value'] as String),
    status: Value(json['status'] as String? ?? 'ACTIVE'),
    location: Value(_cast<String>(json['location'])),
    printCount: Value(json['print_count'] as int? ?? 0),
    lastPrintedAt: Value(_parseDate(json['last_printed_at'])),
    createdBy: Value(_cast<String>(json['created_by'])),
    updatedBy: Value(_cast<String>(json['updated_by'])),
    lastPrintedBy: Value(_cast<String>(json['last_printed_by'])),
    syncedAt: Value(_parseDate(json['synced_at'])),
    lastModifiedAt: Value(
      _parseDate(json['last_modified_at']) ?? DateTime.now(),
    ),
    createdAt: Value(_parseDate(json['created_at']) ?? DateTime.now()),
    updatedAt: Value(_parseDate(json['updated_at']) ?? DateTime.now()),
    deletedAt: Value(_parseDate(json['deleted_at'])),
    needSync: const Value(false), // data dari server dianggap sudah sync
  );
}
