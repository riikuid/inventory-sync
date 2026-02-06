// lib/features/printer/presentation/bloc/printer_cubit.dart

import 'dart:developer' as dev;
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
      dev.log('state.printer: ${state.statusMessage}');

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
        dev.log('state.printer: ${state.statusMessage}');
      } else if (isStillConnected && !state.isConnected) {
        // Koneksi masih ada tapi state tidak updated
        emit(
          state.copyWith(
            isConnected: true,
            statusMessage:
                "Terhubung: ${state.selectedDevice?.name ?? 'Unknown'}",
          ),
        );
        dev.log('state.printer: ${state.statusMessage}');
      } else if (isStillConnected) {
        emit(
          state.copyWith(
            statusMessage:
                "Terhubung: ${state.selectedDevice?.name ?? 'Unknown'}",
          ),
        );
        dev.log('state.printer: ${state.statusMessage}');
      } else {
        emit(state.copyWith(statusMessage: "Tidak terhubung"));
        dev.log('state.printer: ${state.statusMessage}');
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
    required DateTime createdAt,
    required int quantity,
    required String setId,
    // required int quantity,
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
      int rightColMargin = 170 + leftMargin;
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
          "TEXT $textStartX,$headerY,\"1\",0,1,1,\"PT MANUNGGAL PERKASA|${createdAt}\"\r\n";

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
      List<String> wrappedName = _wrapText(name, 17);
      // List<String> wrappedName = _wrapText('iniadlahitemku', 5);
      int currentY = topMargin + 60;

      for (String line in wrappedName) {
        commands += "TEXT $rightColMargin,$currentY,\"3\",0,1,1,\"$line\"\r\n";
        currentY += 25;
      }

      // -- MANUF --
      int specLabelY = currentY + 10;
      int specValueY = specLabelY + 20;
      commands +=
          "TEXT $rightColMargin,$specLabelY,\"1\",0,1,1,\"MANUF CODE:\"\r\n";
      commands +=
          "TEXT $rightColMargin,$specValueY,\"2\",0,1,1,\"$manufCode\"\r\n";

      // -- QUANTITY --
      int quantityLabelY = specValueY + 25;
      int quantityValueY = specValueY + 40;
      commands +=
          "TEXT $rightColMargin,$quantityLabelY,\"1\",0,1,1,\"QUANTITY: $quantity\"\r\n";
      // commands +=
      //     "TEXT $rightColMargin,$quantityValueY,\"2\",0,1,1,\"$quantity\"\r\n";

      // -- FOOTER CODE (DIBOLD) --
      int footerY = 200;
      int codeY = 225;

      commands += "TEXT $leftMargin,$footerY,\"2\",0,1,1,\"ITEM CODE :\"\r\n";
      commands += "BOLD 1\r\n";
      commands += "TEXT $leftMargin,$codeY,\"5\",0,1,1,\"$companyCode\"\r\n";
      commands += "BOLD 0\r\n";

      // -- FOOTER DATE (DIBOLD) --
      int dateY = 285;
      commands += "BOLD 1\r\n";
      commands += "TEXT $leftMargin,$dateY,\"2\",0,1,1,\"${setId}\"\r\n";
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
    List<String> words = text.split('');
    String currentLine = "";

    for (var word in words) {
      if ((currentLine + word).length > maxChars) {
        lines.add(currentLine.trim());
        currentLine = "$word";
      } else {
        currentLine += "$word";
      }
    }
    if (currentLine.isNotEmpty) lines.add(currentLine.trim());
    return lines;
  }

  Future<bool> printRakLabel({
    required String rakName, // contoh: "A1"
    required String rakId, // untuk QR
    double paperWidthMm = 100, // default 10cm
    double paperHeightMm = 50, // default 5cm
  }) async {
    // --- CEK KONEKSI ---
    final bool isConnected = await PrintBluetoothThermal.connectionStatus;
    if (!isConnected) {
      emit(
        state.copyWith(
          isConnected: false,
          statusMessage: "Koneksi printer terputus",
          error: "Printer mati atau tidak terjangkau",
        ),
      );
      dev.log("PRINT FAILED: printer disconnected");
      return false;
    }

    // rakName = 'A1';

    try {
      /// ==============================
      /// TARGET DESIGN (LOGICAL CANVAS)
      /// ==============================
      /// Layout yang kamu mau: 10 x 5 cm (landscape)
      const double designW = 100;
      const double designH = 50;

      /// ==============================
      /// ACTUAL PAPER (PHYSICAL)
      /// ==============================
      final double paperW = paperWidthMm;
      final double paperH = paperHeightMm;

      /// ==============================
      /// CENTERING OFFSET
      /// ==============================
      final double offsetX = (paperW - designW) / 2;
      final double offsetY = (paperH - designH) / 2;

      // Fungsi Helper konversi mm ke dots (203 DPI -> 8 dots/mm)
      int ox(double v) => ((v + offsetX) * 8).round();
      int oy(double v) => ((v + offsetY) * 8).round();

      String cmd = "";

      // SETUP
      cmd += "SIZE ${paperW} mm,${paperH} mm\r\n";
      cmd += "GAP 2 mm,0 mm\r\n";
      cmd += "CLS\r\n";

      // --- LOGIC AUTO SHRINK RACK NAME ---
      // User request: "LEMARI" (6 chars) -> Font 2, Scale 5x5
      //               "A1" (2 chars)     -> Lebih besar (Very Big)

      int fontType = 2;
      int mulX = 1;
      int mulY = 1;

      if (rakName.length <= 3) {
        // Ex: "A1" -> SANGAT BESAR
        // Coba 8x8 (Font 2 height approx 20 dots * 8 = 160 dots = 20mm) matches available space
        fontType = 2;
        mulX = 12;
        mulY = 12;
      } else if (rakName.length <= 6) {
        // Ex: "LEMARI" -> BESAR (User Approved)
        fontType = 2;
        mulX = 5;
        mulY = 5;
      } else if (rakName.length <= 9) {
        // Ex: "GUDAG A" -> SEDANG
        fontType = 2;
        mulX = 3;
        mulY = 3;
      } else {
        // Long text
        fontType = 2;
        mulX = 2;
        mulY = 2;

        // Wrap logic or smaller font if needed for very long text
        if (rakName.length > 15) {
          mulX = 1;
          mulY = 2;
        }
      }

      // --- LAYOUTING ---

      // 1. HEADER: PT MANUNGGAL PERKASA
      cmd += "TEXT ${ox(4)},${oy(1)},\"2\",0,2,2,\"PT MANUNGGAL PERKASA\"\r\n";

      // 2. QR CODE (Kiri, Besar)
      cmd += "QRCODE ${ox(4)},${oy(10)},L,13,A,0,\"$rakId\"\r\n";

      // 3. LABEL "RAK:"
      cmd += "TEXT ${ox(44)},${oy(10)},\"2\",0,3,3,\"RAK:\"\r\n";

      // 4. RACK NAME (DINAMIS)
      cmd += "BOLD 1\r\n";
      cmd +=
          "TEXT ${ox(44)},${oy(20)},\"$fontType\",0,$mulX,$mulY,\"$rakName\"\r\n";
      cmd += "BOLD 0\r\n";

      // PRINT
      cmd += "PRINT 1,1\r\n";

      await PrintBluetoothThermal.writeBytes(cmd.codeUnits);
      return true;
    } catch (e) {
      emit(state.copyWith(error: "Gagal print rak: $e"));
      return false;
    }
  }
}
