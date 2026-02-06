// lib/features/labeling/data/models/assembly_result.dart
class AssemblyResult {
  final String parentUnitId;
  final String parentQrValue;
  final List<String> boundComponentUnitIds;

  AssemblyResult({
    required this.parentUnitId,
    required this.parentQrValue,
    required this.boundComponentUnitIds,
  });
}
