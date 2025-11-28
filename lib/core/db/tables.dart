// lib/core/db/tables.dart
import 'package:drift/drift.dart';

class Categories extends Table {
  TextColumn get id => text()(); // UUID string
  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class Brands extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get name => text()();

  // 👉 flag untuk sync
  DateTimeColumn get lastModifiedAt => dateTime()(); // anchor versi lokal
  BoolColumn get needSync => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class Products extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get name => text()();
  TextColumn get categoryId => text()(); // FK -> Categories.id
  TextColumn get description => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  // 👉 flag untuk sync
  DateTimeColumn get lastModifiedAt => dateTime()(); // anchor versi lokal
  BoolColumn get needSync => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class CompanyItems extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get productId => text()(); // FK -> Products.id
  TextColumn get companyCode => text()(); // "043", "058", "0276"

  BoolColumn get isSet => boolean().nullable()(); // null = belum tau
  BoolColumn get hasComponents => boolean().nullable()(); // null = belum tau
  DateTimeColumn get initializedAt => dateTime().nullable()();
  TextColumn get initializedBy => text().nullable()(); // user id (string)
  TextColumn get notes => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()(); // soft delete

  // 👉 flag untuk sync
  DateTimeColumn get lastModifiedAt => dateTime()(); // anchor versi lokal
  BoolColumn get needSync => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class Variants extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get companyItemId => text()(); // FK -> CompanyItems.id
  TextColumn get brandId => text().nullable()(); // FK -> Brands.id
  TextColumn get name => text()(); // "Bearing 043 Timken"
  TextColumn get defaultLocation => text().nullable()();
  TextColumn get specJson => text().nullable()(); // JSON string

  DateTimeColumn get initializedAt => dateTime().nullable()();
  TextColumn get initializedBy => text().nullable()();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  // 👉 flag untuk sync
  DateTimeColumn get lastModifiedAt => dateTime()(); // anchor versi lokal
  BoolColumn get needSync => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class VariantPhotos extends Table {
  TextColumn get id => text()(); // uuid (string)
  TextColumn get variantId => text()();

  // path lokal di device (misal path file di gallery / app dir)
  TextColumn get localPath => text()();

  // URL di server (nullable, diisi setelah upload sukses)
  TextColumn get remoteUrl => text().nullable()();

  // urutan foto (0,1,2,..)
  IntColumn get position => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  // anchor sync
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
  TextColumn get brandId => text().nullable()();
  TextColumn get manufCode => text().nullable()(); // "14276"
  TextColumn get specJson => text().nullable()();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  // 👉 flag untuk sync
  DateTimeColumn get lastModifiedAt => dateTime()(); // anchor versi lokal
  BoolColumn get needSync => boolean().withDefault(const Constant(false))();

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

  // 👉 flag untuk sync
  DateTimeColumn get lastModifiedAt => dateTime()(); // anchor versi lokal
  BoolColumn get needSync => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class BufferStocks extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get companyItemId => text()(); // FK -> CompanyItems.id
  TextColumn get brandId => text().nullable()(); // nullable => semua brand
  TextColumn get location => text().nullable()();
  IntColumn get minQuantity => integer()(); // buffer min

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  // 👉 flag untuk sync
  BoolColumn get needSync => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class Units extends Table {
  TextColumn get id => text()(); // UUID lokal
  TextColumn get variantId => text().nullable()();
  TextColumn get componentId => text().nullable()();
  TextColumn get parentUnitId => text().nullable()();

  TextColumn get qrValue => text()(); // isi QR
  TextColumn get status => text().withDefault(const Constant('ACTIVE'))();
  TextColumn get location => text().nullable()();

  IntColumn get printCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastPrintedAt => dateTime().nullable()();

  TextColumn get createdBy => text().nullable()(); // user id (server)
  TextColumn get updatedBy => text().nullable()();
  TextColumn get lastPrintedBy => text().nullable()();

  DateTimeColumn get syncedAt => dateTime().nullable()();
  DateTimeColumn get lastModifiedAt => dateTime()(); // anchor versi lokal

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  // flag sync lokal (bukan dari backend, cuma buat drift)
  BoolColumn get needSync => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Untuk simpan meta sync (misal last pull/push timestamp)
class SyncMetadata extends Table {
  TextColumn get key => text()(); // e.g. "last_pull_at", "last_push_at"
  TextColumn get value => text()(); // iso8601 string / json kecil

  @override
  Set<Column> get primaryKey => {key};
}
