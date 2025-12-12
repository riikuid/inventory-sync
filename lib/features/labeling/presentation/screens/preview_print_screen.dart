import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import '../../../../core/styles/app_style.dart';
import '../../../../core/styles/color_scheme.dart';
import '../bloc/create_labels/create_labels_cubit.dart';

class PreviewPrintScreen extends StatefulWidget {
  final String userId;
  final String name;
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
  @override
  void initState() {
    super.initState();
    // Auto-scan saat masuk (User experience lebih mulus)
    context.read<CreateLabelsCubit>().initBluetooth();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateLabelsCubit, CreateLabelsState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!), backgroundColor: Colors.red),
          );
        }
        if (state.status == CreateLabelsStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Data Tersimpan!"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // Atau navigate ke home
        }
      },
      builder: (context, state) {
        final total = state.items.length;
        final validatedCount = state.items
            .where((i) => i.status == 'VALIDATED')
            .length;
        final isAllValidated = total > 0 && validatedCount == total;

        // Cek apakah ada yang sudah diprint (untuk logic tombol)
        final isAnyPrinted = state.items.any(
          (i) => i.status == 'PRINTED' || i.status == 'VALIDATED',
        );

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Column(
              children: [
                Text(widget.name),
                const Text('Preview & Cetak Label'),
              ],
            ),
          ),
          body: Column(
            children: [
              // 1. CONNECTION STATUS BAR (Kecil di atas)
              _buildConnectionBar(context, state),

              // 2. PROGRESS INFO
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total: $total Unit"),
                    Text(
                      "$validatedCount / $total Tervalidasi",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isAllValidated ? Colors.green : Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),

              // 3. LIST DATA ASLI (Card lama dengan Status)
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return _buildLabelCard(item);
                  },
                ),
              ),
            ],
          ),

          // 4. BOTTOM ACTION BAR (Smart Logic)
          bottomNavigationBar: _buildBottomBar(
            context,
            state,
            isAnyPrinted,
            isAllValidated,
          ),
        );
      },
    );
  }

  // --- WIDGET: CARD ITEM DENGAN STATUS TRACKING ---
  Widget _buildLabelCard(LabelItem item) {
    // Tentukan warna & icon berdasarkan status item
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
        statusIcon = Icons.local_printshop_rounded; // atau icon printer check
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // QR Preview Kecil (Visual clue)
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
                  "LOK: ${item.rackName}",
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
                Icon(statusIcon, size: 14, color: statusColor),
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
  Widget _buildConnectionBar(BuildContext context, CreateLabelsState state) {
    final isConnected = state.isPrinterConnected;
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

  // --- WIDGET: BOTTOM BUTTONS (LOGIC INTI) ---
  Widget _buildBottomBar(
    BuildContext context,
    CreateLabelsState state,
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
          // 1. TOMBOL SIMPAN (Muncul HANYA jika semua Valid)
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
          // 2. TOMBOL FLOW (Cetak & Validasi)
          else
            Expanded(
              child: Row(
                children: [
                  // TOMBOL CETAK
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.secondary, // Warna beda dikit
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      // Disable jika belum connect printer
                      onPressed: !state.isPrinterConnected
                          ? null
                          : () {
                              context
                                  .read<CreateLabelsCubit>()
                                  .printLabelsBatch(
                                    companyName: "PT MANUNGGAL PERKASA",
                                    name: widget.name,
                                    manufCode: widget.manufcode,
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
                      // Validasi hanya boleh jika minimal ada 1 yg sudah diprint (Business Rule)
                      // atau boleh validasi kapan saja, terserah Anda. Di sini saya set bebas.
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

  void _showDevicePicker(BuildContext context) {
    // Panggil scan di cubit
    context.read<CreateLabelsCubit>().scanPrinters();

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<CreateLabelsCubit>(), // Pass existing cubit
          child: BlocBuilder<CreateLabelsCubit, CreateLabelsState>(
            builder: (ctx, state) {
              return Container(
                height: 350,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      "Pilih Printer",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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
                              ctx.read<CreateLabelsCubit>().connectPrinter(d);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _openScanner(CreateLabelsCubit cubit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return SizedBox(
          height: MediaQuery.of(ctx).size.height * 0.8,
          child: ScannerModal(cubit: cubit),
        );
      },
    );
  }
}

// ===== scanner modal widget =====
class ScannerModal extends StatefulWidget {
  final CreateLabelsCubit cubit;
  const ScannerModal({required this.cubit, super.key});
  @override
  _ScannerModalState createState() => _ScannerModalState();
}

class _ScannerModalState extends State<ScannerModal> {
  late MobileScannerController cameraController;
  bool processing = false;

  @override
  void initState() {
    super.initState();
    cameraController = MobileScannerController(formats: [BarcodeFormat.qrCode]);
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _onDetect(Barcode barcode, BarcodeCapture? args) async {
    final raw = barcode.rawValue;
    if (raw == null) return;
    if (processing) return;
    processing = true;

    // call cubit validate
    await widget.cubit.validateByQr(raw).onError((error, stackTrace) {
      processing = false;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saat validasi: $error')));
    });

    final result = widget.cubit.state.lastScanResult;
    if (result != null) {
      final msg = result.ok
          ? 'Tervalidasi: ${result.qr}'
          : (result.message ?? 'Invalid');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }

    // small delay biar tidak double-scan
    await Future.delayed(const Duration(milliseconds: 800));
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: const Text('Scan QR untuk validasi'),
          actions: [
            IconButton(
              icon: const Icon(Icons.flash_on),
              onPressed: () => cameraController.toggleTorch(),
            ),
          ],
        ),
        Expanded(
          child: MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              final barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) _onDetect(barcodes.first, capture);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'Arahkan kamera ke QR. QR yang valid akan otomatis terdeteksi.',
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
