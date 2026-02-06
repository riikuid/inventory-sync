// lib/features/labeling/presentation/bloc/assembly/assembly_state.dart

part of 'assembly_cubit.dart';

enum AssemblyStatus {
  initial,
  loading,
  loaded,
  generating_component,
  printing_component,
  scanned,
  assembling,
  success,
  failure,
}

/// 👇 BARU: Merepresentasikan 1 UNIT individual (bukan komponen!)
class AssemblyUnitItem extends Equatable {
  final String? componentId;
  final String componentName;
  final String manufCode;
  final String rackName;
  final String rackId;
  final int quantity;

  // Unit-specific data
  final String unitId; // ID unit di DB
  final String qrValue; // QR string
  final bool isPrinted;
  final bool isScanned;

  // 👇 NEW: Batch Grouping Data
  final String? parentUnitId;
  final bool isParent;
  final int printCount;
  final int setIndex; // 0, 1, 2... untuk grouping UI

  final DateTime createdAt;
  const AssemblyUnitItem({
    this.componentId,
    required this.componentName,
    required this.manufCode,
    required this.rackName,
    required this.rackId,
    required this.unitId,
    required this.qrValue,
    required this.quantity,
    required this.createdAt,
    this.isPrinted = false,
    this.isScanned = false,
    this.parentUnitId,
    this.isParent = false,
    this.printCount = 0,
    this.setIndex = 0,
  });

  AssemblyUnitItem copyWith({
    bool? isPrinted,
    bool? isScanned,
    int? printCount,
  }) {
    return AssemblyUnitItem(
      componentId: componentId,
      componentName: componentName,
      manufCode: manufCode,
      rackName: rackName,
      rackId: rackId,
      unitId: unitId,
      qrValue: qrValue,
      createdAt: createdAt,
      isPrinted: isPrinted ?? this.isPrinted,
      isScanned: isScanned ?? this.isScanned,
      parentUnitId: parentUnitId,
      isParent: isParent,
      setIndex: setIndex,
      quantity: quantity,
      printCount: printCount ?? this.printCount,
    );
  }

  @override
  List<Object?> get props => [
    unitId,
    isPrinted,
    isScanned,
    parentUnitId,
    isParent,
    setIndex,
    createdAt,
    quantity,
    printCount,
  ];
}

/// 👇 UPDATED: State sekarang pakai FLAT LIST units
class AssemblyState extends Equatable {
  final AssemblyStatus status;
  final String variantId;
  final String variantName;

  // 👇 FLAT LIST - Semua unit dari semua komponen
  final List<AssemblyUnitItem> units;

  // Hasil Akhir
  final String? parentSetQr;
  final String? parentSetUnitId;

  final String? error;
  final String? lastScanMessage;

  const AssemblyState({
    this.status = AssemblyStatus.initial,
    required this.variantId,
    required this.variantName,
    this.units = const [],
    this.parentSetQr,
    this.parentSetUnitId,
    this.error,
    this.lastScanMessage,
  });

  /// Helper: Apakah semua unit sudah di-scan?
  bool get isAllUnitsScanned =>
      units.isNotEmpty && units.every((u) => u.isScanned);

  AssemblyState copyWith({
    AssemblyStatus? status,
    List<AssemblyUnitItem>? units,
    String? parentSetQr,
    String? parentSetUnitId,
    String? error,
    String? lastScanMessage,
  }) {
    return AssemblyState(
      status: status ?? this.status,
      variantId: variantId,
      variantName: variantName,
      units: units ?? this.units,
      parentSetQr: parentSetQr ?? this.parentSetQr,
      parentSetUnitId: parentSetUnitId ?? this.parentSetUnitId,
      error: error,
      lastScanMessage: lastScanMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    variantId,
    units,
    parentSetQr,
    error,
    lastScanMessage,
  ];
}
