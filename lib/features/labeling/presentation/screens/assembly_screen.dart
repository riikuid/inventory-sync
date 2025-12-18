import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_sync_apps/core/db/daos/variant_dao.dart'; // VariantComponentRow
import 'package:mobile_scanner/mobile_scanner.dart';

// Import Cubits & Resources
import '../../../../core/styles/color_scheme.dart';
import '../../../../core/db/app_database.dart';
import '../../../printer/presentation/bloc/printer_cubit.dart';
import '../bloc/assembly/assembly_cubit.dart';
import '../bloc/create_labels/create_labels_cubit.dart'; // Butuh ini utk provider PreviewPrintScreen
import '../../../labeling/data/labeling_repository.dart';
import 'preview_print_screen.dart'; // Import layar preview

class AssemblyScreen extends StatefulWidget {
  final String variantId;
  final String variantName;
  final String companyCode;
  final String userId;
  final String variantManufCode; // Tambahan untuk info parent
  final String rackName; // Tambahan untuk info parent

  // Menggunakan VariantComponentRow sesuai request
  final List<VariantComponentRow> targetComponents;

  const AssemblyScreen({
    super.key,
    required this.variantId,
    required this.variantName,
    required this.companyCode,
    required this.userId,
    required this.targetComponents,
    required this.variantManufCode,
    required this.rackName,
  });

  @override
  State<AssemblyScreen> createState() => _AssemblyScreenState();
}

class _AssemblyScreenState extends State<AssemblyScreen> {
  @override
  void initState() {
    super.initState();
    // Load data (Mapping VariantComponentRow ke Component logic di cubit)
    // Note: Pastikan loadRequirements di Cubit sudah disesuaikan menerima tipe data ini
    // atau lakukan mapping di sini sebelum kirim ke cubit.
    context.read<AssemblyCubit>().loadRequirements(widget.targetComponents);
    context.read<PrinterCubit>().scanPrinters();
  }

  // --- LOGIC 1: CETAK SATUAN ---
  Future<void> _printSingleItem(int index) async {
    final printerCubit = context.read<PrinterCubit>();
    final assemblyCubit = context.read<AssemblyCubit>();

    // 1. Generate Data Unit
    final unit = await assemblyCubit.generateComponentUnit(
      index: index,
      userId: widget.userId,
      companyCode: widget.companyCode,
    );

    if (unit != null) {
      final itemState = assemblyCubit.state.components[index];

      // 2. Print
      final success = await printerCubit.printLabel(
        company: "PT MANUNGGAL PERKASA",
        location: "ASSEMBLY",
        name: itemState.name,
        manufCode: itemState.manufCode,
        qrValue: unit.qrValue,
        companyCode: widget.companyCode,
      );

      if (success) {
        _showSnack("Label tercetak", Colors.green);
      } else {
        _showSnack("Gagal print. Cek koneksi.", Colors.orange);
      }
    }
  }

  // --- LOGIC 2: CETAK SEMUA ---
  Future<void> _printAllItems() async {
    final printerCubit = context.read<PrinterCubit>();
    final assemblyCubit = context.read<AssemblyCubit>();
    final components = assemblyCubit.state.components;

    if (!printerCubit.state.isConnected) {
      _showSnack("Printer belum terhubung!", Colors.red);
      return;
    }

    _showSnack("Mulai mencetak...", Colors.blue);

    for (int i = 0; i < components.length; i++) {
      // Cetak jika belum diprint
      if (!components[i].isPrinted) {
        await _printSingleItem(i);
        // Jeda aman buffer printer
        await Future.delayed(const Duration(milliseconds: 1200));
      }
    }
    _showSnack("Antrian cetak selesai.", Colors.green);
  }

