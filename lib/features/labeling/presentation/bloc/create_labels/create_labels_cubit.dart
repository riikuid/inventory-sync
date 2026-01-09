// lib/features/labeling/presentation/bloc/create_labels/create_labels_cubit.dart

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_sync_apps/core/constant.dart';
import 'package:inventory_sync_apps/features/labeling/data/labeling_repository.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../core/db/app_database.dart';

part 'create_labels_state.dart';

class LabelItem {
  final String id;
  final String qrValue;
  final String itemName;
  final String rackName;
  final String companyCode;
  int status; // 'PENDING' | 'PRINTED' | validatedStatus
  int printCount;

  LabelItem({
    required this.id,
    required this.qrValue,
    required this.itemName,
    required this.rackName,
    required this.companyCode,
    this.status = pendingStatus,
    this.printCount = 0,
  });

  LabelItem copyWith({int? status, int? printCount}) {
    return LabelItem(
      id: id,
      qrValue: qrValue,
      itemName: itemName,
      rackName: rackName,
      companyCode: companyCode,
      status: status ?? this.status,
      printCount: printCount ?? this.printCount,
    );
  }
}

class CreateLabelsCubit extends Cubit<CreateLabelsState> {
  final LabelingRepository repo;

  CreateLabelsCubit(this.repo) : super(CreateLabelsState.initial());

  /// generate -> create pending units and seed LabelItem list
  // Update method generate
  Future<void> generate({
    required String variantId,
    required String companyCode,
    required String? rackId,
    required String rackName,
    required String itemName,
    required int qty,
    required int userId,
    // Tambahan parameter nullable
    String? componentId,
    String? manufCode, // Opsional, untuk dimasukkan ke format QR component
  }) async {
    emit(state.copyWith(status: CreateLabelsStatus.generating));
    try {
      // Panggil repo yang sudah di-update
      final units = await repo.generateBatchLabels(
        variantId: variantId,
        companyCode: companyCode,
        rackId: rackId,
        qty: qty,
        userId: userId,
        componentId: componentId,
        manufCode: manufCode,
      );

      final items = units
          .map(
            (u) => LabelItem(
              id: u.id,
              qrValue: u.qrValue,
              itemName: itemName,
              rackName: rackName,
              status: u.status,
              companyCode: companyCode,
              printCount: u.printCount,
            ),
          )
          .toList();

      emit(state.copyWith(status: CreateLabelsStatus.generated, items: items));
    } catch (e) {
      emit(
        state.copyWith(status: CreateLabelsStatus.failure, error: e.toString()),
      );
    }
  }

  // =========================================================
  // BLUETOOTH & PRINTING LOGIC (Migrasi dari Test File)
  // =========================================================

  Future<void> initBluetooth() async {
    // 1. Request Permission
    if (Platform.isAndroid) {
      await [
        Permission.bluetooth,
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.location,
      ].request();
    }
    // 2. Scan Devices
    scanPrinters();
  }

  Future<void> scanPrinters() async {
    try {
      final List<BluetoothInfo> list =
          await PrintBluetoothThermal.pairedBluetooths;
      emit(
        state.copyWith(
          availableDevices: list,
          printerStatusMessage: list.isEmpty
              ? "Tidak ada device paired"
              : "Siap Connect",
        ),
      );
    } catch (e) {
      emit(state.copyWith(printerStatusMessage: "Error Scan: $e"));
    }
  }

