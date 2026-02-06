import 'package:flutter/material.dart';
import 'package:inventory_sync_apps/app_root.dart';

// 1. Definisikan Global Key secara static atau top-level
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

// 2. Helper function untuk memudahkan pemanggilan (Opsional tapi rapi)
class NavigationHelper {
  // Fungsi untuk memaksa pindah halaman tanpa Context
  static Future<void> pushReplacementToErrorScreen(Widget errorScreen) async {
    // Kita gunakan pushAndRemoveUntil agar user tidak bisa back ke halaman yang error
    await rootNavigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => errorScreen),
      (route) => false, // Hapus semua history route sebelumnya
    );
  }

  static Future<void> pushToSplash() async {
    // Sesuaikan dengan halaman awal Anda
    rootNavigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => AppRoot()),
      (route) => false,
    );
  }
}
