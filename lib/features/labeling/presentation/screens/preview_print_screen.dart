import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

// Import Cubits & Styles
import '../../../../core/styles/color_scheme.dart';
import '../../../printer/presentation/bloc/printer_cubit.dart';
import '../bloc/create_labels/create_labels_cubit.dart';

class PreviewPrintScreen extends StatefulWidget {
  final String userId;
  final String name; // Nama Variant / Item
  final String companyCode;
  final String manufcode;
  final String rackName;

  const PreviewPrintScreen({
    super.key,
    required this.userId,
    required this.name,
    required this.companyCode,
    required this.manufcode,
    required this.rackName,
  });

  @override
  State<PreviewPrintScreen> createState() => _PreviewPrintScreenState();
}

class _PreviewPrintScreenState extends State<PreviewPrintScreen> {
  // Logic Cetak yang Menjembatani PrinterCubit (Global) & LabelsCubit (Lokal)
  void _handlePrint(
    PrinterCubit printerCubit,
    CreateLabelsCubit labelsCubit,
  ) async {
    // 1. Filter item yang belum divalidasi (bisa print ulang item pending/printed)
    final itemsToPrint = labelsCubit.state.items
        .where((i) => i.status != 'VALIDATED')
        .toList();

    if (itemsToPrint.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua item sudah tervalidasi.")),
      );
      return;
    }

    int successCount = 0;
    List<String> printedIds = [];

