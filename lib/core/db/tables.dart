// lib/core/db/tables.dart
import 'package:drift/drift.dart';

class Uoms extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get purchasingId =>
      text().nullable()(); // ID UOM di backend purchasing

  @override
  Set<Column> get primaryKey => {id};
}

class Categories extends Table {
  TextColumn get id => text()(); // UUID string
  TextColumn get name => text()();
  TextColumn get code => text()();
  TextColumn get categoryParentId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Brands extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get name => text()();

  // ======== 👉 flag untuk sync =======
  DateTimeColumn get lastModifiedAt =>
      dateTime().withDefault(currentDateAndTime)();
  BoolColumn get needSync => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class Departments extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get name => text()();
  TextColumn get code => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class Sections extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get departmentId => text()();
  // TextColumn get departmentCode => text()();
  TextColumn get name => text()();
  TextColumn get code => text()();
  TextColumn get alias => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class Warehouses extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class SectionWarehouses extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get sectionId => text()();
  TextColumn get warehouseId => text()();

  @override
  Set<Column> get primaryKey => {sectionId, warehouseId};
}

class Racks extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get name => text()();
  TextColumn get warehouseId => text()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  // ======== 👉 flag untuk sync =======
  DateTimeColumn get lastModifiedAt =>
      dateTime().withDefault(currentDateAndTime)();
  BoolColumn get needSync => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class Products extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get name => text()();

  TextColumn get description => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  // ======== 👉 flag untuk sync =======
  DateTimeColumn get lastModifiedAt =>
      dateTime().withDefault(currentDateAndTime)();
  BoolColumn get needSync => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class CompanyItems extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get defaultRackId => text().nullable()();
  TextColumn get productId => text()(); // FK -> Products.id
  TextColumn get categoryId => text().nullable()();
  TextColumn get sectionId => text().nullable()();
  TextColumn get companyCode => text()();
  TextColumn get machinePurchase => text().nullable()();
  TextColumn get specification => text().nullable()();
  TextColumn get notes => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  // ======== 👉 flag untuk sync ========
  DateTimeColumn get lastModifiedAt =>
      dateTime().withDefault(currentDateAndTime)();
  BoolColumn get needSync => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get indexes => [
    {productId, defaultRackId}, // Index untuk JOIN
  ];
}

class Variants extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get companyItemId => text()(); // FK -> CompanyItems.id
  TextColumn get rackId => text().nullable()();
  TextColumn get brandId => text().nullable()(); // FK -> Brands.id
  TextColumn get name => text()(); // "Bearing 043 Timken"
  TextColumn get uom => text()();
  TextColumn get uomId => text()();
  TextColumn get manufCode => text().nullable()();
  TextColumn get specification => text().nullable()(); // JSON string

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  // ======== 👉 flag untuk sync ========
  DateTimeColumn get lastModifiedAt =>
      dateTime().withDefault(currentDateAndTime)();
  BoolColumn get needSync => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get indexes => [
    {companyItemId},
  ];
}

class VariantPhotos extends Table {
  TextColumn get id => text()(); // uuid (string)
  TextColumn get variantId => text()();

  // path lokal di device (misal path file di gallery / app dir)
  TextColumn get localPath => text().nullable()();

  // URL di server (nullable, diisi setelah upload sukses)
  TextColumn get remoteUrl => text().nullable()();

  // urutan foto (0,1,2,..)
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  // ======== 👉 flag untuk sync ========
  DateTimeColumn get lastModifiedAt =>
      dateTime().withDefault(currentDateAndTime)();
  BoolColumn get needSync => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

class Components extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get productId => text()(); // FK -> Products.id
  TextColumn get name => text()(); // "Cone 14276"
  IntColumn get type =>
      integer().withDefault(const Constant(1))(); // "1: IN_BOX", "2: SEPARATE"
  TextColumn get brandId => text().nullable()();
  TextColumn get manufCode => text().nullable()(); // "14276"
  TextColumn get specification => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  // ======== 👉 flag untuk sync ========
  DateTimeColumn get lastModifiedAt =>
      dateTime().withDefault(currentDateAndTime)(); // anchor versi lokal
  BoolColumn get needSync => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class ComponentPhotos extends Table {
  TextColumn get id => text()(); // uuid (string)
  TextColumn get componentId => text()();

  // path lokal di device (misal path file di gallery / app dir)
  TextColumn get localPath => text().nullable()();

  // URL di server (nullable, diisi setelah upload sukses)
  TextColumn get remoteUrl => text().nullable()();

  // urutan foto (0,1,2,..)
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  // ======== 👉 flag untuk sync ========
  DateTimeColumn get lastModifiedAt =>
      dateTime().withDefault(currentDateAndTime)();
  BoolColumn get needSync => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

class VariantComponents extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get variantId => text()(); // FK -> Variants.id
  TextColumn get componentId => text()(); // FK -> Components.id
  IntColumn get quantity => integer().withDefault(const Constant(1))();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  // 👉 flag untuk sync
  DateTimeColumn get lastModifiedAt =>
      dateTime().withDefault(currentDateAndTime)(); // anchor versi lokal
  BoolColumn get needSync => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class Units extends Table {
  TextColumn get id => text()(); // UUID lokal
  TextColumn get variantId => text().nullable()();
  TextColumn get componentId => text().nullable()();
  TextColumn get parentUnitId => text().nullable()();
  TextColumn get rackId => text().nullable()();
  TextColumn get poNumber => text().nullable()();

  IntColumn get quantity => integer().withDefault(const Constant(1))();

  IntColumn get price => integer().withDefault(const Constant(0))();
  TextColumn get uomId => text().nullable()();

  TextColumn get qrValue => text()(); // isi QR
  IntColumn get status => integer().withDefault(const Constant(0))();

  IntColumn get printCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastPrintedAt => dateTime().nullable()();
  TextColumn get lastPrintedBy => text().nullable()();

  TextColumn get createdBy => text().nullable()(); // user id (server)
  TextColumn get updatedBy => text().nullable()();

  DateTimeColumn get syncedAt => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  // flag sync lokal (bukan dari backend, cuma buat drift)
  DateTimeColumn get lastModifiedAt =>
      dateTime().withDefault(currentDateAndTime)(); // anchor versi lokal
  BoolColumn get needSync => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get indexes => [
    {variantId, status}, // Composite index untuk query cepat
  ];
}

/// Untuk simpan meta sync (misal last pull/push timestamp)
class SyncMetadata extends Table {
  TextColumn get key => text()(); // e.g. "last_pull_at", "last_push_at"
  TextColumn get value => text()(); // iso8601 string / json kecil

  @override
  Set<Column> get primaryKey => {key};
}
