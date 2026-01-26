import 'package:flutter/material.dart';
import 'package:inventory_sync_apps/core/styles/color_scheme.dart';

class ErrorScreen extends StatelessWidget {
  final String? title;
  final String? message;
  final VoidCallback onRetry;

  const ErrorScreen({
    super.key,
    this.title,
    this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Icon dalam kartu bulat, nuansanya sama kayak card kategori
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.wifi_off_rounded,
                      color: cs.primary,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    title ?? 'Tidak Bisa Terhubung',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 8),

                  Text(
                    // kalau message dari backend terlalu teknis, ini tetap aman
                    message ??
                        'Aplikasi belum bisa terhubung ke server.\n'
                            'Coba periksa koneksi internet, lalu tap tombol di bawah untuk mencoba lagi.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: cs.onBackground.withOpacity(0.75),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tombol utama
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cs.primary,
                        foregroundColor: cs.onPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: onRetry,
                      child: const Text(
                        'Coba Lagi',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Hint kecil di bawah tombol
                  Text(
                    'Jika masalah berlanjut, kamu tetap bisa membuka aplikasi setelah koneksi membaik.',
                    style: TextStyle(
                      fontSize: 12,
                      color: cs.onBackground.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
