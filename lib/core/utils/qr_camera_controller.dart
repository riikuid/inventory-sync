import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class QrCameraController {
  CameraController? _cameraController;
  BarcodeScanner? _barcodeScanner;
  bool _isProcessing = false;
  bool _isInitialized = false;

  CameraController? get cameraController => _cameraController;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    try {
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        throw Exception('Tidak ada kamera yang tersedia');
      }

      // 🔴 KUNCI UTAMA UNTUK IMIN - Cari kamera external/webcam terlebih dahulu
      CameraDescription camera;
      try {
        // Coba cari kamera dengan lens direction external (untuk webcam/USB camera)
        camera = cameras.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.external,
        );
        debugPrint('📷 Menggunakan kamera EXTERNAL (webcam)');
      } catch (_) {
        // Jika tidak ada external, coba cari kamera belakang
        try {
          camera = cameras.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.back,
          );
          debugPrint('📷 Menggunakan kamera BACK');
        } catch (_) {
          // Terakhir, gunakan kamera depan
          camera = cameras.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.front,
          );
          debugPrint('📷 Menggunakan kamera FRONT');
        }
      }

      _cameraController = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup
            .nv21, // Gunakan nv21 untuk kompatibilitas lebih baik
      );

      await _cameraController!.initialize();

      _barcodeScanner = BarcodeScanner(formats: [BarcodeFormat.qrCode]);
      _isInitialized = true;

      debugPrint('✅ Kamera berhasil diinisialisasi');
    } catch (e) {
      debugPrint('❌ Error inisialisasi kamera: $e');
      _isInitialized = false;
      rethrow;
    }
  }

  Future<String?> process(CameraImage image) async {
    if (_isProcessing || !_isInitialized || _barcodeScanner == null)
      return null;

    _isProcessing = true;

    try {
      // Konversi CameraImage ke InputImage yang benar
      final inputImage = _convertCameraImage(image);
      if (inputImage == null) return null;

      final barcodes = await _barcodeScanner!.processImage(inputImage);

      if (barcodes.isNotEmpty) {
        final rawValue = barcodes.first.rawValue;
        debugPrint('✅ QR Code terdeteksi: $rawValue');
        return rawValue;
      }
    } catch (e) {
      debugPrint('❌ Error processing image: $e');
    } finally {
      _isProcessing = false;
    }

    return null;
  }

  InputImage? _convertCameraImage(CameraImage image) {
    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final imageSize = Size(image.width.toDouble(), image.height.toDouble());

      // Tentukan rotation berdasarkan sensor orientation
      final InputImageRotation imageRotation = InputImageRotation.rotation0deg;

      // Format NV21 untuk Android YUV420
      final InputImageFormat inputImageFormat = InputImageFormat.nv21;

      // Bytes per row dari plane pertama
      // final planeData = image.planes.map((Plane plane) {
      //   return InputImageMetadata(
      //     bytesPerRow: plane.bytesPerRow,
      //     size: Size((plane.width?.toDouble() ?? 0), (plane.height?.toDouble() ?? 0))
      //     // height: plane.height,
      //     // width: plane.width,
      //   );
      // }).toList();

      final inputImageData = InputImageMetadata(
        size: imageSize,
        rotation: imageRotation,
        format: inputImageFormat,
        bytesPerRow: image.planes.first.bytesPerRow,
      );

      return InputImage.fromBytes(bytes: bytes, metadata: inputImageData);
    } catch (e) {
      debugPrint('❌ Error converting image: $e');
      return null;
    }
  }

  void dispose() {
    _isInitialized = false;
    _cameraController?.dispose();
    _barcodeScanner?.close();
    _cameraController = null;
    _barcodeScanner = null;
  }
}
