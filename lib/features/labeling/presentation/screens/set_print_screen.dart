import 'package:audioplayers/audioplayers.dart';
import 'package:ellipsized_text/ellipsized_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_sync_apps/core/config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_sync_apps/core/db/daos/variant_dao.dart';
import 'package:inventory_sync_apps/core/db/model/variant_detail_row.dart';
import 'package:inventory_sync_apps/core/utils/custom_back_button.dart';
import 'package:inventory_sync_apps/core/utils/custom_toast.dart';
import 'package:inventory_sync_apps/core/utils/loading_overlay.dart';
import 'package:inventory_sync_apps/features/printer/screen/printer_management_screen.dart';
import 'package:inventory_sync_apps/features/purchase_order/bloc/receiving_session/receiving_session_cubit.dart';
import 'package:inventory_sync_apps/features/purchase_order/services/purchase_order_service.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import 'package:inventory_sync_apps/core/db/model/variant_component_row.dart';
import '../../../../core/styles/app_style.dart';
import 'package:inventory_sync_apps/features/company_item/widget/qr_scanner_modal.dart';
import '../../../../core/styles/color_scheme.dart';
import '../../../../core/styles/text_theme.dart';
import '../../../../shared/presentation/widgets/primary_button.dart';
import '../../../printer/bloc/printer_cubit.dart';
import '../bloc/set_item/assembly_cubit.dart';

class SetPrintScreen extends StatefulWidget {
  final VariantDetailRow variantRow;
  final String variantId;
  final String variantName;
  final String companyCode;
  final int userId;
  final int? userPurchasingId;
  final String variantManufCode;
  final String rackId;
  final String rackName;
  final List<VariantComponentRow> targetComponents;
  final int quantity;
  final int contentQuantity;
  final String? poNumber;
  final int? setPrice;

  const SetPrintScreen({
    super.key,
    required this.variantId,
    required this.variantName,
    required this.companyCode,
    required this.userId,
    required this.targetComponents,
    required this.variantManufCode,
    required this.rackId,
    required this.rackName,
    required this.userPurchasingId,
    required this.poNumber,
    this.quantity = 1, // Default 1
    this.contentQuantity = 1,
    required this.variantRow,
    required this.setPrice,
  });

  @override
  State<SetPrintScreen> createState() => _SetPrintScreenState();
}

class _SetPrintScreenState extends State<SetPrintScreen> {
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Load & Auto Generate QR saat masuk
    context.read<AssemblyCubit>().loadRequirements(
      inBoxComponents: widget.targetComponents,
      variantManufCode: widget.variantManufCode,
      variantRackId: widget.rackId,
      variantRackName: widget.rackName,
      userId: widget.userId,
      companyCode: widget.companyCode,
      qty: widget.quantity,
      poNumber: widget.poNumber,
      variantUomId: widget.variantRow.uomId,
      variantUomName: widget.variantRow.uom,
      variantPrice: widget.setPrice,
    );

