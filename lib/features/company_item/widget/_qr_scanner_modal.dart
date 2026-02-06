// lib/features/home/presentation/widgets/qr_scanner_modal.dart

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_sync_apps/core/utils/qr_camera_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/styles/color_scheme.dart';

class QrScannerModal extends StatefulWidget {
  final Function(String qrValue) onScanSuccess;
  final String? title;
  final String? subtitle;

  const QrScannerModal({
    super.key,
    required this.onScanSuccess,
    this.title,
    this.subtitle,
  });

  @override
  State<QrScannerModal> createState() => _QrScannerModalState();
}

class _QrScannerModalState extends State<QrScannerModal> {
  bool _isCameraReady = false;
  bool _hasError = false;
  String _errorMessage = '';
  late QrCameraController qrController;

  bool isProcessing = false;
  String? scannedCode;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    qrController = QrCameraController();
    _initCamera();
  }

  @override
  void dispose() {
    qrController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  Future<void> _initCamera() async {
    try {
      // Cek permission kamera terlebih dahulu
      final cameraStatus = await Permission.camera.request();
      if (!cameraStatus.isGranted) {
        setState(() {
          _hasError = true;
          _errorMessage =
              'Izin kamera ditolak. Silakan aktifkan izin kamera di pengaturan.';
        });
        return;
      }

      // Inisialisasi controller
      await qrController.initialize();

      if (!mounted) return;

      // Mulai image stream untuk scanning
      final cameraCtrl = qrController.cameraController;
      if (cameraCtrl != null && cameraCtrl.value.isInitialized) {
        await cameraCtrl.startImageStream((image) async {
          if (isProcessing) return; // Hindari multiple scan

          final result = await qrController.process(image);
          if (result != null && mounted && !isProcessing) {
            _onQrDetected(result);
          }
        });
      }

      setState(() {
        _isCameraReady = true;
      });
    } catch (e) {
      debugPrint('❌ Error inisialisasi kamera: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Gagal mengakses kamera: ${e.toString()}';
        });
      }
    }
  }

  void _onQrDetected(String code) async {
    if (isProcessing) return;

    setState(() {
      isProcessing = true;
      scannedCode = code;
    });

    // Feedback visual
    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted) {
      // Callback ke parent
      widget.onScanSuccess(code);
    }
  }

  void _retryInitialization() {
    setState(() {
      _hasError = false;
      _errorMessage = '';
      _isCameraReady = false;
    });
    qrController.dispose();
    qrController = QrCameraController();
    _initCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.qr_code_scanner, color: AppColors.primary, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title ?? 'Scan QR Code',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                      Text(
                        widget.subtitle ?? 'Arahkan kamera ke QR code',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: AppColors.onSurface),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Camera View
          Expanded(
            child: Stack(
              children: [
                // Camera atau Error State
                if (_hasError)
                  _buildErrorWidget()
                else if (_isCameraReady &&
                    qrController.cameraController != null)
                  CameraPreview(qrController.cameraController!)
                else
                  const Center(child: CircularProgressIndicator()),

                // Overlay hanya muncul jika kamera ready dan tidak error
                if (_isCameraReady && !_hasError) ...[
                  Center(
                    child: Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isProcessing ? Colors.green : Colors.white,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: (isProcessing ? Colors.green : Colors.white)
                                .withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: isProcessing
                          ? Center(
                              child: CircularProgressIndicator(
                                color: AppColors.surface,
                              ),
                            )
                          : null,
                    ),
                  ),

                  // Corner indicators
                  if (!isProcessing)
                    Center(
                      child: SizedBox(
                        width: 280,
                        height: 280,
                        child: Stack(
                          children: [
                            // Top Left
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: AppColors.primary,
                                      width: 4,
                                    ),
                                    left: BorderSide(
                                      color: AppColors.primary,
                                      width: 4,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Top Right
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: AppColors.primary,
                                      width: 4,
                                    ),
                                    right: BorderSide(
                                      color: AppColors.primary,
                                      width: 4,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Bottom Left
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: AppColors.primary,
                                      width: 4,
                                    ),
                                    left: BorderSide(
                                      color: AppColors.primary,
                                      width: 4,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Bottom Right
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: AppColors.primary,
                                      width: 4,
                                    ),
                                    right: BorderSide(
                                      color: AppColors.primary,
                                      width: 4,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Loading Indicator saat processing
                  if (isProcessing)
                    Container(
                      color: Colors.black.withOpacity(0.3),
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                ],
              ],
            ),
          ),

          // Bottom Instructions
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                if (scannedCode != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Kode: $scannedCode',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.green.shade800,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppColors.onSurface.withOpacity(0.5),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Pastikan QR code berada di dalam frame',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Tidak dapat mengakses kamera',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _retryInitialization,
              icon: Icon(Icons.refresh),
              label: Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
