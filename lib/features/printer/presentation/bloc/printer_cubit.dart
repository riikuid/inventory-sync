// lib/features/printer/presentation/bloc/printer_cubit.dart

import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

part 'printer_state.dart';

class PrinterCubit extends Cubit<PrinterState> {
  PrinterCubit() : super(const PrinterState());

  Future<void> init() async {
    if (Platform.isAndroid) {
      await [
        Permission.bluetooth,
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.location,
      ].request();
    }
    scanPrinters();
  }

  Future<void> scanPrinters() async {
    emit(state.copyWith(statusMessage: "Mencari printer..."));
    try {
      final list = await PrintBluetoothThermal.pairedBluetooths;
      emit(
        state.copyWith(
          availableDevices: list,
          statusMessage: list.isEmpty ? "Tidak ada device" : "Siap Connect",
        ),
      );
    } catch (e) {
      emit(state.copyWith(statusMessage: "Error Scan: $e", error: "$e"));
    }
  }

  // CEK KONEKSI REAL-TIME
  Future<void> checkConnection() async {
    try {
      emit(state.copyWith(statusMessage: "Mengecek koneksi..."));

      // Cek apakah benar-benar masih connected
      final bool isStillConnected =
          await PrintBluetoothThermal.connectionStatus;

      if (!isStillConnected && state.isConnected) {
        // Koneksi terputus tapi state masih connected
        emit(
          state.copyWith(
            isConnected: false,
            statusMessage: "Koneksi terputus. Silakan reconnect.",
          ),
        );
      } else if (isStillConnected && !state.isConnected) {
        // Koneksi masih ada tapi state tidak updated
        emit(
          state.copyWith(
            isConnected: true,
            statusMessage:
                "Terhubung: ${state.selectedDevice?.name ?? 'Unknown'}",
          ),
        );
      } else if (isStillConnected) {
        emit(
          state.copyWith(
            statusMessage:
                "Terhubung: ${state.selectedDevice?.name ?? 'Unknown'}",
          ),
        );
      } else {
        emit(state.copyWith(statusMessage: "Tidak terhubung"));
      }
    } catch (e) {
      emit(
        state.copyWith(
          isConnected: false,
          statusMessage: "Error cek koneksi: $e",
          error: "$e",
        ),
      );
    }
  }

  Future<void> connect(BluetoothInfo device) async {
    emit(state.copyWith(statusMessage: "Menghubungkan ke ${device.name}..."));
    try {
      bool result = await PrintBluetoothThermal.connect(
        macPrinterAddress: device.macAdress,
      );

      // Retry logic sederhana
      if (!result) {
        await Future.delayed(const Duration(seconds: 1));
        result = await PrintBluetoothThermal.connect(
          macPrinterAddress: device.macAdress,
        );
      }

      emit(
        state.copyWith(
          selectedDevice: device,
          isConnected: result,
          statusMessage: result
              ? "Terhubung: ${device.name}"
              : "Gagal terhubung ke ${device.name}",
          error: result ? null : "Koneksi gagal",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isConnected: false,
          statusMessage: "Error: $e",
          error: "$e",
        ),
      );
    }
  }

  // RECONNECT FUNCTION
  Future<void> reconnect() async {
    if (state.selectedDevice == null) {
      emit(
        state.copyWith(
          statusMessage: "Tidak ada device tersimpan untuk reconnect",
          error: "No device to reconnect",
        ),
      );
      return;
    }

    emit(state.copyWith(statusMessage: "Reconnecting..."));

    // Disconnect dulu
    try {
      await PrintBluetoothThermal.disconnect;
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      print("Error during disconnect: $e");
    }

    // Connect ulang
    await connect(state.selectedDevice!);
  }

  Future<void> disconnect() async {
    try {
      await PrintBluetoothThermal.disconnect;
      emit(
        state.copyWith(
          isConnected: false,
          statusMessage: "Disconnected",
          selectedDevice: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: "Error disconnect: $e"));
    }
  }

