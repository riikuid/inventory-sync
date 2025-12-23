class VariantComponentRow {
  final String componentId;
  final String name;
  final String? manufCode;
  final String? brandName;
  final int totalUnits; // unit ACTIVE untuk komponen ini
  final String type; // 'IN_BOX' or 'SEPARATE'

  VariantComponentRow({
    required this.componentId,
    required this.name,
    this.manufCode,
    this.brandName,
    required this.totalUnits,
    required this.type,
  });
}
