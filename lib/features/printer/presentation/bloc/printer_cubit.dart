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
    try {
      final list = await PrintBluetoothThermal.pairedBluetooths;
      emit(
        state.copyWith(
          availableDevices: list,
          statusMessage: list.isEmpty ? "Tidak ada device" : "Siap Connect",
        ),
      );
    } catch (e) {
      emit(state.copyWith(statusMessage: "Error Scan: $e"));
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
          statusMessage: result ? "Terhubung: ${device.name}" : "Gagal Connect",
        ),
      );
    } catch (e) {
      emit(state.copyWith(isConnected: false, statusMessage: "Err: $e"));
    }
  }

  Future<void> disconnect() async {
    await PrintBluetoothThermal.disconnect;
    emit(
      state.copyWith(
        isConnected: false,
        statusMessage: "Disconnected",
        selectedDevice: null,
      ),
    );
  }

  // Generic Print Function (TSPL)
  Future<bool> printLabel({
    required String company,
    required String location,
    required String name,
    required String manufCode,
    required String qrValue,
    required String companyCode,
  }) async {
    if (!state.isConnected) return false;

    try {
      int leftMargin = 20;
      int rightColMargin = 190 + leftMargin;

      String commands = "";

      // --- LOGIC UKURAN QR DINAMIS ---
      // Semakin panjang karakter, semakin kecil cell width-nya agar muat
      int qrCellSize = 6;

      // if (qrValue.length > 20) {
      //   qrCellSize = 6;
      // }
      if (qrValue.length > 40) {
        qrCellSize = 5;
      }

      // -- SETUP --
      commands += "SIZE 60 mm,40 mm\r\n";
      commands += "GAP 2 mm,0 mm\r\n";
      commands += "CLS\r\n";

      // -- HEADER --
      commands += "TEXT $leftMargin,20,\"1\",0,1,1,\"$company\"\r\n";

      // -- QR CODE --
      // Ukuran QR tetap 8 sesuai request terakhir
      commands += "QRCODE $leftMargin,40,L,$qrCellSize,A,0,\"$qrValue\"\r\n";

      // -- LOCATION (DIBOLD) --
      // 1. Nyalakan BOLD
      commands += "BOLD 1\r\n";
      // 2. Cetak Teks Location
      commands += "TEXT $rightColMargin,40,\"4\",0,1,1,\"LOK:$location\"\r\n";
      // 3. Matikan BOLD (Penting! Agar "Item Name" dibawahnya tidak ikut tebal)
      commands += "BOLD 0\r\n";

      // Item Name (Normal)
      // commands += "TEXT $rightColMargin,80,\"2\",0,1,1,\"Item Name :\"\r\n";

      // -- ITEM NAME WRAPPING --
      List<String> wrappedName = _wrapText(name, 19);
      int currentY = 80;

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
      commands += "TEXT $leftMargin,230,\"2\",0,1,1,\"ITEM CODE :\"\r\n";

      // 1. Nyalakan BOLD lagi untuk Kode di bawah
      commands += "BOLD 1\r\n";
      // 2. Cetak Kode (Menggunakan Font "5" sesuai kodemu)
      commands += "TEXT $leftMargin,255,\"5\",0,1,1,\"$companyCode\"\r\n";
      // 3. Matikan BOLD
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