    // Tampilkan loading indicator kecil atau toast
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Sedang mengirim data ke printer...")),
    );

    // 2. Loop & Print
    for (var item in itemsToPrint) {
      bool success = await printerCubit.printLabel(
        company: "PT MANUNGGAL PERKASA",
        location: item.rackName,
        name: widget.name,
        manufCode: widget.manufcode,
        qrValue: item.qrValue,
        companyCode: widget.companyCode,
      );

      if (success) {
        successCount++;
        printedIds.add(item.id);
      }

      // Delay kecil agar buffer printer tidak overload
      await Future.delayed(const Duration(milliseconds: 500));
    }

    // 3. Update Status di Database & UI Local
    if (printedIds.isNotEmpty) {
      await labelsCubit.markPrinted(printedIds, widget.userId);

      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Berhasil mencetak $successCount label"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal mencetak. Cek koneksi printer."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Kita akses PrinterCubit (Global) dan CreateLabelsCubit (Lokal)
    return BlocBuilder<PrinterCubit, PrinterState>(
      builder: (context, printerState) {
        return BlocConsumer<CreateLabelsCubit, CreateLabelsState>(
          listener: (context, state) {
            if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error!),
                  backgroundColor: Colors.red,
                ),
              );
            }
            if (state.status == CreateLabelsStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Data Tersimpan!"),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context); // Kembali ke halaman sebelumnya
            }
          },
          builder: (context, labelsState) {
            final total = labelsState.items.length;
            final validatedCount = labelsState.items
                .where((i) => i.status == 'VALIDATED')
                .length;
            final isAllValidated = total > 0 && validatedCount == total;

            // Cek apakah minimal ada 1 yg PRINTED atau VALIDATED untuk mengaktifkan tombol Validasi
            final isAnyPrinted = labelsState.items.any(
              (i) => i.status == 'PRINTED' || i.status == 'VALIDATED',
            );

            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cetak Label',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.companyCode,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: Column(
                children: [
                  // 1. CONNECTION STATUS BAR (Global State)
                  _buildConnectionBar(context, printerState),

                  // 2. PROGRESS INFO
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total: $total Unit"),
                        Text(
                          "$validatedCount / $total Tervalidasi",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isAllValidated
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // 3. LIST DATA LABEL
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: labelsState.items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = labelsState.items[index];
                        return _buildLabelCard(item);
                      },
                    ),
                  ),
                ],
              ),

              // 4. BOTTOM ACTION BAR (Smart Logic)
              bottomNavigationBar: _buildBottomBar(
                context,
                printerState,
                labelsState,
                isAnyPrinted,
                isAllValidated,
              ),
            );
          },
        );
      },
    );
  }

  // --- WIDGET: CARD ITEM DENGAN STATUS TRACKING ---
  Widget _buildLabelCard(LabelItem item) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (item.status) {
      case 'VALIDATED':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = "Valid";
        break;
      case 'PRINTED':
        statusColor = Colors.orange;
        statusIcon = Icons.print;
        statusText = "Printed";
        break;
      default: // PENDING
        statusColor = Colors.grey;
        statusIcon = Icons.hourglass_empty;
        statusText = "Pending";
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // QR Preview
          Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: PrettyQrView.data(data: item.qrValue),
          ),
          const SizedBox(width: 12),
          // Info Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.qrValue,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "LOK: ${widget.rackName}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: statusColor.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(statusIcon, size: 12, color: statusColor),
                const SizedBox(width: 4),
                Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET: CONNECTION STATUS BAR ---
  Widget _buildConnectionBar(BuildContext context, PrinterState state) {
    final isConnected = state.isConnected;
    return InkWell(
      onTap: () => _showDevicePicker(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        color: isConnected ? Colors.green.shade50 : Colors.red.shade50,
        child: Row(
          children: [
            Icon(
              isConnected
                  ? Icons.bluetooth_connected
                  : Icons.bluetooth_searching,
              size: 16,
              color: isConnected ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                isConnected
                    ? "Terhubung: ${state.selectedDevice?.name ?? 'Unknown'}"
                    : "Printer belum terhubung. Ketuk untuk pilih.",
                style: TextStyle(
                  fontSize: 12,
                  color: isConnected
                      ? Colors.green.shade800
                      : Colors.red.shade800,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.arrow_drop_down, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // --- WIDGET: BOTTOM BUTTONS ---
  Widget _buildBottomBar(
    BuildContext context,
    PrinterState printerState,
    CreateLabelsState labelsState,
    bool isAnyPrinted,
    bool isAllValidated,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        children: [
          // STATE: SIMPAN (Jika semua Valid)
          if (isAllValidated)
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  context.read<CreateLabelsCubit>().finalize(widget.userId);
                },
                child: const Text("SIMPAN & SELESAI"),
              ),
            )
          // STATE: ACTION (Cetak & Validasi)
          else
            Expanded(
              child: Row(
                children: [
                  // TOMBOL CETAK
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: !printerState.isConnected
                          ? null
                          : () {
                              _handlePrint(
                                context.read<PrinterCubit>(),
                                context.read<CreateLabelsCubit>(),
                              );
                            },
                      icon: const Icon(Icons.print),
                      label: const Text("Cetak"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // TOMBOL VALIDASI
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      // Aktifkan validasi jika minimal 1 printed, ATAU user mau validasi manual boleh juga
                      onPressed: () =>
                          _openScanner(context.read<CreateLabelsCubit>()),
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text("Validasi"),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // --- MODAL PILIH DEVICE (Menggunakan Global PrinterCubit) ---
  void _showDevicePicker(BuildContext context) {
    context.read<PrinterCubit>().scanPrinters();

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return BlocBuilder<PrinterCubit, PrinterState>(
          builder: (ctx, state) {
            return Container(
              height: 350,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    "Pilih Printer",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  if (state.availableDevices.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text("Mencari printer bluetooth..."),
                    ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.availableDevices.length,
                      itemBuilder: (c, i) {
                        final d = state.availableDevices[i];
                        return ListTile(
                          leading: const Icon(Icons.print),
                          title: Text(d.name),
                          subtitle: Text(d.macAdress),
                          onTap: () {
                            Navigator.pop(context);
                            ctx.read<PrinterCubit>().connect(d);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --- BUKA MODAL SCANNER ---
  void _openScanner(CreateLabelsCubit cubit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return SizedBox(
          height: MediaQuery.of(ctx).size.height * 0.85,
          child: ScannerModal(cubit: cubit),
        );
      },
    );
  }
}

// =========================================================
// WIDGET SCANNER MODAL (Improved Logic)
// =========================================================
class ScannerModal extends StatefulWidget {
  final CreateLabelsCubit cubit;
  const ScannerModal({required this.cubit, super.key});
  @override
  _ScannerModalState createState() => _ScannerModalState();
}

class _ScannerModalState extends State<ScannerModal> {
  late MobileScannerController cameraController;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    cameraController = MobileScannerController(
      formats: [BarcodeFormat.qrCode],
      detectionSpeed: DetectionSpeed.noDuplicates,
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (isProcessing) return;

    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;
    final raw = barcodes.first.rawValue;
    if (raw == null) return;

    setState(() => isProcessing = true);

    try {
      // 1. Validasi via Cubit
      await widget.cubit.validateByQr(raw);

      if (!mounted) return;
      final state = widget.cubit.state;
      final result = state.lastScanResult;

      // 2. Feedback
      if (result != null && result.ok) {
        _showToast(result.message ?? "Valid!", Colors.green);

        // Cek Kelengkapan
        final total = state.items.length;
        final validated = state.items
            .where((i) => i.status == 'VALIDATED')
            .length;

        if (validated == total) {
          _showToast("Semua Selesai! Menutup...", Colors.blue);
          await Future.delayed(const Duration(milliseconds: 800));
          if (mounted) Navigator.pop(context);
        }
      } else {
        _showToast(result?.message ?? "QR Salah / Duplikat", Colors.red);
      }
    } catch (e) {
      _showToast("Error: $e", Colors.red);
    } finally {
      // Debounce agar tidak spam scan
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) setState(() => isProcessing = false);
    }
  }

  void _showToast(String msg, Color color) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1000),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 200,
          left: 16,
          right: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: const Text('Scan Validasi'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        Expanded(
          child: Stack(
            children: [
              MobileScanner(controller: cameraController, onDetect: _onDetect),
              Center(
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isProcessing ? Colors.amber : Colors.white,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              if (isProcessing)
                const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
