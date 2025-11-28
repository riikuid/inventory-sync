import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constant.dart';

class Token {
  static Future<String?> getSanctumToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenPref);
  }

  static Future<bool> setSanctumToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(tokenPref, token);
  }

  static Future<bool> removeSanctumToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(tokenPref);
  }

  static Future<String?> getDeviceToken() async {
    FirebaseMessaging.instance.isAutoInitEnabled;
    String? deviceToken = await FirebaseMessaging.instance.getToken();
    return deviceToken;
  }

  static Future removeDeviceToken() async {
    await FirebaseMessaging.instance.deleteToken();
  }
}
