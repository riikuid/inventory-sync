import 'package:flutter/material.dart';

class StartupScreen extends StatelessWidget {
  final String message;
  final double? progress; // Terima progress

  const StartupScreen({
    required this.message,
    this.progress, // Bisa null
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo atau Gambar bisa ditaruh di sini
              const SizedBox(height: 20),

              if (progress != null && progress! > 0) ...[
                // Tampilkan Progress Bar Determinate (Ada isinya)
                LinearProgressIndicator(value: progress),
                const SizedBox(height: 8),
                Text(
                  "${(progress! * 100).toInt()}%",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ] else ...[
                // Loading Indeterminate (Muter terus)
                const CircularProgressIndicator(),
              ],

              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
