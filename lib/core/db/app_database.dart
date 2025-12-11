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
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'inventory.db'));
    print('DEBUG: inventory DB path -> ${file.path}');
    dev.log('DEBUG: inventory DB path -> ${file.path}');
    return NativeDatabase.createInBackground(file);
  });
}

// optional tapi enak: re-export supaya di-import dari sini pun keliatan tables-nya
// export 'tables.dart';