    // Scan printer
    context.read<PrinterCubit>().scanPrinters();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PrinterCubit, PrinterState>(
      listener: (context, printerState) {
        if (printerState.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(printerState.error!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<PrinterCubit, PrinterState>(
        builder: (context, printerState) {
          return BlocConsumer<AssemblyCubit, AssemblyState>(
            listener: (context, state) {
              // if (state.lastScanMessage != null) {
              if (state.lastScanMessage != null &&
                  state.lastScanMessage!.contains('tidak')) {
                final isError = state.lastScanMessage!.contains('tidak');

                isError ? _playErrorSound() : _playSuccessSound();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.lastScanMessage!),
                    backgroundColor: isError ? Colors.red : Colors.green,
                  ),
                );
              } else if (state.lastScanMessage != null) {
                _playSuccessSound();
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(
                //     content: Text(state.lastScanMessage!),
                //     backgroundColor: Colors.green,
                //   ),
                // );
              }

              // Auto-pop jika semua set dihapus
              if (state.units.isEmpty &&
                  state.status == AssemblyStatus.loaded) {
                Navigator.pop(context, false);
              }
            },
            builder: (context, assemblyState) {
              final isComplete = assemblyState.isAllUnitsScanned;
              final hasStartedPrinting = assemblyState.units.any(
                (u) => u.isPrinted || u.isScanned,
              );

              return WillPopScope(
                onWillPop: () async {
                  final leave = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(
                        'Batalkan Proses Pelabelan?',
                        style: AppTextStyles.mono.copyWith(
                          color: AppColors.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      content: const Text(
                        'Unit QR sudah dibuat. Keluar sekarang akan menghapus data tersebut.',
                        style: TextStyle(
                          color: AppColors.onBackground,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: const Text(
                            'Tetap Lanjut',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          child: const Text(
                            'Hapus & Keluar',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (leave == true && mounted) {
                    await context.read<AssemblyCubit>().cancelAssembly();
                    if (context.mounted) {
                      Navigator.of(context).pop(false);
                    }
                    return false;
                  }
                  return false;
                },
                child: Scaffold(
                  backgroundColor: AppColors.background,
                  appBar: AppBar(
                    title: Text(
                      'Cetak Label',
                      style: TextStyle(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    centerTitle: false,
                    leading: CustomBackButton(
                      onPressed: () async {
                        await Navigator.of(context).maybePop();
                      },
                    ),
                  ),

                  body: RefreshIndicator(
                    onRefresh: () async {
                      await context.read<PrinterCubit>().checkConnection();
                    },
                    child: Column(
                      children: [
                        _buildConnectionBar(context, printerState),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Status:",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.onBackground,
                                ),
                              ),
                              Text(
                                "${assemblyState.units.where((u) => u.isScanned).length} / ${assemblyState.units.length} Unit Tervalidasi",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: isComplete
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 👇 UPDATED: Progress Bar
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: LinearProgressIndicator(
                            value: assemblyState.units.isEmpty
                                ? 0
                                : assemblyState.units
                                          .where((u) => u.isScanned)
                                          .length /
                                      assemblyState.units.length,
                            backgroundColor: Colors.grey.shade200,
                            color: isComplete
                                ? Colors.green
                                : AppColors.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 1),
                        // Progress Bar if needed
                        Expanded(
                          child: assemblyState.status == AssemblyStatus.loading
                              ? const Center(child: CircularProgressIndicator())
                              : _buildGroupedList(assemblyState, printerState),
                        ),
                      ],
                    ),
                  ),
                  bottomNavigationBar: _buildBottomBar(
                    context,
                    assemblyState,
                    printerState.isConnected,
                    isComplete,
                    hasStartedPrinting,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // 👇 NEW: Grouped List Builder
  Widget _buildGroupedList(AssemblyState state, PrinterState printerState) {
    // Group units by setIndex
    Map<int, List<AssemblyUnitItem>> grouped = {};
    for (var unit in state.units) {
      if (!grouped.containsKey(unit.setIndex)) {
        grouped[unit.setIndex] = [];
      }
      grouped[unit.setIndex]!.add(unit);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: grouped.length,
      itemBuilder: (ctx, index) {
        final setIndex = grouped.keys.elementAt(index);
        final units = grouped[setIndex]!;

        return Container(
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Set
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      // "Set #${setIndex + 1}",
                      "#${units.where((u) => u.parentUnitId == null).first.unitId}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: 16,
                      ),
                    ),

                    // DELETE BUTTON (Only for Parent QR)
                    GestureDetector(
                      onTap: () {
                        final parent = units.firstWhere((u) => u.isParent);
                        _showDeleteSetScanner(context, parent);
                      },
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.3),
                          ),
                        ),
                        child: Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Items
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.all(12),
                itemCount: units.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (ctx, i) {
                  final unit = units[i];
                  // Cari index asli di flat list cubit state untuk fungsi print
                  final realIndex = state.units.indexOf(unit);

                  return _buildUnitCard(
                    unit,
                    unitIndex: realIndex,
                    isPrinterConnected: printerState.isConnected,
                    hasStartedPrinting: unit.isPrinted || unit.isScanned,
                    onPrint: () => _printUnit(realIndex),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // --- BOTTOM BAR REFACTOR ---
  Widget _buildBottomBarContent(
    BuildContext context,
    AssemblyState state,
    bool isPrinterConnected,
    bool isComplete,
    bool hasStartedPrinting,
  ) {
    // KONDISI 1: SUDAH SELESAI (SEMUA TERVALIDASI) -> Barulah tombol SELESAI muncul
    if (isComplete) {
      return CustomButton(
        color: AppColors.primary,
        elevation: 0,
        radius: 40,
        height: 50,
        width: double.infinity,
        onPressed: _onFinishBatch, // Finish & Activate
        child: Text(
          "SIMPAN & SELESAI",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      );
    }

    // KONDISI 2: SUDAH PRINT TAPI BELUM KOMPLIT -> TAMPILKAN TOMBOL VALIDASI
    if (hasStartedPrinting) {
      return Row(
        children: [
          Expanded(
            child: CustomButton(
              elevation: 0,
              radius: 40,
              height: 50,
              color: !isPrinterConnected ? Colors.grey : AppColors.secondary,
              onPressed: isPrinterConnected
                  ? () => _printAllUnits(isReprint: true)
                  : null,
              child: Row(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_print_shop_outlined,
                    color: !isPrinterConnected
                        ? AppColors.onSurface.withAlpha(100)
                        : AppColors.onSurface,
                  ),
                  Text(
                    "Cetak Ulang",
                    style: TextStyle(
                      color: !isPrinterConnected
                          ? AppColors.onSurface.withAlpha(100)
                          : AppColors.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CustomButton(
              color: AppColors.surface,
              borderColor: AppColors.border,
              elevation: 0,
              radius: 40,
              height: 50,
              onPressed: () => _openScanner(context.read<AssemblyCubit>()),
              child: Row(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code_scanner, color: AppColors.primary),
                  Text(
                    "Validasi",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    // KONDISI 3: BELUM PRINT SAMA SEKALI -> TOMBOL CETAK SEMUA
    return CustomButton(
      elevation: 0,
      radius: 40,
      height: 50,
      width: double.infinity,
      color: isPrinterConnected ? AppColors.secondary : Colors.grey,
      onPressed: isPrinterConnected
          ? () => _printAllUnits(isReprint: false)
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          Icon(
            Icons.print_outlined,
            size: 18,
            color: isPrinterConnected
                ? AppColors.onSurface
                : AppColors.onSurface.withAlpha(100),
          ),
          Text(
            'CETAK SEMUA LABEL',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: isPrinterConnected
                  ? AppColors.onSurface
                  : AppColors.onSurface.withAlpha(100),
            ),
          ),
        ],
      ),
    );
  }

  // --- BOTTOM BAR WRAPPER ---
  Widget _buildBottomBar(
    BuildContext context,
    AssemblyState state,
    bool isPrinterConnected,
    bool isComplete,
    bool hasStartedPrinting,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black12)),
      ),
      child: _buildBottomBarContent(
        context,
        state,
        isPrinterConnected,
        isComplete,
        hasStartedPrinting,
      ),
    );
  }

  // 👇 UPDATED: Unit Card with Parent Highlight
  Widget _buildUnitCard(
    AssemblyUnitItem unit, {
    required int unitIndex,
    required bool isPrinterConnected,
    required bool hasStartedPrinting,
    required VoidCallback onPrint,
  }) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    if (unit.isScanned) {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
      statusText = "Valid";
    } else if (unit.isPrinted) {
      statusColor = Colors.orange;
      statusIcon = Icons.print;
      statusText = "Tercetak";
    } else {
      statusColor = Colors.grey;
      statusIcon = Icons.hourglass_empty;
      statusText = "Pending";
    }

    // Special Style for Parent
    final isParent = unit.isParent;
    final bgColor = isParent
        ? AppColors.secondary.withOpacity(0.1)
        : AppColors.surface;
    final borderColor = isParent ? AppColors.secondary : AppColors.border;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [AppStyle.defaultBoxShadow],
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: isParent ? 2.0 : 1.2),
      ),
      child: Column(
        children: [
          if (isParent)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    color: AppColors.primary,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    "LABEL BOX",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                child: PrettyQrView.data(data: unit.qrValue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EllipsizedText(
                      unit.qrValue,
                      type: EllipsisType.middle,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: AppColors.onMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      unit.componentName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: isParent ? 18 : 16,
                        color: isParent
                            ? AppColors.primary
                            : AppColors.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "LOK: ${unit.rackName}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurface.withAlpha(150),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "SPEK: ${unit.manufCode}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurface.withAlpha(150),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),
          const Divider(),
          const SizedBox(height: 6),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // BADGE STATUS
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

              // BUTTON: CETAK ULANG
              if (hasStartedPrinting && !unit.isScanned)
                CustomButton(
                  elevation: 0.2,
                  width: 30,
                  height: 30,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  radius: 15,
                  color: isPrinterConnected
                      ? (isParent ? AppColors.surface : Colors.grey.shade100)
                      : Colors.grey.shade300,
                  borderColor: AppColors.border,
                  onPressed: isPrinterConnected ? onPrint : null,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.print_outlined,
                        size: 14,
                        color: isPrinterConnected
                            ? Colors.grey.shade500
                            : AppColors.onBackground,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Cetak Ulang',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isPrinterConnected
                              ? Colors.grey.shade500
                              : AppColors.onBackground,
                        ),
                      ),
                    ],
                  ),
                ),

              // Development Only: Validated Button
              if (!Config.isProduction() && !unit.isScanned)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: CustomButton(
                    elevation: 0,
                    height: 30,
                    width: 50,
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    radius: 15,
                    color: AppColors.primary.withOpacity(0.1),
                    borderColor: AppColors.primary,
                    onPressed: () {
                      context.read<AssemblyCubit>().onScanQr(unit.qrValue);
                    },
                    child: Text(
                      'Validated (Dev)',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // --- CONNECTION BAR ---
  Widget _buildConnectionBar(BuildContext context, PrinterState state) {
    final isConnected = state.isConnected;
    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PrinterManagementScreen(),
          ),
        );
        if (context.mounted) {
          context.read<PrinterCubit>().checkConnection();
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isConnected ? Colors.green.shade50 : Colors.orange.shade50,
          border: Border.symmetric(
            vertical: BorderSide(
              color: isConnected ? Colors.green : Colors.orange,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              isConnected
                  ? Icons.bluetooth_connected
                  : Icons.bluetooth_disabled,
              size: 20,
              color: isConnected ? Colors.green : Colors.orange,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isConnected
                        ? "Printer Terhubung"
                        : "Printer Belum Terhubung",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isConnected
                          ? Colors.green.shade800
                          : Colors.orange.shade800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isConnected
                        ? state.selectedDevice?.name ?? 'Unknown'
                        : "Tap untuk menghubungkan",
                    style: TextStyle(
                      fontSize: 12,
                      color: isConnected
                          ? Colors.green.shade700
                          : Colors.orange.shade700,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.settings,
              size: 20,
              color: isConnected
                  ? Colors.green.shade700
                  : Colors.orange.shade700,
            ),
          ],
        ),
      ),
    );
  }

  // 👇 UPDATED: Print UNIT individual
  Future<void> _printUnit(int unitIndex) async {
    final printerCubit = context.read<PrinterCubit>();
    final assemblyCubit = context.read<AssemblyCubit>();

    // Safety check
    if (unitIndex < 0 || unitIndex >= assemblyCubit.state.units.length) return;

    final unit = assemblyCubit.state.units[unitIndex];

    final success = await printerCubit.printLabel(
      createdAt: unit.createdAt,
      location: unit.rackName,
      name: unit.componentName,
      manufCode: unit.manufCode,
      qrValue: unit.qrValue,
      companyCode: widget.companyCode,
      quantity: unit.quantity,
      setId: unit.parentUnitId != null ? '(${unit.parentUnitId})' : unit.unitId,
    );

    if (success) {
      await assemblyCubit.markAsPrinted(unitIndex, widget.userId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal print. Cek koneksi."),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  // 👇 UPDATED: Print semua units
  Future<void> _printAllUnits({bool isReprint = false}) async {
    final printerCubit = context.read<PrinterCubit>();
    final assemblyCubit = context.read<AssemblyCubit>();
    final units = assemblyCubit.state.units;

    if (!printerCubit.state.isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Printer belum terhubung!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(
    //       isReprint ? "Mencetak ulang semua..." : "Mencetak semua label...",
    //     ),
    //     backgroundColor: Colors.blue,
    //   ),
    // );

    for (int i = 0; i < units.length; i++) {
      bool shouldPrint = isReprint ? true : !units[i].isPrinted;

      if (shouldPrint) {
        await _printUnit(i);
        // Delay slighty between prints to prevent buffer overflow
        await Future.delayed(const Duration(milliseconds: 800));
      }
    }
  }

  // 👇 UPDATED: Selesai Batch Process (Activate All)
  void _onFinishBatch() async {
    final assemblyCubit = context.read<AssemblyCubit>();
    final sessionCubit = context.read<ReceivingSessionCubit>();
    final session = sessionCubit.state;

    // 1. Cek apakah ini sesi penerimaan PO?
    if (session.isActive) {
      // Hitung total item yang diterima
      // Contoh: 5 box (batch) * 10 pcs/box (content) = 50 pcs
      final totalReceivedQty = widget.quantity * widget.contentQuantity;

      // Tampilkan Loading Blocking
      LoadingOverlay.show(context);

      try {
        // 2. HIT API PURCHASING (Online First)
        final service = PurchaseOrderService();

        final result = await service.receiveItem(
          poCode: session.poNumber ?? '-',
          poDetailId: session.poDetailId ?? 0,
          userPurchasingId: widget.userPurchasingId,
          qty: totalReceivedQty,
          uomId: session.purchasingUomId ?? 1,
        );

        if (result.isSuccess) {
          // 3. JIKA SUKSES API -> SIMPAN KE DB LOKAL
          await assemblyCubit.activateAllUnitComponents(userId: widget.userId);

          // 4. Update Sisa Qty di Session
          sessionCubit.decreaseRemainingQty(totalReceivedQty);

          LoadingOverlay.hide();

          if (mounted) {
            CustomToast.success(
              context,
              description: "Berhasil menerima $totalReceivedQty item!",
            );
            Navigator.pop(context, true); // Kembali ke detail
          }
        } else {
          // Gagal API
          LoadingOverlay.hide();
          if (mounted) {
            CustomToast.error(
              context,
              description: "Gagal sync ke Purchasing: ${result.errorMessage}",
            );
          }
        }
      } catch (e) {
        // Error Jaringan/Lainnya
        LoadingOverlay.hide();
        if (mounted) {
          CustomToast.error(context, description: "Terjadi kesalahan: $e");
        }
      }
    } else {
      // --- FLOW REGULER (BUKAN PO) ---
      // Langsung simpan lokal tanpa hit API Purchasing
      await assemblyCubit.activateAllUnitComponents(userId: widget.userId);
      if (mounted) Navigator.pop(context, true);
    }
  }

  Future<void> _playSuccessSound() async {
    await _audioPlayer.play(AssetSource('sounds/success.mp3'), volume: 1.0);
  }

  Future<void> _playErrorSound() async {
    await _audioPlayer.play(AssetSource('sounds/error.mp3'), volume: 1.0);
  }

  // --- DELETE SET HELPERS ---

  void _showDeleteSetScanner(
    BuildContext context,
    AssemblyUnitItem parentUnit,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return QrScannerModal(
          onScanSuccess: (qrValue) {
            Navigator.pop(ctx); // Tutup scanner

            // Verifikasi lokal sebelum delete
            if (parentUnit.qrValue == qrValue) {
              _showSetDeletionConfirmation(context, parentUnit, qrValue);
            } else {
              CustomToast.error(
                context,
                description:
                    'QR Code tidak cocok dengan Parent Set yg dipilih!',
              );
            }
          },
        );
      },
    );
  }

  void _showSetDeletionConfirmation(
    BuildContext context,
    AssemblyUnitItem parentUnit,
    String verifiedQr,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Set Label?'),
        content: Text(
          'Anda akan menghapus Parent Unit #${parentUnit.unitId} beserta seluruh komponennya.\nTindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // Tutup dialog
              context.read<AssemblyCubit>().voidSet(
                parentUnitId: parentUnit.unitId,
                scannedQr: verifiedQr,
              );
            },
            child: const Text('Hapus Set', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _openScanner(AssemblyCubit cubit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => SizedBox(
        height: MediaQuery.of(ctx).size.height * 0.85,
        child: AssemblyScannerModal(cubit: cubit),
      ),
    );
  }
}

// --- SCANNER MODAL ---
class AssemblyScannerModal extends StatefulWidget {
  final AssemblyCubit cubit;
  const AssemblyScannerModal({required this.cubit, super.key});

  @override
  State<AssemblyScannerModal> createState() => _AssemblyScannerModalState();
}

class _AssemblyScannerModalState extends State<AssemblyScannerModal> {
  late MobileScannerController cameraController;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    cameraController = MobileScannerController(
      formats: [BarcodeFormat.qrCode],
      detectionSpeed: DetectionSpeed.noDuplicates,
    );
  }

  @override
  void dispose() {
    cameraController.dispose();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
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
                controller: cameraController,
                onDetect: (capture) async {
                  if (isProcessing) return;
                  final raw = capture.barcodes.firstOrNull?.rawValue;
                  if (raw == null) return;

                  setState(() => isProcessing = true);

                  await widget.cubit.onScanQr(raw);

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
