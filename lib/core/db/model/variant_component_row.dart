class VariantComponentRow {
  final String componentId;
  final String variantId;

  final int quantity;

  // ID incremental Component dari server
  final int? componentRemoteId;

  final String name;
  final String? manufCode;
  final String? brandName;
  final int totalUnits; // unit ACTIVE untuk komponen ini
  final int type; // inBoxType or separateType

  VariantComponentRow({
    required this.variantId,
    required this.componentId,
    required this.quantity,
    this.componentRemoteId,
    required this.name,
    this.manufCode,
    this.brandName,
    required this.totalUnits,
    required this.type,
  });
}
