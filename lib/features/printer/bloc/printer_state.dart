part of 'printer_cubit.dart';

class PrinterState extends Equatable {
  final List<BluetoothInfo> availableDevices;
  final BluetoothInfo? selectedDevice;
  final bool isConnected;
  final String statusMessage;
  final String? error;

  const PrinterState({
    this.availableDevices = const [],
    this.selectedDevice,
    this.isConnected = false,
    this.statusMessage = "Disconnected",
    this.error,
  });

  PrinterState copyWith({
    List<BluetoothInfo>? availableDevices,
    BluetoothInfo? selectedDevice,
    bool? isConnected,
    String? statusMessage,
    String? error,
  }) {
    return PrinterState(
      availableDevices: availableDevices ?? this.availableDevices,
      selectedDevice: selectedDevice ?? this.selectedDevice,
      isConnected: isConnected ?? this.isConnected,
      statusMessage: statusMessage ?? this.statusMessage,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    availableDevices,
    selectedDevice,
    isConnected,
    statusMessage,
    error,
  ];
}
