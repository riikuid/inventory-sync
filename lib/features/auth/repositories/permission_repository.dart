// permission_repository.dart
import 'package:dio/dio.dart';
import 'package:inventory_sync_apps/core/dio_call.dart';
import '../../../../core/result.dart';
import '../../../core/permission_prefs.dart';
import '../models/permission_set.dart';

class PermissionRepository {
  // === CACHE API ===
  Future<PermissionSet?> readCache({String? userId}) =>
      PermissionPrefs.read(userId: userId);

  Future<void> persistCache(PermissionSet set, {String? userId}) =>
      PermissionPrefs.write(set, userId: userId);

  Future<void> clearCache({String? userId}) =>
      PermissionPrefs.clear(userId: userId);

  // === NETWORK ===
  Future<Result<PermissionSet>> fetch({
    int? ifNoneMatchVersion,
    String?
    userId, // hanya untuk persist setelah fetch sukses, kalau kamu mau langsung simpan di sini
  }) async {
    final result = await dioCall<PermissionSet>(
      (dio) => dio.get(
        '/me/permissions',
        options: Options(
          headers: {
            if (ifNoneMatchVersion != null)
              'If-None-Match': '"v$ifNoneMatchVersion"',
          },
        ),
      ),
      parse: (data) {
        final items = (data['items'] as List).cast<String>().toSet();
        final version = (data['version'] as int?) ?? _hash(items);
        return PermissionSet(items, version: version);
      },
    );

    // Optional: auto-persist kalau sukses
    if (result.isSuccess) {
      await persistCache(result.resultValue!, userId: userId);
    }
    return result;
  }

  int _hash(Set<String> items) {
    var h = 0;
    for (final s in items) {
      h = 0x1fffffff & (h + s.hashCode);
    }
    return h;
  }
}
