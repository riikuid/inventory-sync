class VariantComponentRow {
  final String componentId;

  // ID incremental Component dari server
  final int? componentRemoteId;

  final String name;
  final String? manufCode;
  final String? brandName;
  final int totalUnits; // unit ACTIVE untuk komponen ini
  final String type; // 'IN_BOX' or 'SEPARATE'

  VariantComponentRow({
    required this.componentId,
    this.componentRemoteId,
    required this.name,
    this.manufCode,
    this.brandName,
    required this.totalUnits,
    required this.type,
  });
}
