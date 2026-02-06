import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_sync_apps/app_root.dart';
import 'package:inventory_sync_apps/core/styles/color_scheme.dart';
import 'package:provider/provider.dart'; // Atau flutter_bloc read
import '../../../core/db/app_database.dart';
import '../../../features/sync/services/database_recovery_service.dart';
import '../../../start_up_screen.dart'; // Halaman awal aplikasi Anda

class DatabaseCriticalErrorScreen extends StatefulWidget {
  final String errorMessage;

  const DatabaseCriticalErrorScreen({Key? key, required this.errorMessage})
    : super(key: key);

  @override
  State<DatabaseCriticalErrorScreen> createState() =>
      _DatabaseCriticalErrorScreenState();
}

class _DatabaseCriticalErrorScreenState
    extends State<DatabaseCriticalErrorScreen> {
  late DatabaseRecoveryService _recoveryService;

  bool _isLoading = true;
  String? _rescueJson;
  bool _resetting = false;

  @override
  void initState() {
    super.initState();
    // Inisialisasi Service.
    // Kita ambil AppDatabase dari Provider/GetIt.
    // Asumsi: AppDatabase di-provide di main.dart
    final db = context.read<AppDatabase>();
    _recoveryService = DatabaseRecoveryService(db);

    _checkRescueData();
  }

  Future<void> _checkRescueData() async {
    // Cek apakah ada data yang perlu diselamatkan
    final json = await _recoveryService.generateRescuePayload();
    if (mounted) {
      setState(() {
        _rescueJson = json;
        _isLoading = false;
      });
    }
  }

  Future<void> _onSharePressed() async {
    if (_rescueJson != null) {
      await _recoveryService.shareRescueFile(_rescueJson!);
    }
  }

  Future<void> _onHardResetPressed() async {
    // Konfirmasi Terakhir
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('⚠️ Hapus Semua Data?'),
        content: const Text(
          'Database lokal akan dihapus total dan aplikasi akan dimulai ulang.\n\n'
          'Pastikan Anda SUDAH melakukan Share/Backup jika ada tombol backup berwarna oranye.',
        ),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(ctx, false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              'YA, HAPUS & RESET',
              style: TextStyle(color: AppColors.surface),
            ),
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _resetting = true);

      // Lakukan Reset
      await _recoveryService.nukeDatabase();

      // Beri sedikit delay visual
      await Future.delayed(const Duration(seconds: 1));

      // if (mounted) {
      //   // Restart Aplikasi ke Halaman Awal (Splash / StartUp)
      //   Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (_) => const AppRoot()),
      //     (route) => false,
      //   );
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon Error
              const Icon(Icons.dns_rounded, size: 80, color: Colors.red),
              const SizedBox(height: 16),

              const Text(
                "Database Mismatch",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Text(
                "Terjadi perubahan struktur data dari server. Database lokal perlu di-reset agar sinkron kembali.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], height: 1.5),
              ),

              const SizedBox(height: 32),

              // --- AREA BACKUP / RESCUE ---
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_rescueJson != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    border: Border.all(color: Colors.orange),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "DATA BELUM TERKIRIM!",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                                Text(
                                  "Ada data offline (need_sync) yang tersimpan.",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.orange[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.share, color: Colors.white),
                          label: const Text("BACKUP / SHARE DATA SEKARANG"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            elevation: 0,
                          ),
                          onPressed: _onSharePressed,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Data aman (tidak ada pending sync).",
                        style: TextStyle(
                          color: Colors.green[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

              // -----------------------------
              const Spacer(),

              // Error Detail (Hidden/Small)
              ExpansionTile(
                title: const Text(
                  "Lihat Detail Error Teknis",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.grey[100],
                    height: 100,
                    child: SingleChildScrollView(
                      child: Text(
                        widget.errorMessage,
                        style: const TextStyle(
                          fontSize: 10,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Tombol Reset
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _resetting ? null : _onHardResetPressed,
                  child: _resetting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "HAPUS DATABASE & RESTART",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
