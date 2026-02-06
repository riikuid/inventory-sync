part of 'receiving_session_cubit.dart';

class ReceivingSessionState extends Equatable {
  final bool isActive;
  final String? poNumber;
  final int? poDetailId;
  final String? itemCode;
  final String? itemName;
  final int qtyRemaining; // Sisa Qty dari PO (Target)
  final int
  qtyProcessed; // Qty yang sedang/sudah diproses di sesi ini (Optional tracking)
  final int? purchasingUomId; // ID UOM dari Purchasing (untuk validasi/default)
  final String? purchasingUomName;
  final int? setPrice;

  const ReceivingSessionState({
    this.isActive = false,
    this.poNumber,
    this.poDetailId,
    this.itemCode,
    this.itemName,
    this.qtyRemaining = 0,
    this.qtyProcessed = 0,
    this.purchasingUomId,
    this.purchasingUomName,
    this.setPrice,
  });

  ReceivingSessionState copyWith({
    bool? isActive,
    String? poNumber,
    int? poDetailId,
    String? itemCode,
    String? itemName,
    int? qtyRemaining,
    int? qtyProcessed,
    int? purchasingUomId,
    String? purchasingUomName,
    int? setPrice,
  }) {
    return ReceivingSessionState(
      isActive: isActive ?? this.isActive,
      poNumber: poNumber ?? this.poNumber,
      poDetailId: poDetailId ?? this.poDetailId,
      itemCode: itemCode ?? this.itemCode,
      itemName: itemName ?? this.itemName,
      qtyRemaining: qtyRemaining ?? this.qtyRemaining,
      qtyProcessed: qtyProcessed ?? this.qtyProcessed,
      purchasingUomId: purchasingUomId ?? this.purchasingUomId,
      purchasingUomName: purchasingUomName ?? this.purchasingUomName,
      setPrice: setPrice ?? this.setPrice,
    );
  }

  @override
  List<Object?> get props => [
    isActive,
    poNumber,
    poDetailId,
    itemCode,
    itemName,
    qtyRemaining,
    qtyProcessed,
    purchasingUomId,
    purchasingUomName,
    setPrice,
  ];
}
