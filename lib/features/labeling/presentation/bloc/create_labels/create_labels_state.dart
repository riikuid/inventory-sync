// lib/features/labeling/presentation/bloc/create_labels/create_labels_state.dart
part of 'create_labels_cubit.dart';

enum CreateLabelsStatus {
  initial,
  generating,
  generated,
  printing,
  printed,
  validating,
  success,
  failure,
}

class ScanResult {
  final bool ok;
  final String? message;
  final String? qr;

  ScanResult._(this.ok, this.message, this.qr);
  factory ScanResult.valid(String qr) => ScanResult._(true, 'Tervalidasi', qr);
  factory ScanResult.invalid(String message) =>
      ScanResult._(false, message, null);
  factory ScanResult.duplicate(String message) =>
      ScanResult._(false, message, null);
}

class PrinterDevice {
  final String id;
  final String name;
  PrinterDevice({required this.id, required this.name});
}

class CreateLabelsState extends Equatable {
  final CreateLabelsStatus status;
  final List<LabelItem> items;
  final PrinterDevice? selectedPrinter;
  final ScanResult? lastScanResult;
  final String? error;

  const CreateLabelsState({
    required this.status,
    required this.items,
    required this.selectedPrinter,
    required this.lastScanResult,
    required this.error,
  });

  factory CreateLabelsState.initial() => const CreateLabelsState(
    status: CreateLabelsStatus.initial,
    items: [],
    selectedPrinter: null,
    lastScanResult: null,
    error: null,
  );

  CreateLabelsState copyWith({
    CreateLabelsStatus? status,
    List<LabelItem>? items,
    PrinterDevice? selectedPrinter,
    ScanResult? lastScanResult,
    String? error,
  }) {
    return CreateLabelsState(
      status: status ?? this.status,
      items: items ?? this.items,
      selectedPrinter: selectedPrinter ?? this.selectedPrinter,
      lastScanResult: lastScanResult ?? this.lastScanResult,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    selectedPrinter,
    lastScanResult,
    error,
  ];
}
