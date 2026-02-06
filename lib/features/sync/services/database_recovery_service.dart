import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart'; // Jangan lupa import ini untuk akses method customSelect
import 'package:inventory_sync_apps/core/token.dart';
import 'package:inventory_sync_apps/core/user_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:restart_app/restart_app.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/db/app_database.dart';

class DatabaseRecoveryService {
  final AppDatabase _db;

  DatabaseRecoveryService(this._db);

  /// Helper untuk query raw dengan safety
  /// Mengembalikan List<Map<String, dynamic>>
  Future<List<Map<String, dynamic>>> _getRawPending(
    String tableName, {
    String? extraWhere,
  }) async {
    try {
      // SQLite menyimpan boolean true sebagai 1
      String query = 'SELECT * FROM $tableName WHERE need_sync = 1';
      if (extraWhere != null) {
        query += ' AND $extraWhere';
      }

      final result = await _db.customSelect(query).get();
      return result.map((row) => row.data).toList();
    } catch (e) {
      print("⚠️ Gagal membaca tabel $tableName: $e");
      return [];
    }
  }

  Future<String?> generateRescuePayload() async {
    try {
      // 1. Ambil Raw Data (Bypass Drift DAO untuk menghindari crash schema mismatch)

      // Racks
      final rawRacks = await _getRawPending('racks');

      // Products
      final rawProducts = await _getRawPending('products');

      // Company Items
      final rawCompanyItems = await _getRawPending('company_items');

      // Variants
      final rawVariants = await _getRawPending('variants');

      // Components
      final rawComponents = await _getRawPending('components');

      // Variant Components
      final rawVariantComponents = await _getRawPending('variant_components');

      // Units (Logic: need_sync=1 AND status NOT IN (-2, -1, 0))
      final rawUnits = await _getRawPending(
        'units',
        extraWhere: 'status NOT IN (-2, -1, 0)',
      );

      // Photos (Logic: need_sync=1)
      final rawVariantPhotos = await _getRawPending('variant_photos');
      final rawComponentPhotos = await _getRawPending('component_photos');

      // Cek apakah ada data sama sekali
      bool hasData =
          rawRacks.isNotEmpty ||
          rawProducts.isNotEmpty ||
          rawCompanyItems.isNotEmpty ||
          rawVariants.isNotEmpty ||
          rawComponents.isNotEmpty ||
          rawVariantComponents.isNotEmpty ||
          rawUnits.isNotEmpty ||
          rawVariantPhotos.isNotEmpty ||
          rawComponentPhotos.isNotEmpty;

      if (!hasData) return null;

      // 2. Mapping Manual ke JSON

      final payload = {
        'meta': {
          'user_id': (await UserStorage.getUser())?.id,
          'exported_at': DateTime.now().toIso8601String(),
          'note': 'RESCUE DATA - SCHEMA MISMATCH RECOVERY',
        },
        // Struktur ini SAMA PERSIS dengan payload api.push() di SyncRepository
        'racks': rawRacks
            .map(
              (d) => {
                'id': d['id'],
                'name': d['name'],
                'warehouse_id': d['warehouse_id'],
                'created_at': d['created_at'],
                'updated_at': d['updated_at'],
                'deleted_at': d['deleted_at'],
              },
            )
            .toList(),

        'products': rawProducts
            .map(
              (d) => {
                'id': d['id'],
                'name': d['name'],
                'description': d['description'],
                'created_at': d['created_at'],
                'updated_at': d['updated_at'],
              },
            )
            .toList(),

        'company_items': rawCompanyItems
            .map(
              (d) => {
                'id': d['id'],
                'default_rack_id': d['default_rack_id'],
                'product_id': d['product_id'],
                'section_id':
                    d['section_id'], // Ini yg mungkin bikin crash kalau hilang, tapi di raw map dia null/undefined, aman.
                'category_id': d['category_id'],
                'company_code': d['company_code'],
                'machine_purchase': d['machine_purchase'],
                'specification': d['specification'],
                'notes': d['notes'],
                'created_at': d['created_at'],
                'updated_at': d['updated_at'],
                'deleted_at': d['deleted_at'],
              },
            )
            .toList(),

        'variants': rawVariants
            .map(
              (d) => {
                'id': d['id'],
                'company_item_id': d['company_item_id'],
                'rack_id': d['rack_id'],
                'brand_id': d['brand_id'],
                'name': d['name'],
                'uom': d['uom'],
                'uom_id': d['uom_id'],
                'manuf_code': d['manuf_code'],
                'specification': d['specification'],
                'created_at': d['created_at'],
                'updated_at': d['updated_at'],
                'deleted_at': d['deleted_at'],
              },
            )
            .toList(),

        'components': rawComponents
            .map(
              (d) => {
                'id': d['id'],
                'product_id': d['product_id'],
                'name': d['name'],
                'type': d['type'],
                'brand_id': d['brand_id'],
                'manuf_code': d['manuf_code'],
                'specification': d['specification'],
                'created_at': d['created_at'],
                'updated_at': d['updated_at'],
                'deleted_at': d['deleted_at'],
              },
            )
            .toList(),

        'variant_components': rawVariantComponents
            .map(
              (d) => {
                'id': d['id'],
                'variant_id': d['variant_id'],
                'component_id': d['component_id'],
                'quantity': d['quantity'],
                'created_at': d['created_at'],
                'updated_at': d['updated_at'],
                'deleted_at': d['deleted_at'],
              },
            )
            .toList(),

        'units': rawUnits
            .map(
              (d) => {
                'id': d['id'],
                'variant_id': d['variant_id'],
                'component_id': d['component_id'],
                'parent_unit_id': d['parent_unit_id'],
                'quantity': d['quantity'],
                'uom_id': d['uom_id'],
                'price': d['price'],
                'po_number': d['po_number'],
                'qr_value': d['qr_value'],
                'status': d['status'],
                'rack_id': d['rack_id'],
                'print_count': d['print_count'],
                'last_printed_at': d['last_printed_at'],
                'last_printed_by': d['last_printed_by'],
                'created_by': d['created_by'],
                'updated_by': d['updated_by'],
                'synced_at': d['synced_at'],
                'created_at': d['created_at'],
                'updated_at': d['updated_at'],
                'deleted_at': d['deleted_at'],
              },
            )
            .toList(),

        // Untuk Foto: Karena rescue, kita tidak punya remoteUrl.
        // Kita isi file_path dengan local_path agar user bisa manual retrieve filenya
        'variant_photos': rawVariantPhotos
            .map(
              (d) => {
                'id': d['id'],
                'variant_id': d['variant_id'],
                'file_path': d['local_path'], // MENGGUNAKAN LOCAL PATH
                'is_local_rescue': true, // Flag penanda
                'sort_order': d['sort_order'],
                'created_at': d['created_at'],
                'updated_at': d['updated_at'],
                'deleted_at': d['deleted_at'],
              },
            )
            .toList(),

        'component_photos': rawComponentPhotos
            .map(
              (d) => {
                'id': d['id'],
                'component_id': d['component_id'],
                'file_path': d['local_path'], // MENGGUNAKAN LOCAL PATH
                'is_local_rescue': true,
                'sort_order': d['sort_order'],
                'created_at': d['created_at'],
                'updated_at': d['updated_at'],
                'deleted_at': d['deleted_at'],
              },
            )
            .toList(),
      };

      return const JsonEncoder.withIndent('  ').convert(payload);
    } catch (e, stack) {
      print("CRITICAL: Gagal generate rescue payload: $e $stack");
      return null;
    }
  }

