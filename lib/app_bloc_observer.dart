import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drift/native.dart'; // Pastikan import ini untuk SqliteException
import 'package:inventory_sync_apps/shared/presentation/screen/databse_critical_error_screen.dart';
import '../../core/routes/navigation_helper.dart'; // Helper dari Phase 1

class AppBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);

    // Deteksi Error SQLite Spesifik
    if (_isCriticalDatabaseError(error)) {
      print("🚨 CRITICAL DB ERROR DETECTED di ${bloc.runtimeType}");

      // Trigger Navigasi Darurat
      // Kita bungkus addPostFrameCallback agar aman dari collision saat build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateToEmergencyScreen(error.toString());
      });
    }
  }

  bool _isCriticalDatabaseError(Object error) {
    final e = error.toString().toLowerCase();

    // Cek apakah ini error SQLite
    bool isSqlite = error is SqliteException || e.contains('sqliteexception');

    if (!isSqlite) return false;

    // Cek keyword yang menandakan struktur DB beda dengan Code
    // 1. "no such column" -> Kolom hilang
    // 2. "has no column" -> Variasi pesan error
    // 3. "table ... has ... columns but ... values were supplied" -> Jumlah kolom beda
    return e.contains('no such column') ||
        e.contains('has no column') ||
        e.contains('values were supplied');
  }

  void _navigateToEmergencyScreen(String message) {
    // Menggunakan Helper Global Key dari Phase 1
    // Kita pakai pushAndRemoveUntil agar user tidak bisa 'Back' ke layar yang rusak
    final context = rootNavigatorKey.currentContext;
    if (context != null) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) =>
              DatabaseCriticalErrorScreen(errorMessage: message),
        ),
        (route) => false,
      );
    }
  }
}
