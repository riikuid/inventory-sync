// core/user_storage.dart
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:inventory_sync_apps/features/auth/models/user.dart';

class UserStorage {
  static const _userKey = 'user_json';

  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_userKey);
    if (jsonString == null) return null;

    final map = jsonDecode(jsonString) as Map<String, dynamic>;
    return User.fromJson(map);
  }

  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
