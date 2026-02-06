class ScanUnitResult {
  final String unitId;
  final String qrValue;
  final String? componentId;
  final String? componentName;
  final String? variantId;
  final String? variantName;
  final int status; // ACTIVE / BOUND / CONSUMED / DELETED

  ScanUnitResult({
    required this.unitId,
    required this.qrValue,
    required this.status,
    this.componentId,
    this.componentName,
    this.variantId,
    this.variantName,
  });
}
