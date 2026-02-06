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

  bool get isValid => ok;
  bool get isDuplicate =>
      !ok &&
      ((message ?? '').toLowerCase().contains('duplicate') ||
          (message ?? '').toLowerCase().contains('sudah'));
}

class PrinterDevice {
  final String id;
  final String name;
  PrinterDevice({required this.id, required this.name});
}

class CreateLabelsState extends Equatable {
  final CreateLabelsStatus status;
  final List<LabelItem> items;
  final ScanResult? lastScanResult;
  final String? error;

  // --- BLUETOOTH STATE ---
  final List<BluetoothInfo> availableDevices;
  final BluetoothInfo? selectedDevice;
  final bool isPrinterConnected;
  final String printerStatusMessage;

  // --- CONTENT CONFIG ---
  final List<Uom> uomList;
  final bool isMultiContent;
  final int contentQty;
  final Uom? contentUom;

  const CreateLabelsState({
    required this.status,
    required this.items,
    required this.lastScanResult,
    required this.error,
    // Defaults
    this.availableDevices = const [],
    this.selectedDevice,
    this.isPrinterConnected = false,
    this.printerStatusMessage = "Printer Disconnected",
    this.uomList = const [],
    this.isMultiContent = false,
    this.contentQty = 1,
    this.contentUom,
  });

  factory CreateLabelsState.initial() => const CreateLabelsState(
    status: CreateLabelsStatus.initial,
    items: [],
    lastScanResult: null,
    error: null,
    availableDevices: [],
    selectedDevice: null,
    isPrinterConnected: false,
    printerStatusMessage: "Printer Disconnected",
    uomList: [],
    isMultiContent: false,
    contentQty: 1,
    contentUom: null,
  );

  CreateLabelsState copyWith({
    CreateLabelsStatus? status,
    List<LabelItem>? items,
    ScanResult? lastScanResult,
    bool clearLastScanResult = false, // Added flag
    String? error,
    List<BluetoothInfo>? availableDevices,
    BluetoothInfo? selectedDevice,
    bool? isPrinterConnected,
    String? printerStatusMessage,
    List<Uom>? uomList,
    bool? isMultiContent,
    int? contentQty,
    Uom? contentUom,
  }) {
    return CreateLabelsState(
      status: status ?? this.status,
      items: items ?? this.items,
      lastScanResult: clearLastScanResult
          ? null
          : (lastScanResult ?? this.lastScanResult),
      error: error ?? this.error,
      availableDevices: availableDevices ?? this.availableDevices,
      selectedDevice: selectedDevice ?? this.selectedDevice,
      isPrinterConnected: isPrinterConnected ?? this.isPrinterConnected,
      printerStatusMessage: printerStatusMessage ?? this.printerStatusMessage,
      uomList: uomList ?? this.uomList,
      isMultiContent: isMultiContent ?? this.isMultiContent,
      contentQty: contentQty ?? this.contentQty,
      contentUom: contentUom ?? this.contentUom,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    lastScanResult,
    error,
    availableDevices,
    selectedDevice,
    isPrinterConnected,
    printerStatusMessage,
    uomList,
    isMultiContent,
    contentQty,
    contentUom,
  ];
}
