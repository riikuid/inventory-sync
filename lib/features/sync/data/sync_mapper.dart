// lib/features/sync/data/sync_mapper.dart
import 'package:drift/drift.dart' hide Component;
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

// ---------- UOMS ----------
UomsCompanion uomFromJson(Map<String, dynamic> json) {
  return UomsCompanion(
    id: Value(json['id'] as String),
    name: Value(json['name'] as String),
    purchasingId: Value(toStr(json['purchasing_id'])),
  );
}

// ---------- CATEGORIES ----------
CategoriesCompanion categoryFromJson(Map<String, dynamic> json) {
  return CategoriesCompanion(
    id: Value(json['id'] as String),
    name: Value(json['name'] as String),
    code: Value(json['code'] as String),
    categoryParentId: Value(toStr(json['category_parent_id'])),
  );
}

// ---------- BRANDS ----------
BrandsCompanion brandFromJson(Map<String, dynamic> json) {
  return BrandsCompanion(
    id: Value(json['id'] as String),
    name: Value(json['name'] as String),
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
    name: Value(json['name'] as String),
    code: Value(json['code'] as String),
    alias: Value(json['alias'] as String),
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
    createdAt: Value(_parseDate(json['created_at']) ?? DateTime.now()),
    updatedAt: Value(_parseDate(json['updated_at']) ?? DateTime.now()),
    deletedAt: Value(_parseDate(json['deleted_at'])),
  );
}

// ---------- PRODUCTS ----------
ProductsCompanion productFromJson(Map<String, dynamic> json) {
  return ProductsCompanion(
    id: Value(json['id'] as String),
    name: Value(json['name'] as String),

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
    sectionId: Value(toStr(json['section_id'])),
    categoryId: Value(toStr(json['category_id'])),
    companyCode: Value(json['company_code'] as String),
    machinePurchase: Value(toStr(json['machine_purchase'])),
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
    uomId: Value(json['uom_id'] as String),
    specification: Value(toStr(json['specification'])),
    manufCode: Value(toStr(json['manuf_code'])),
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
    type: Value(json['type'] as int),
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
    quantity: Value(json['quantity'] as int? ?? 1),
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
    quantity: Value(json['quantity'] as int? ?? 1),
    uomId: Value(toStr(json['uom_id'])),
    price: Value(json['price'] as int? ?? 0),
    poNumber: Value(toStr(json['poNumber'])),
    qrValue: Value(json['qr_value'] as String),
    status: Value(json['status'] as int? ?? 0),
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

// --- EXTENSIONS UNTUK PUSH (Drift Row -> JSON) ---

extension RackSyncX on Rack {
  Map<String, dynamic> toSyncJson() => {
    'id': id,
    'name': name,
    'warehouse_id': warehouseId,

    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'deleted_at': deletedAt?.toIso8601String(),
    // Backend handle last_modified_at server side, jadi opsional
  };
}

extension ProductSyncX on Product {
  Map<String, dynamic> toSyncJson() => {
    'id': id,
    'name': name,

    'description': description,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    // Backend handle last_modified_at server side, jadi opsional
  };
}

extension CompanyItemSyncX on CompanyItem {
  Map<String, dynamic> toSyncJson() => {
    'id': id,
    'default_rack_id': defaultRackId,
    'product_id': productId,
    'section_id': sectionId,
    'category_id': categoryId,
    'company_code': companyCode,
    'machine_purchase': machinePurchase,
    'specification': specification,
    'notes': notes,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'deleted_at': deletedAt?.toIso8601String(),
  };
}

extension VariantSyncX on Variant {
  Map<String, dynamic> toSyncJson() => {
    'id': id,
    'company_item_id': companyItemId,
    'rack_id': rackId,
    'brand_id': brandId,
    'name': name,
    'uom': uom,
    'uom_id': uomId,
    'manuf_code': manufCode,
    'specification': specification,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'deleted_at': deletedAt?.toIso8601String(),
  };
}

extension ComponentSyncX on Component {
  Map<String, dynamic> toSyncJson() => {
    'id': id,
    'product_id': productId,
    'name': name,
    'type': type,
    'brand_id': brandId,
    'manuf_code': manufCode,
    'specification': specification,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'deleted_at': deletedAt?.toIso8601String(),
  };
}

extension VariantComponentSyncX on VariantComponent {
  Map<String, dynamic> toSyncJson() => {
    'id': id,
    'variant_id': variantId,
    'component_id': componentId,
    'quantity': quantity,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'deleted_at': deletedAt?.toIso8601String(),
  };
}

extension UnitSyncX on Unit {
  Map<String, dynamic> toSyncJson() => {
    'id': id,
    'variant_id': variantId,
    'component_id': componentId,
    'parent_unit_id': parentUnitId,
    'quantity': quantity,
    'uom_id': uomId,
    'price': price,
    'po_number': poNumber,
    'qr_value': qrValue,
    'status': status,
    'rack_id': rackId,
    'print_count': printCount,
    'last_printed_at': lastPrintedAt?.toIso8601String(),
    'last_printed_by': lastPrintedBy,
    'created_by': createdBy,
    'updated_by': updatedBy,
    'synced_at': syncedAt?.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'deleted_at': deletedAt?.toIso8601String(),
  };
}

// Helper khusus untuk Photo karena butuh remoteUrl hasil upload
Map<String, dynamic> variantPhotoToSyncJson(VariantPhoto p, String remoteUrl) =>
    {
      'id': p.id,
      'variant_id': p.variantId,
      'file_path': remoteUrl,
      'sort_order': p.sortOrder,
      'created_at': p.createdAt.toIso8601String(),
      'updated_at': p.updatedAt.toIso8601String(),
      'deleted_at': p.deletedAt?.toIso8601String(),
    };

Map<String, dynamic> componentPhotoToSyncJson(
  ComponentPhoto p,
  String remoteUrl,
) => {
  'id': p.id,
  'component_id': p.componentId,
  'file_path': remoteUrl,
  'sort_order': p.sortOrder,
  'created_at': p.createdAt.toIso8601String(),
  'updated_at': p.updatedAt.toIso8601String(),
  'deleted_at': p.deletedAt?.toIso8601String(),
};
