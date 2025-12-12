// lib/features/labeling/presentation/screens/preview_print_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import '../../../../core/styles/app_style.dart';
import '../../../../core/styles/color_scheme.dart';
import '../bloc/create_labels/create_labels_cubit.dart';

class PreviewPrintScreen extends StatefulWidget {
  final String name;
  final String userId;
  const PreviewPrintScreen({
    super.key,
    required this.userId,
    required this.name,
  });

  @override
  State<PreviewPrintScreen> createState() => _PreviewPrintScreenState();
}

class _PreviewPrintScreenState extends State<PreviewPrintScreen> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CreateLabelsCubit>();
    final state = cubit.state;

    final total = state.items.length;
    final validated = state.items.where((i) => i.status == 'VALIDATED').length;
    final printed = state.items.where((i) => i.status == 'PRINTED').length;

    return WillPopScope(
      onWillPop: () async {
        final leave = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Tinggalkan proses pencetakan?'),
            content: const Text(
              'Label yang belum disimpan akan dihapus. Lanjutkan?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Tinggalkan'),
              ),
            ],
          ),
        );
        if (leave == true) {
          await cubit.cancelAll();
          return true;
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppColors.onSurface),
          leading: IconButton(
            onPressed: () async {
              await Navigator.of(context).maybePop();
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: AppColors.onSurface,
            ),
          ),

          backgroundColor: AppColors.background,
          elevation: 0.5,
          toolbarHeight: 60,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pratinjau & Cetak Label',
                style: AppStyle.poppinsTextSStyle.copyWith(
                  color: AppColors.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 3),
              Text(
                widget.name,
                style: AppStyle.monoTextStyle.copyWith(
                  color: AppColors.primaryDark,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            // header progress + printer row
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  // progress row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$validated / $total tervalidasi',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '$printed tercetak',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Printer info button (long)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.print),
                      label: Text(
                        state.selectedPrinter?.name ??
                            'Pilih Printer (tidak tersambung)',
                      ),
                      onPressed: () async {
                        // open printer picker screen (we'll provide a skeleton below)
                        final selected = await Navigator.of(context)
                            .push<PrinterDevice>(
                              MaterialPageRoute(
                                builder: (_) => const PrinterPickerScreen(),
                              ),
                            );
                        if (selected != null) cubit.setPrinter(selected);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // list
            Expanded(
              child: state.items.isEmpty
                  ? const Center(child: Text('Tidak ada label'))
                  : ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: state.items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (ctx, idx) {
                        final it = state.items[idx];
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              // qr preview (simple)
                              SizedBox(
                                width: 110,
                                height: 110,
                                child: PrettyQrView.data(data: it.qrValue),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      it.qrValue,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Rack: ${it.rackId ?? '-'}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    const SizedBox(height: 8),
                                    Chip(label: Text(it.status)),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),

        // bottom bar
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(12.0),
          child: state.items.isEmpty
              ? null
              : buildBottomBar(cubit, state, validated == total),
        ),
      ),
    );
  }

  Widget buildBottomBar(
    CreateLabelsCubit cubit,
    CreateLabelsState state,
    bool allValidated,
  ) {
    final isPrinted = state.items.any((i) => i.status == 'PRINTED');

    if (allValidated) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: state.status == CreateLabelsStatus.validating
              ? null
              : () async {
                  await cubit.finalize(widget.userId);
                  if (cubit.state.status == CreateLabelsStatus.success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Semua tersimpan')),
                    );
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                },
          child: const Text('Selesai & Simpan'),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed:
                state.items.isEmpty ||
                    state.status == CreateLabelsStatus.printing
                ? null
                : () async {
                    // TODO: integrate actual print flow using state.selectedPrinter
                    // For now simulate: mark all as PRINTED
                    final ids = state.items.map((i) => i.id).toList();
                    await cubit.markPrinted(ids, widget.userId);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tandai tercetak')),
                    );
                  },
            child: const Text('Cetak Label'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton(
            onPressed:
                state.items.isEmpty ||
                    !state.items.any((i) => i.status == 'PRINTED')
                ? null
                : () {
                    // open scanner modal
                    _openScanner(cubit);
                  },
            child: const Text('Validasi'),
          ),
        ),
      ],
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

// === PrinterPicker skeleton (basic) ===
class PrinterPickerScreen extends StatelessWidget {
  const PrinterPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // THIS IS A SKELETON: implement bluetooth list using flutter_bluetooth_serial
    final devices = <PrinterDevice>[
      PrinterDevice(id: 'bt-1', name: 'XP-TT426B (mock)'),
      PrinterDevice(id: 'bt-2', name: 'Thermal-Office'),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Printer')),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (ctx, i) {
          final d = devices[i];
          return ListTile(
            title: Text(d.name),
            onTap: () => Navigator.of(context).pop(d),
          );
        },
      ),
    );
  }
}
