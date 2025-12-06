// lib/features/sync/data/sync_mapper.dart
import 'package:drift/drift.dart';
import 'package:inventory_sync_apps/core/db/app_database.dart';

String? toStr(dynamic v) => v?.toString();

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
    categoryParentId: Value(toStr(json['category_parent_id'])),
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

// ---------- DEPARTMENTS ----------
DepartmentsCompanion departmentFromJson(Map<String, dynamic> json) {
  return DepartmentsCompanion(
    id: Value(json['id'] as String),
    name: Value(json['name'] as String),
    code: Value(json['code'] as String),
  );
}

// ---------- SECTIONS ----------
SectionsCompanion sectionFromJson(Map<String, dynamic> json) {
  return SectionsCompanion(
    id: Value(json['id'] as String),
    departmentId: Value(json['department_id'] as String),
    departmentCode: Value(json['department_code'] as String),
    name: Value(json['name'] as String),
    code: Value(json['code'] as String),
  );
}

// ---------- WAREHOUSES ----------
WarehousesCompanion warehouseFromJson(Map<String, dynamic> json) {
  return WarehousesCompanion(
    id: Value(json['id'] as String),
    name: Value(json['name'] as String),
  );
}

// ---------- SECTION WAREHOUSES ----------
SectionWarehousesCompanion sectionWarehouseFromJson(Map<String, dynamic> json) {
  return SectionWarehousesCompanion(
    id: Value(json['id'] as String),
    sectionId: Value(json['section_id'] as String),
    warehouseId: Value(json['warehouse_id'] as String),
  );
}

// ---------- RACKS ----------
RacksCompanion rackFromJson(Map<String, dynamic> json) {
  return RacksCompanion(
    id: Value(json['id'] as String),
    name: Value(json['name'] as String),
    warehouseId: Value(json['warehouse_id'] as String),
  );
}

// ---------- PRODUCTS ----------
ProductsCompanion productFromJson(Map<String, dynamic> json) {
  return ProductsCompanion(
    id: Value(json['id'] as String),
    name: Value(json['name'] as String),
    categoryId: Value(toStr(json['category_id'])),
    machinePurchase: Value(toStr(json['machine_purchase'])),
    description: Value(toStr(json['description'])),
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
    defaultRackId: Value(toStr(json['default_rack_id'])),
    productId: Value(json['product_id'] as String),
    companyCode: Value(json['company_code'] as String),
    specification: Value(toStr(json['specification'])),
    notes: Value(toStr(json['notes'])),
    createdAt: Value(_parseDate(json['created_at']) ?? DateTime.now()),
    updatedAt: Value(_parseDate(json['updated_at']) ?? DateTime.now()),
    deletedAt: Value(_parseDate(json['deleted_at'])),
    lastModifiedAt: Value(
      _parseDate(json['last_modified_at']) ?? DateTime.now(),
    ),
    needSync: const Value(false),
  );
}

// ---------- VARIANTS ----------
VariantsCompanion variantFromJson(Map<String, dynamic> json) {
  return VariantsCompanion(
    id: Value(json['id'] as String),
    companyItemId: Value(json['company_item_id'] as String),
    rackId: Value(toStr(json['rack_id'])),
    brandId: Value(toStr(json['brand_id'])),
    name: Value(json['name'] as String),
    uom: Value(json['uom'] as String),
    specification: Value(toStr(json['specification'])),
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
    localPath: Value(toStr(json['local_path']) ?? ''), // optional
    remoteUrl: Value(toStr(json['file_path'])),
    sortOrder: Value(json['sort_order'] as int? ?? 0),
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
    brandId: Value(toStr(json['brand_id'])),
    manufCode: Value(toStr(json['manuf_code'])),
    specification: Value(toStr(json['spec_json'])),
    createdAt: Value(_parseDate(json['created_at']) ?? DateTime.now()),
    updatedAt: Value(_parseDate(json['updated_at']) ?? DateTime.now()),
    deletedAt: Value(_parseDate(json['deleted_at'])),
    lastModifiedAt: Value(
      _parseDate(json['last_modified_at']) ?? DateTime.now(),
    ),
    needSync: const Value(false),
  );
}

ComponentPhotosCompanion componentPhotoFromJson(Map<String, dynamic> json) {
  return ComponentPhotosCompanion(
    id: Value(json['id'] as String),
    componentId: Value(json['component_id'] as String),
    localPath: Value(toStr(json['local_path']) ?? ''), // optional
    remoteUrl: Value(toStr(json['file_path'])),
    sortOrder: Value(json['sort_order'] as int? ?? 0),
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
    quantityNeeded: Value(json['quantity_needed'] as int? ?? 1),
    createdAt: Value(_parseDate(json['created_at']) ?? DateTime.now()),
    updatedAt: Value(_parseDate(json['updated_at']) ?? DateTime.now()),
    lastModifiedAt: Value(
      _parseDate(json['last_modified_at']) ?? DateTime.now(),
    ),
    needSync: const Value(false),
  );
}

// ---------- UNITS ----------
UnitsCompanion unitFromJson(Map<String, dynamic> json) {
  return UnitsCompanion(
    id: Value(json['id'] as String),
    variantId: Value(toStr(json['variant_id'])),
    componentId: Value(toStr(json['component_id'])),
    parentUnitId: Value(toStr(json['parent_unit_id'])),
    qrValue: Value(json['qr_value'] as String),
    status: Value(json['status'] as String? ?? 'ACTIVE'),
    rackId: Value(toStr(json['rack_id'])),
    printCount: Value(json['print_count'] as int? ?? 0),
    lastPrintedAt: Value(_parseDate(json['last_printed_at'])),
    createdBy: Value(toStr(json['created_by'])),
    updatedBy: Value(toStr(json['updated_by'])),
    lastPrintedBy: Value(toStr(json['last_printed_by'])),
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
