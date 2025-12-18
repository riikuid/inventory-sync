// lib/features/labeling/presentation/bloc/assembly/assembly_state.dart

part of 'assembly_cubit.dart';

enum AssemblyStatus {
  initial,
  loading,
  loaded,
  generating_component, // Sedang bikin unit komponen di DB
  printing_component, // Sedang print
  scanned, // Berhasil scan
  assembling, // Sedang finalisasi set
  success, // Selesai
  failure,
}

/// Merepresentasikan 1 baris komponen dalam resep
class AssemblyItemState extends Equatable {
  final String componentId;
  final String name;
  final String manufCode;
  final int qtyNeeded;

  // State Tracking
  final String? generatedUnitId; // ID unit di DB (jika sudah diprint/generate)
  final String? qrValue; // QR string
  final bool isPrinted; // Apakah user sudah klik print?
  final bool isScanned; // Apakah user sudah validasi fisik?

  const AssemblyItemState({
    required this.componentId,
    required this.name,
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
      name: name,
      manufCode: manufCode,
      qtyNeeded: qtyNeeded,
      generatedUnitId: generatedUnitId ?? this.generatedUnitId,
      qrValue: qrValue ?? this.qrValue,
      isPrinted: isPrinted ?? this.isPrinted,
      isScanned: isScanned ?? this.isScanned,
    );
  }

  @override
  List<Object?> get props => [
    componentId,
    name,
    generatedUnitId,
    isPrinted,
    isScanned,
  ];
}

class AssemblyState extends Equatable {
  final AssemblyStatus status;
  final String variantId;
  final String variantName;
  final List<AssemblyItemState> components;

  // Hasil Akhir
  final String? parentSetQr;
  final String? parentSetUnitId;

  final String? error;
  final String? lastScanMessage; // Feedback toast (Hijau/Merah)

  const AssemblyState({
    this.status = AssemblyStatus.initial,
    required this.variantId,
    required this.variantName,
    this.components = const [],
    this.parentSetQr,
    this.parentSetUnitId,
    this.error,
    this.lastScanMessage,
  });

  bool get isAllComponentsScanned =>
      components.isNotEmpty && components.every((c) => c.isScanned);

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
      error: error, // Auto-clear error on new state usually
      lastScanMessage: lastScanMessage, // Nullable update
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
