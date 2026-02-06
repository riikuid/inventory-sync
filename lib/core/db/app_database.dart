// lib/core/db/app_database.dart
import 'dart:developer' as dev;
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos/brand_dao.dart';
import 'daos/category_dao.dart';
import 'daos/company_item_dao.dart';
import 'daos/component_dao.dart';
import 'daos/component_photo_dao.dart';
import 'daos/product_dao.dart';
import 'daos/rack_dao.dart';
import 'daos/unit_dao.dart';
import 'daos/variant_component_dao.dart';
import 'daos/variant_dao.dart';
import 'daos/variant_photo_dao.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Uoms,
    Departments,
    Sections,
    Warehouses,
    SectionWarehouses,
    Racks,
    Categories,
    Brands,
    Products,
    CompanyItems,
    Variants,
    VariantPhotos,
    Components,
    ComponentPhotos,
    VariantComponents,
    Units,
    SyncMetadata,
  ],
  daos: [
    BrandDao,
    RackDao,
    CategoryDao,
    ProductDao,
    CompanyItemDao,
    VariantDao,
    VariantPhotoDao,
    ComponentDao,
    ComponentPhotoDao,
    VariantComponentDao,
    UnitDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  // Constructor default - UBAH JADI TANPA PARAMETER
  AppDatabase() : super(_openConnection());

  //  Constructor untuk isolate - TAMBAHKAN INI
  AppDatabase.forIsolate(String dbPath)
    : super(NativeDatabase.createInBackground(File(dbPath)));

  @override
  int get schemaVersion => 1;

  // ==================== PATH MANAGEMENT ====================

  // Cache path database
  static String? _databasePath;

  // Getter untuk mendapatkan path
  static String get databasePath {
    if (_databasePath == null) {
      throw StateError(
        'Database path not initialized. Call getDatabasePath() first.',
      );
    }
    return _databasePath!;
  }

  //  Method async untuk mendapatkan dan menyimpan path
  static Future<String> getDatabasePath() async {
    if (_databasePath != null) return _databasePath!;

    final dir = await getApplicationDocumentsDirectory();
    _databasePath = p.join(dir.path, 'inventory.db');

    dev.log('📁 Database path initialized: $_databasePath');

    return _databasePath!;
  }
}

// Fungsi _openConnection() tetap di luar (sesuai struktur asli)
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'inventory.db'));

    dev.log('DEBUG: inventory DB path -> ${file.path}');

    // Simpan path ke static variable saat pertama kali dibuka
    AppDatabase._databasePath = file.path;

    return NativeDatabase.createInBackground(file);
  });
}