  Future<void> connectPrinter(BluetoothInfo device) async {
    emit(
      state.copyWith(
        printerStatusMessage: "Menghubungkan ke ${device.name}...",
        isPrinterConnected: false,
      ),
    );

    try {
      // 1. Attempt Pertama
      bool result = await PrintBluetoothThermal.connect(
        macPrinterAddress: device.macAdress,
      );

      // 2. Retry Logic (Sesuai kode uji coba)
      if (!result) {
        emit(state.copyWith(printerStatusMessage: "Retrying connection..."));
        await Future.delayed(const Duration(seconds: 1));
        result = await PrintBluetoothThermal.connect(
          macPrinterAddress: device.macAdress,
        );
      }

      emit(
        state.copyWith(
          selectedDevice: device,
          isPrinterConnected: result,
          printerStatusMessage: result
              ? "Terhubung: ${device.name}"
              : "Gagal Terhubung",
        ),
      );

      if (!result) {
        emit(
          state.copyWith(
            error: "Gagal menghubungkan ke printer. Cek nyala/mati printer.",
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isPrinterConnected: false,
          printerStatusMessage: "Exception: $e",
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> disconnectPrinter() async {
    await PrintBluetoothThermal.disconnect;
    emit(
      state.copyWith(
        isPrinterConnected: false,
        printerStatusMessage: "Disconnected",
        selectedDevice: null,
      ),
    );
  }

  /// Mencetak list unit yang ada di state (atau unit spesifik)
  Future<void> printLabelsBatch({
    required String companyName, // "PT MANUNGGAL PERKASA"
    required String name,
    required String manufCode,
  }) async {
    if (!state.isPrinterConnected) {
      emit(state.copyWith(error: "Printer belum terhubung!"));
      return;
    }

    emit(state.copyWith(status: CreateLabelsStatus.printing));

    try {
      // Loop semua items yang belum diprint (atau logic lain sesuai kebutuhan)
      // Di sini kita contohkan print semua yang statusnya PENDING/VALIDATED
      final itemsToPrint = state.items;

      for (var item in itemsToPrint) {
        // Panggil logic TSPL
        await _sendTsplCommand(
          company: companyName,
          location: item.rackName,
          name: name, // Nama Item
          manufCode: manufCode,
          qrValue: item.qrValue, // QR Value
          companyCode: item.companyCode,
        );
      }

      // Update status jadi printed di DB & State
      final ids = itemsToPrint.map((e) => e.id).toList();
      // ... panggil markPrinted di repo (sudah ada di kode lama) ...
      // Kita panggil ulang method markPrinted yg sudah ada
      // Note: Anda perlu pass userId ke method ini jika ingin clean

      emit(state.copyWith(status: CreateLabelsStatus.printed));
    } catch (e) {
      emit(
        state.copyWith(
          status: CreateLabelsStatus.failure,
          error: "Gagal mencetak: $e",
        ),
      );
    }
  }

  /// Logic TSPL Persis dari File Uji Coba
  Future<void> _sendTsplCommand({
    required String company,
    required String location,
    required String name,
    required String manufCode,
    required String qrValue,
    required String companyCode,
  }) async {
    int leftMargin = 20;
    int rightColMargin = 180 + leftMargin;

    String commands = "";

    // -- SETUP --
    commands += "SIZE 60 mm,40 mm\r\n";
    commands += "GAP 2 mm,0 mm\r\n";
    commands += "CLS\r\n";

    // -- HEADER --
    commands += "TEXT $leftMargin,20,\"1\",0,1,1,\"$company\"\r\n";

    // -- QR CODE --
    // Ukuran QR tetap 8 sesuai request terakhir
    commands += "QRCODE $leftMargin,40,L,7,A,0,\"$qrValue\"\r\n";

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
  }

  // Helper Wrapp Text (Private)
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

  /// mark as printed (call after physical printing success)
  Future<void> markPrinted(List<String> unitIds, int userId) async {
    emit(state.copyWith(status: CreateLabelsStatus.printing));
    try {
      await repo.recordPrintedUnits(unitIds: unitIds, userId: userId);

      final updated = state.items.map((it) {
        if (unitIds.contains(it.id)) {
          return it.copyWith(
            status: printedStatus,
            printCount: it.printCount + 1,
          );
        }
        return it;
      }).toList();

      emit(state.copyWith(status: CreateLabelsStatus.printed, items: updated));
    } catch (e) {
      emit(
        state.copyWith(status: CreateLabelsStatus.failure, error: e.toString()),
      );
    }
  }

  /// validate a scanned QR (called from camera scanner)
  // Future<void> validateByQr(String qrValue) async {
  //   // find generated item in current batch by qrValue
  //   LabelItem match = state.items.firstWhere(
  //     (it) => it.qrValue == qrValue,
  //     // orElse: () => null,
  //   );

  //   if (match == null) {
  //     // maybe try to lookup in db for friendly message (but we treat as wrong)
  //     emit(
  //       state.copyWith(
  //         lastScanResult: ScanResult.invalid('QR tidak terdaftar di batch ini'),
  //       ),
  //     );
  //     return;
  //   }

  //   if (match.status == validatedStatus) {
  //     emit(
  //       state.copyWith(
  //         lastScanResult: ScanResult.duplicate('QR sudah tervalidasi'),
  //       ),
  //     );
  //     return;
  //   }

  //   // mark validated locally (UI)
  //   final updated = state.items.map((it) {
  //     if (it.id == match.id) return it.copyWith(status: validatedStatus);
  //     return it;
  //   }).toList();

  //   emit(
  //     state.copyWith(
  //       items: updated,
  //       lastScanResult: ScanResult.valid(match.qrValue),
  //     ),
  //   );

  //   // optional: if you want to immediately persist validated -> call repo.finalizeValidatedUnits for single id
  //   // but we will finalize all at the end when user press Selesai
  // }
  Future<void> validateByQr(String qrValue) async {
    // 1. CARA AMAN: Filter dulu baru ambil first
    // Menggunakan .where() tidak akan error walau hasil kosong
    final matches = state.items.where((it) => it.qrValue == qrValue);

    // 2. Cek apakah ada hasil?
    if (matches.isEmpty) {
      emit(
        state.copyWith(
          // Reset last result biar UI tau ada update baru
          lastScanResult: ScanResult.invalid('QR tidak dikenali / Salah'),
        ),
      );
      return;
    }

    // Ambil item pertama karena pasti ada
    LabelItem match = matches.first;

    // 3. Cek Status Duplicate
    if (match.status == validatedStatus) {
      emit(
        state.copyWith(
          lastScanResult: ScanResult.duplicate(
            'Label ini sudah divalidasi sebelumnya',
          ),
        ),
      );
      return;
    }

    // 4. Update Status Succcess
    final updated = state.items.map((it) {
      if (it.id == match.id) return it.copyWith(status: validatedStatus);
      return it;
    }).toList();

    emit(
      state.copyWith(
        items: updated,
        lastScanResult: ScanResult.valid(match.qrValue),
      ),
    );
  }

  /// finalize (save) all validated items -> set ACTIVE in DB
  Future<void> finalize(int userId) async {
    final validatedIds = state.items
        .where((i) => i.status == validatedStatus)
        .map((i) => i.id)
        .toList();
    if (validatedIds.isEmpty) {
      emit(
        state.copyWith(
          status: CreateLabelsStatus.failure,
          error: 'Tidak ada yang tervalidasi',
        ),
      );
      return;
    }

    emit(state.copyWith(status: CreateLabelsStatus.validating));
    try {
      await repo.finalizeValidatedUnits(unitIds: validatedIds, userId: userId);
      emit(state.copyWith(status: CreateLabelsStatus.success));
    } catch (e) {
      emit(
        state.copyWith(status: CreateLabelsStatus.failure, error: e.toString()),
      );
    }
  }

  /// cancel -> delete pending units
  Future<void> cancelAll() async {
    final ids = state.items.map((i) => i.id).toList();
    if (ids.isEmpty) {
      emit(CreateLabelsState.initial());
      return;
    }
    try {
      await repo.cancelGeneratedUnits(unitIds: ids);
      emit(CreateLabelsState.initial());
    } catch (e) {
      emit(
        state.copyWith(status: CreateLabelsStatus.failure, error: e.toString()),
      );
    }
  }

  void loadExistingUnit({
    required Unit unit,
    required String itemName,
    required String companyCode,
    required String rackName,
  }) {
    final item = LabelItem(
      id: unit.id,
      qrValue: unit.qrValue,
      itemName: itemName, // Atau ambil nama variant dari DB
      rackName: rackName,
      companyCode: companyCode, // Perlu di query/pass
      status: unit.status,
    );

    emit(
      state.copyWith(
        status: CreateLabelsStatus.generated,
        items: [item], // List isi 1 item saja (si Parent)
      ),
    );
  }

  // /// set selected printer info in state
  // void setPrinter(PrinterDevice? device) {
  //   emit(state.copyWith(selectedPrinter: device));
  // }
}