  Future<void> shareRescueFile(String jsonPayload) async {
    try {
      final directory = await getTemporaryDirectory();
      final fileName =
          'mp_inventory_rescue_${DateTime.now().millisecondsSinceEpoch}.json';
      final file = File('${directory.path}/$fileName');

      await file.writeAsString(jsonPayload);

      await Share.shareXFiles(
        [XFile(file.path)],
        text:
            '⚠️ EMERGENCY DATA BACKUP (Sync Pending)\n\n'
            'File ini berisi data yang belum terkirim ke server (need_sync=1).\n'
            'Mohon serahkan ke tim IT.',
        subject: 'MP Inventory Rescue Data',
      );
    } catch (e) {
      print("Gagal share: $e");
    }
  }

  Future<void> nukeDatabase() async {
    try {
      await _db.close();
    } catch (_) {}

    try {
      final dbFolder = await getApplicationDocumentsDirectory();
      // Pastikan nama file ini sesuai dengan yang ada di AppDatabase (biasanya inventory.db atau app_database.db)
      final file = File(p.join(dbFolder.path, 'inventory.db'));

      if (await file.exists()) {
        await file.delete();
      }

      // Hapus metadata sync agar pull ulang dari awal
      // await UserStorage.clearUser();
      // await Token.removeSanctumToken();

      await Restart.restartApp();
    } catch (e) {
      print("Gagal wipe database: $e");
      rethrow;
    }
  }
}
