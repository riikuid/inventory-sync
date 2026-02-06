// lib/features/labeling/data/models/label_component_result.dart
class LabelComponentResult {
  final int generatedCount;
  final String? sampleQrValue; // salah satu QR untuk ditampilkan ke user

  LabelComponentResult({required this.generatedCount, this.sampleQrValue});
}
