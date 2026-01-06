// lib/core/db/tables.dart
import 'package:drift/drift.dart';

class Categories extends Table {
  TextColumn get uuid => text()(); // UUID string

  // 👉 TAMBAHAN: Simpan ID Incremental dari Server
  IntColumn get remoteId => integer().nullable().customConstraint('UNIQUE')();

  TextColumn get name => text()();
  TextColumn get code => text()();
  TextColumn get categoryParentUuid => text().nullable()();

  @override
  Set<Column> get primaryKey => {uuid};
}

class Brands extends Table {
  TextColumn get uuid => text()(); // UUID

  // 👉 TAMBAHAN: Simpan ID Incremental dari Server
  IntColumn get remoteId => integer().nullable().customConstraint('UNIQUE')();

  TextColumn get name => text()();

  // ======== 👉 flag untuk sync =======
  DateTimeColumn get lastModifiedAt =>
      dateTime().withDefault(currentDateAndTime)();
  BoolColumn get needSync => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {uuid};
}

class Departments extends Table {
  TextColumn get uuid => text()(); // UUID

  // 👉 TAMBAHAN: Simpan ID Incremental dari Server
  IntColumn get remoteId => integer().nullable().customConstraint('UNIQUE')();

  TextColumn get name => text()();
  TextColumn get code => text()();

  @override
  Set<Column> get primaryKey => {uuid};
}

class Sections extends Table {
  TextColumn get uuid => text()(); // UUID

  // 👉 TAMBAHAN: Simpan ID Incremental dari Server
  IntColumn get remoteId => integer().nullable().customConstraint('UNIQUE')();

  TextColumn get departmentUuid => text()();
  TextColumn get departmentCode => text()();
  TextColumn get name => text()();
  TextColumn get code => text()();

  @override
  Set<Column> get primaryKey => {uuid};
}

class Warehouses extends Table {
  TextColumn get uuid => text()(); // UUID
  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {uuid};
}

class SectionWarehouses extends Table {
  // TextColumn get sectionId => text().references(Sections, #id)();
  // TextColumn get warehouseId => text().references(Warehouses, #id)();
  TextColumn get uuid => text()(); // UUID
  TextColumn get sectionUuid => text()();
  TextColumn get warehouseUuid => text()();

  @override
  Set<Column> get primaryKey => {uuid};
}

class Racks extends Table {
  TextColumn get uuid => text()(); // UUID -> LOKAL ID

  // 👉 TAMBAHAN: Simpan ID Incremental dari Server
  IntColumn get remoteId => integer().nullable().customConstraint('UNIQUE')();

  TextColumn get name => text()();
  TextColumn get warehouseUuid => text()();

  @override
  Set<Column> get primaryKey => {uuid};
}

class Products extends Table {
  TextColumn get uuid => text()(); // UUID

  // 👉 TAMBAHAN: Simpan ID Incremental dari Server
  IntColumn get remoteId => integer().nullable().customConstraint('UNIQUE')();

  TextColumn get name => text()();
  TextColumn get categoryUuid => text().nullable()();
  TextColumn get description => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  // ======== 👉 flag untuk sync =======
  DateTimeColumn get lastModifiedAt =>
      dateTime().withDefault(currentDateAndTime)();
  BoolColumn get needSync => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {uuid};
}

class CompanyItems extends Table {
  TextColumn get uuid => text()(); // UUID

  // 👉 TAMBAHAN: Simpan ID Incremental dari Server
  IntColumn get remoteId => integer().nullable().customConstraint('UNIQUE')();

  TextColumn get defaultRackUuid => text().nullable()();
  TextColumn get productUuid => text()(); // FK -> Products.uuid
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
  Set<Column> get primaryKey => {uuid};
}

class Variants extends Table {
  TextColumn get uuid => text()(); // UUID

  // 👉 TAMBAHAN: Simpan ID Incremental dari Server
  IntColumn get remoteId => integer().nullable().customConstraint('UNIQUE')();

  TextColumn get companyItemUuid => text()(); // FK -> CompanyItems.uuid
  TextColumn get rackUuid => text().nullable()();
  TextColumn get brandUuid => text().nullable()(); // FK -> Brands.uuid

  TextColumn get name => text()(); // "Bearing 043 Timken"
  TextColumn get uom => text()();
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
  Set<Column> get primaryKey => {uuid};
}

class VariantPhotos extends Table {
  TextColumn get uuid => text()(); // uuid (string)

  // 👉 TAMBAHAN: Simpan ID Incremental dari Server
  IntColumn get remoteId => integer().nullable().customConstraint('UNIQUE')();

  TextColumn get variantUuid => text()();

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
  Set<Column> get primaryKey => {uuid};
}

class Components extends Table {
  TextColumn get uuid => text()(); // UUID

  // 👉 TAMBAHAN: Simpan ID Incremental dari Server
  IntColumn get remoteId => integer().nullable().customConstraint('UNIQUE')();

  TextColumn get productUuid => text()(); // FK -> Products.uuid
  TextColumn get brandUuid => text().nullable()();

  TextColumn get name => text()(); // "Cone 14276"
  TextColumn get type => text()(); // "IN_BOX", "SEPARATE"
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
  Set<Column> get primaryKey => {uuid};
}

class ComponentPhotos extends Table {
  TextColumn get uuid => text()(); // uuid (string)

  // 👉 TAMBAHAN: Simpan ID Incremental dari Server
  IntColumn get remoteId => integer().nullable().customConstraint('UNIQUE')();

  TextColumn get componentUuid => text()();

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
  Set<Column> get primaryKey => {uuid};
}

class VariantComponents extends Table {
  TextColumn get uuid => text()(); // UUID

  // 👉 TAMBAHAN: Simpan ID Incremental dari Server
  IntColumn get remoteId => integer().nullable().customConstraint('UNIQUE')();

  TextColumn get variantUuid => text()(); // FK -> Variants.uuid
  TextColumn get componentUuid => text()(); // FK -> Components.uuid
  IntColumn get quantityNeeded => integer().withDefault(const Constant(1))();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  // 👉 flag untuk sync
  DateTimeColumn get lastModifiedAt =>
      dateTime().withDefault(currentDateAndTime)(); // anchor versi lokal
  BoolColumn get needSync => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {uuid};
}

class Units extends Table {
  TextColumn get uuid => text()(); // UUID lokal

  // 👉 TAMBAHAN: Simpan ID Incremental dari Server
  IntColumn get remoteId => integer().nullable().customConstraint('UNIQUE')();

  TextColumn get variantUuid => text().nullable()();
  TextColumn get componentUuid => text().nullable()();
  TextColumn get parentUnitUuid => text().nullable()();
  TextColumn get rackUuid => text().nullable()();

  TextColumn get qrValue => text()(); // isi QR
  TextColumn get status => text().withDefault(const Constant('ACTIVE'))();

  IntColumn get printCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastPrintedAt => dateTime().nullable()();
  TextColumn get lastPrintedBy => text().nullable()();

  TextColumn get createdBy => text().nullable()(); // user uuid (server)
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
  Set<Column> get primaryKey => {uuid};
}

/// Untuk simpan meta sync (misal last pull/push timestamp)
class SyncMetadata extends Table {
  TextColumn get key => text()(); // e.g. "last_pull_at", "last_push_at"
  TextColumn get value => text()(); // iso8601 string / json kecil

  @override
  Set<Column> get primaryKey => {key};
}