  // --- LOGIC 3: FINALISASI & PINDAH KE PREVIEW PARENT ---
  void _onProceedToParent() async {
    final assemblyCubit = context.read<AssemblyCubit>();

    // 1. Buat Draft Parent Unit (Status PENDING)
    final parentUnit = await assemblyCubit.createDraftSet(
      widget.userId,
      widget.companyCode,
    );

    if (parentUnit != null && mounted) {
      // 2. Lempar ke PreviewPrintScreen untuk Validasi Akhir Parent
      // Kita perlu menyuntikkan CreateLabelsCubit yang "seolah-olah" baru generate parent ini

      final labelingRepo = RepositoryProvider.of<LabelingRepository>(context);

      bool? result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (ctx) => CreateLabelsCubit(labelingRepo)
              ..loadExistingUnit(
                unit: parentUnit,
                itemName: widget.variantName,
                companyCode: widget.companyCode,
              ), // Anda butuh method ini di CreateLabelsCubit*
            child: PreviewPrintScreen(
              userId: widget.userId,
              // variantNae: widget.variantName,
              companyCode: widget.companyCode,
              manufcode: widget.variantManufCode, // Manuf code parent
              rackName: widget.rackName,
            ),
          ),
        ),
      );

      if (result == true) {
        if (mounted) Navigator.pop(context);
      } else if (result == false) {
        // Jika parent tidak jadi dicetak, pop ke halaman sebelumnya dan reset
        if (mounted) {
          await context.read<AssemblyCubit>().cancelAssembly();

          Navigator.pop(context);
        }
      }
    }
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrinterCubit, PrinterState>(
      builder: (context, printerState) {
        return BlocConsumer<AssemblyCubit, AssemblyState>(
          listener: (context, state) {
            if (state.lastScanMessage != null) {
              final isError = state.lastScanMessage!.contains('❌');
              _showSnack(
                state.lastScanMessage!,
                isError ? Colors.red : Colors.green,
              );
            }
            if (state.status == AssemblyStatus.failure) {
              _showSnack(state.error ?? "Error", Colors.red);
            }
          },
          builder: (context, assemblyState) {
            final isComplete = assemblyState.isAllComponentsScanned;
            // Cek apakah ada yang belum diprint
            final hasPendingPrint = assemblyState.components.any(
              (c) => !c.isPrinted,
            );

            return WillPopScope(
              onWillPop: () async {
                // Cek apakah user sudah melakukan progress (sudah ada yg dicetak/scan)
                final hasProgress = context
                    .read<AssemblyCubit>()
                    .state
                    .components
                    .any(
                      (c) =>
                          c.isPrinted ||
                          c.isScanned ||
                          c.generatedUnitId != null,
                    );

                // Jika belum ada progress, boleh langsung keluar
                if (!hasProgress) return true;

                // Jika ada progress, tampilkan Dialog Konfirmasi
                final shouldExit = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Batalkan Perakitan?'),
                    content: const Text(
                      'Anda sudah mencetak beberapa label komponen.\n'
                      'Jika keluar sekarang, label tersebut akan ditarik/dihapus dari sistem.\n\n'
                      'Yakin ingin membatalkan?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.of(ctx).pop(false), // Jangan keluar
                        child: const Text('Lanjut Kerja'),
                      ),
                      TextButton(
                        onPressed: () =>
                            Navigator.of(ctx).pop(true), // Ya, keluar
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Batalkan & Hapus'),
                      ),
                    ],
                  ),
                );

                if (shouldExit == true) {
                  // Panggil fungsi bersih-bersih sebelum keluar
                  if (mounted) {
                    await context.read<AssemblyCubit>().cancelAssembly();
                  }
                  return true; // Izinkan pop
                }

                return false; // Tahan di halaman ini
              },
              child: Scaffold(
                backgroundColor: AppColors.background,
                appBar: AppBar(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Perakitan Set',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.variantName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Text(
                          widget.companyCode,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                body: Column(
                  children: [
                    // Status Printer
                    _buildConnectionBar(context, printerState),

                    // Progress
                    _buildProgressInfo(assemblyState),

                    // List
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: assemblyState.components.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (ctx, index) {
                          final item = assemblyState.components[index];
                          return _buildComponentCard(
                            item,
                            isConnected: printerState.isConnected,
                            onPrint: () => _printSingleItem(index),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                bottomNavigationBar: _buildBottomBar(
                  context,
                  assemblyState,
                  printerState.isConnected,
                  isComplete,
                  hasPendingPrint,
                ),
              ),
            );
          },
        );
      },
    );
  }

  // --- WIDGETS ---

  Widget _buildConnectionBar(BuildContext context, PrinterState state) {
    final isConnected = state.isConnected;
    return InkWell(
      onTap: () => context.read<PrinterCubit>().scanPrinters().then(
        (_) => _showDevicePicker(context),
      ),
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
                    ? "Terhubung: ${state.selectedDevice?.name}"
                    : "Printer belum terhubung. Ketuk untuk pilih.",
                style: TextStyle(
                  fontSize: 12,
                  color: isConnected
                      ? Colors.green.shade800
                      : Colors.red.shade800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressInfo(AssemblyState state) {
    final total = state.components.length;
    final scanned = state.components.where((c) => c.isScanned).length;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Kelengkapan Box:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                "$scanned / $total Komponen",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: total == 0 ? 0 : scanned / total,
            backgroundColor: Colors.grey.shade100,
            color: Colors.green,
            minHeight: 6,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildComponentCard(
    AssemblyItemState item, {
    required bool isConnected,
    required VoidCallback onPrint,
  }) {
    Color statusColor = Colors.grey;
    IconData statusIcon = Icons.circle_outlined;
    String statusText = "Pending";

    if (item.isScanned) {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
      statusText = "OK (Masuk Box)";
    } else if (item.isPrinted) {
      statusColor = Colors.orange;
      statusIcon = Icons.print;
      statusText = "Printed (Scan Label)";
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: statusColor.withOpacity(0.1),
            child: Icon(statusIcon, color: statusColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${item.manufCode}",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),

          // FIX #1: Tombol Reprint Logic
          // Tombol muncul jika BELUM discan.
          // Tombol Aktif jika printer connect (walaupun sudah print, tetap bisa reprint).
          if (!item.isScanned)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: item.isPrinted
                    ? Colors.grey
                    : AppColors.secondary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                visualDensity: VisualDensity.compact,
              ),
              // CHANGE: Hilangkan "!item.isPrinted" agar bisa reprint
              onPressed: isConnected ? onPrint : null,
              icon: const Icon(Icons.print, size: 16),
              label: Text(item.isPrinted ? "Cetak Ulang" : "Cetak"),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    AssemblyState state,
    bool isPrinterConnected,
    bool isComplete,
    bool hasPendingPrint,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        children: [
          if (isComplete)
            // FIX #3: Tombol lanjut ke Parent Label
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: state.status == AssemblyStatus.assembling
                    ? null
                    : _onProceedToParent,
                child: state.status == AssemblyStatus.assembling
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : const Text("GENERATE LABEL UTAMA (SET)"),
              ),
            )
          else
            Expanded(
              child: Row(
                children: [
                  // CETAK SEMUA
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        disabledBackgroundColor: Colors.grey.shade300,
                      ),
                      // Aktif jika printer connect dan masih ada yang belum diprint
                      onPressed: (isPrinterConnected && hasPendingPrint)
                          ? _printAllItems
                          : null,
                      icon: const Icon(Icons.print_outlined),
                      label: const Text("Cetak Semua"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // SCANNER
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () =>
                          _openScanner(context.read<AssemblyCubit>()),
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text("Scan Validasi"),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // --- MODALS ---

  void _showDevicePicker(BuildContext context) {
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
                    const Text("Mencari printer..."),
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

  void _openScanner(AssemblyCubit cubit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // FIX #2: Scanner Modal sekarang menerima callback pop di dalamnya
      builder: (ctx) => SizedBox(
        height: MediaQuery.of(ctx).size.height * 0.85,
        child: AssemblyScannerModal(cubit: cubit),
      ),
    );
  }
}

// --- SCANNER MODAL (FIX #2) ---
class AssemblyScannerModal extends StatefulWidget {
  final AssemblyCubit cubit;
  const AssemblyScannerModal({required this.cubit, super.key});
  @override
  State<AssemblyScannerModal> createState() => _AssemblyScannerModalState();
}

class _AssemblyScannerModalState extends State<AssemblyScannerModal> {
  late MobileScannerController controller;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController(
      formats: [BarcodeFormat.qrCode],
      detectionSpeed: DetectionSpeed.noDuplicates,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: const Text("Scan Komponen"),
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
              MobileScanner(
                controller: controller,
                onDetect: (capture) async {
                  if (isProcessing) return;
                  final raw = capture.barcodes.firstOrNull?.rawValue;
                  if (raw == null) return;

                  setState(() => isProcessing = true);

                  // Panggil logic
                  await widget.cubit.onScanQr(raw);

                  // FIX #2: Tutup Modal apapun hasilnya (Sesuai request)
                  if (mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
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
            ],
          ),
        ),
      ],
    );
  }
}