  // Generic Print Function (TSPL)
  Future<bool> printLabel({
    required String location,
    required String name,
    required String manufCode,
    required String qrValue,
    required String companyCode,
    int topMargin = 10,
    int leftMargin = 20,
    bool withLogo = false, // Default false karena tidak support
  }) async {
    // CEK KONEKSI SEBELUM PRINT
    try {
      final bool isStillConnected =
          await PrintBluetoothThermal.connectionStatus;
      if (!isStillConnected) {
        emit(
          state.copyWith(
            isConnected: false,
            statusMessage: "Koneksi terputus",
            error: "Printer tidak terhubung",
          ),
        );
        return false;
      }
    } catch (e) {
      emit(state.copyWith(error: "Error cek koneksi: $e"));
      return false;
    }

    if (!state.isConnected) return false;

    try {
      int textStartX = leftMargin;
      int rightColMargin = 190 + leftMargin;
      String commands = "";

      // --- LOGIC UKURAN QR DINAMIS ---
      int qrCellSize = 6;
      if (qrValue.length > 40) {
        qrCellSize = 5;
      }

      // -- SETUP --
      commands += "SIZE 60 mm,40 mm\r\n";
      commands += "GAP 2 mm,0 mm\r\n";
      commands += "CLS\r\n";

      // -- HEADER (dengan topMargin) --
      int headerY = topMargin;
      commands +=
          "TEXT $textStartX,$headerY,\"1\",0,1,1,\"PT MANUNGGAL PERKASA\"\r\n";

      // -- QR CODE (mulai dari topMargin + 20) --
      int qrY = topMargin + 20;
      commands += "QRCODE $leftMargin,$qrY,L,$qrCellSize,A,0,\"$qrValue\"\r\n";

      // -- LOCATION (DIBOLD) --
      int locationY = topMargin + 20;
      commands += "BOLD 1\r\n";
      commands +=
          "TEXT $rightColMargin,$locationY,\"4\",0,1,1,\"LOK:$location\"\r\n";
      commands += "BOLD 0\r\n";

      // -- ITEM NAME WRAPPING --
      List<String> wrappedName = _wrapText(name, 19);
      int currentY = topMargin + 60;

      for (String line in wrappedName) {
        commands += "TEXT $rightColMargin,$currentY,\"3\",0,1,1,\"$line\"\r\n";
        currentY += 25;
      }

      // -- SPEC --
      int specLabelY = currentY + 5;
      int specValueY = specLabelY + 20;
      commands += "TEXT $rightColMargin,$specLabelY,\"1\",0,1,1,\"SPEC:\"\r\n";
      commands +=
          "TEXT $rightColMargin,$specValueY,\"2\",0,1,1,\"$manufCode\"\r\n";

      // -- FOOTER CODE (DIBOLD) --
      int footerY = 220;
      int codeY = 245;

      commands += "TEXT $leftMargin,$footerY,\"2\",0,1,1,\"ITEM CODE :\"\r\n";
      commands += "BOLD 1\r\n";
      commands += "TEXT $leftMargin,$codeY,\"5\",0,1,1,\"$companyCode\"\r\n";
      commands += "BOLD 0\r\n";

      // -- EXECUTE --
      commands += "PRINT 1,1\r\n";

      await PrintBluetoothThermal.writeBytes(commands.codeUnits);
      return true;
    } catch (e) {
      emit(state.copyWith(error: "Gagal print: $e"));
      return false;
    }
  }

  List<String> _wrapText(String text, int maxChars) {
    List<String> lines = [];
    List<String> words = text.split(' ');
    String currentLine = "";

    for (var word in words) {
      if ((currentLine + word).length > maxChars) {
        lines.add(currentLine.trim());
        currentLine = "$word ";
      } else {
        currentLine += "$word ";
      }
    }
    if (currentLine.isNotEmpty) lines.add(currentLine.trim());
    return lines;
  }
}
