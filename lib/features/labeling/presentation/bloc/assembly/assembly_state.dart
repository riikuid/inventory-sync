part of 'assembly_cubit.dart';

enum AssemblyStatus {
  loading,
  idle,
  printing_component,
  scanning_components,
  generating_set,
  success,
  failure,
}

/// Model untuk merepresentasikan 1 baris komponen di UI (The Card)
class AssemblyItemState {
  final String componentId;
  final String componentName;
  final String manufCode;
  final int qtyNeeded; // Berapa pcs butuh komponen ini dalam 1 set (biasanya 1)

  // State Tracking
  final String? generatedUnitId; // ID unit komponen yang baru dibuat (pending)
  final String? qrValue; // QR string untuk dicetak
  final bool isPrinted; // Apakah user sudah klik print?
  final bool isScanned; // Apakah user sudah validasi fisik?

  AssemblyItemState({
    required this.componentId,
    required this.componentName,
    required this.manufCode,
    this.qtyNeeded = 1,
    this.generatedUnitId,
    this.qrValue,
    this.isPrinted = false,
    this.isScanned = false,
  });

  AssemblyItemState copyWith({
    String? generatedUnitId,
    String? qrValue,
    bool? isPrinted,
    bool? isScanned,
  }) {
    return AssemblyItemState(
      componentId: componentId,
      componentName: componentName,
      manufCode: manufCode,
      qtyNeeded: qtyNeeded,
      generatedUnitId: generatedUnitId ?? this.generatedUnitId,
      qrValue: qrValue ?? this.qrValue,
      isPrinted: isPrinted ?? this.isPrinted,
      isScanned: isScanned ?? this.isScanned,
    );
  }
}

class AssemblyState extends Equatable {
  final AssemblyStatus status;
  final String variantId;
  final String variantName;

  // List komponen yang harus dipenuhi
  final List<AssemblyItemState> components;

  // Hasil akhir (Unit Set Gabungan)
  final String? parentSetQr;
  final String? parentSetUnitId;

  final String? error;
  final String? lastScanMessage; // Feedback UI "Komponen Bearing OK"

  const AssemblyState({
    this.status = AssemblyStatus.loading,
    required this.variantId,
    required this.variantName,
    this.components = const [],
    this.parentSetQr,
    this.parentSetUnitId,
    this.error,
    this.lastScanMessage,
  });

  // Getter: Apakah semua komponen sudah divalidasi?
  bool get isAllComponentsScanned => components.every((c) => c.isScanned);

  AssemblyState copyWith({
    AssemblyStatus? status,
    List<AssemblyItemState>? components,
    String? parentSetQr,
    String? parentSetUnitId,
    String? error,
    String? lastScanMessage,
  }) {
    return AssemblyState(
      status: status ?? this.status,
      variantId: variantId,
      variantName: variantName,
      components: components ?? this.components,
      parentSetQr: parentSetQr ?? this.parentSetQr,
      parentSetUnitId: parentSetUnitId ?? this.parentSetUnitId,
      error: error, // Clear error on new state usually, or pass specific
      lastScanMessage: lastScanMessage ?? this.lastScanMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    variantId,
    components,
    parentSetQr,
    error,
    lastScanMessage,
  ];
}
