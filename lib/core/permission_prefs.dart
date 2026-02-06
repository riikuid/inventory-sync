// permission_prefs.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/auth/models/permission_set.dart';

class PermissionPrefs {
  static const _kVersion = 1;

  // Key dasar; kalau multi-user, tambahkan suffix ":<userId>"
  static String _key({String? userId}) =>
      'permission_cache_v$_kVersion${userId != null ? ':$userId' : ''}';

  /// Simpan PermissionSet sebagai JSON string
  static Future<bool> write(PermissionSet set, {String? userId}) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(set.toJson());
    return prefs.setString(_key(userId: userId), jsonStr);
  }

  /// Baca PermissionSet; null kalau belum ada / rusak
  static Future<PermissionSet?> read({String? userId}) async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_key(userId: userId));
    if (str == null) return null;
    try {
      final map = jsonDecode(str) as Map<String, dynamic>;
      return PermissionSet.fromJson(map);
    } catch (_) {
      // data korup—hapus supaya tidak mengganggu
      await prefs.remove(_key(userId: userId));
      return null;
    }
  }

  static Future<bool> clear({String? userId}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(_key(userId: userId));
  }
}
