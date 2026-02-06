// lib/features/labeling/presentation/screens/preview_print_screen.dart

import 'dart:developer';
import 'dart:developer' as dev;

import 'package:audioplayers/audioplayers.dart';
import 'package:ellipsized_text/ellipsized_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_sync_apps/core/constant.dart';
import 'package:inventory_sync_apps/core/styles/app_style.dart';
import 'package:inventory_sync_apps/core/utils/custom_back_button.dart';
import 'package:inventory_sync_apps/core/utils/custom_toast.dart';
import 'package:inventory_sync_apps/core/utils/loading_overlay.dart';
import 'package:inventory_sync_apps/features/purchase_order/bloc/receiving_session/receiving_session_cubit.dart';
import 'package:inventory_sync_apps/features/purchase_order/services/purchase_order_service.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:inventory_sync_apps/core/config.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

// Import Cubits & Styles
import '../../../../core/styles/color_scheme.dart';
import '../../../../core/styles/text_theme.dart';
import '../../../../shared/presentation/widgets/primary_button.dart';
import '../../../printer/bloc/printer_cubit.dart';
import '../bloc/single_item/create_labels_cubit.dart';
import '../../../printer/screen/printer_management_screen.dart';
import '../../../company_item/widget/qr_scanner_modal.dart';

class SinglePrintScreen extends StatefulWidget {
  final int userId;

  final String companyCode;
  final String manufcode;
  final String rackName;
  final int? userPurchasingId;

  const SinglePrintScreen({
    super.key,
    required this.userId,

    required this.companyCode,
    required this.manufcode,
    required this.rackName,
    this.userPurchasingId,
  });

  @override
  State<SinglePrintScreen> createState() => _SinglePrintScreenState();
}

class _SinglePrintScreenState extends State<SinglePrintScreen> {
  void initState() {
    super.initState();
    // Auto-check koneksi saat masuk screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PrinterCubit>().checkConnection();
    });
  }

  // Logic Cetak yang Menjembatani PrinterCubit (Global) & LabelsCubit (Lokal)
  void _handlePrint(
    PrinterCubit printerCubit,
    CreateLabelsCubit labelsCubit,
  ) async {
    // 1. Filter item yang belum divalidasi (bisa print ulang item pending/printed)
    final itemsToPrint = labelsCubit.state.items
        .where((i) => i.status != validatedStatus)
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
      log(item.rackName, name: 'PRINT');
      bool success = await printerCubit.printLabel(
        createdAt: item.createdAt,
        location: item.rackName,
        name: item.itemName,
        manufCode: widget.manufcode,
        qrValue: item.qrValue,
        companyCode: widget.companyCode,
        quantity: item.quantity,
        setId: item.id,
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

  // --- MODAL SCANNER DELETE ---
  void _showDeleteScanner(BuildContext context, LabelItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return QrScannerModal(
          title: 'Validasi Hapus Label',
          subtitle: 'Arahkan kamera ke QR atau label yg ingin dihapus ',
          onScanSuccess: (qrValue) {
            Navigator.pop(ctx); // Tutup scanner

            // Verifikasi lokal sebelum delete
            if (item.qrValue == qrValue) {
              _showDeletionConfirmation(context, item, qrValue);
            } else {
              CustomToast.error(
                context,
                description: 'QR Code tidak cocok dengan item yg dipilih!',
              );
            }
          },
        );
      },
    );
  }

  void _showDeletionConfirmation(
    BuildContext context,
    LabelItem item,
    String qrValue,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text(
          'Apakah anda yakin ingin menghapus label untuk "${item.itemName}"?\nID: ${item.id}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // Tutup dialog
              _handleDelete(item.id, qrValue);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _handleDelete(String unitId, String scannedQr) async {
    // Panggil cubit voidUnit
    await context.read<CreateLabelsCubit>().voidUnit(
      unitId: unitId,
      scannedQr: scannedQr,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Kita akses PrinterCubit (Global) dan CreateLabelsCubit (Lokal)
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
        // Tampilkan status message jika penting (Connect/Disconnect/Gagal)
        // if (printerState.statusMessage.isNotEmpty &&
        //     printerState.statusMessage != "Siap Connect" &&
        //     printerState.statusMessage != "Disconnected") {
        //   // Filter pesan default

        //   Color color = Colors.blue;
        //   if (printerState.isConnected) color = Colors.green;
        //   if (printerState.statusMessage.contains("Gagal")) color = Colors.red;

        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text(printerState.statusMessage),
        //       backgroundColor: color,
        //     ),
        //   );
        // }
      },
      child: BlocBuilder<PrinterCubit, PrinterState>(
        builder: (contextPrinter, printerState) {
          return BlocConsumer<CreateLabelsCubit, CreateLabelsState>(
            listener: (contextCreateLabel, state) {
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
                Navigator.pop(context, true); // Kembali ke halaman sebelumnya
              }

              if (state.items.isEmpty) {
                Navigator.pop(context, false);
              }
            },
            builder: (contextCreateLabel, labelsState) {
              final total = labelsState.items.length;
              final validatedCount = labelsState.items
                  .where((i) => i.status == validatedStatus)
                  .length;
              final isAllValidated = total > 0 && validatedCount == total;
              final isAllPending = labelsState.items.every(
                (i) => i.status == pendingStatus,
              );
              // Cek apakah minimal ada 1 yg PRINTED atau VALIDATED untuk mengaktifkan tombol Validasi
              final isAnyPrinted = labelsState.items.any(
                (i) => i.status == printedStatus || i.status == validatedStatus,
              );

              return WillPopScope(
                onWillPop: () async {
                  final leave = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(
                        'Tinggalkan proses pelabelan?',
                        style: AppTextStyles.mono.copyWith(
                          color: AppColors.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      content: const Text(
                        'Label yang belum disimpan akan dihapus. Tetap tinggalkan?',
                        style: TextStyle(
                          color: AppColors.onBackground,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.of(ctx).pop(false), // Tetap di halaman
                          child: const Text(
                            'Batal',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.of(ctx).pop(true), // Keluar
                          child: const Text(
                            'Tinggalkan',
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

                  if (leave == true) {
                    // 1. Jalankan fungsi cleanup cubit
                    await context.read<CreateLabelsCubit>().cancelAll();

                    // 2. Lakukan POP MANUAL dengan membawa nilai 'false'
                    if (context.mounted) {
                      Navigator.of(context).pop(false);
                    }

                    // 3. Return 'false' agar sistem tidak melakukan pop ganda
                    return false;
                  }

                  return false;
                },
                child: Scaffold(
                  backgroundColor: AppColors.background,
                  appBar: AppBar(
                    iconTheme: IconThemeData(color: AppColors.onSurface),
                    leading: CustomBackButton(
                      onPressed: () async {
                        await Navigator.of(context).maybePop();
                      },
                    ),
                    backgroundColor: AppColors.background,
                    elevation: 0.5,
                    toolbarHeight: 60,
                    title: Column(
                      spacing: 3,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cetak Label',
                          style: TextStyle(
                            color: AppColors.onSurface,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        Text(
                          widget.companyCode,
                          style: AppTextStyles.mono.copyWith(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  body: RefreshIndicator(
                    onRefresh: () async {
                      await context.read<PrinterCubit>().checkConnection();
                    },
                    child: Column(
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
                              Text(
                                "Total: $total Unit",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.onBackground,
                                ),
                              ),
                              Text(
                                "$validatedCount / $total Tervalidasi",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
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
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final item = labelsState.items[index];
                              return _buildLabelCard(item);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 4. BOTTOM ACTION BAR (Smart Logic)
                  bottomNavigationBar: _buildBottomBar(
                    context,
                    printerState,
                    contextPrinter.read<PrinterCubit>(),
                    labelsState,
                    isAllPending,
                    isAnyPrinted,
                    isAllValidated,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // --- WIDGET: CARD ITEM DENGAN STATUS TRACKING ---
  // --- WIDGET: CARD ITEM DENGAN STATUS TRACKING ---
  Widget _buildLabelCard(LabelItem item) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (item.status) {
      case validatedStatus:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = "VALID";
        break;
      case printedStatus:
        statusColor = Colors.orange;
        statusIcon = Icons.print;
        statusText = "PRINTED";
        break;
      default: // PENDING
        statusColor = Colors.grey;
        statusIcon = Icons.hourglass_empty;
        statusText = "PENDING";
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [AppStyle.defaultBoxShadow],
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border, width: 1.2),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // QR Preview
              Container(
                width: 80,
                height: 80,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  // border: Border.all(color: Colors.grey.shade300),
                ),
                child: PrettyQrView.data(data: item.qrValue),
              ),
              const SizedBox(width: 12),
              // Info Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EllipsizedText(
                      item.id,
                      type: EllipsisType.middle,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.onMuted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.itemName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "LOK: ${widget.rackName}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurface.withAlpha(150),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      // "QTY: ${item.quantity} • Printed: ${item.printCount}x",
                      "QTY: ${item.quantity}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurface.withAlpha(150),
                      ),
                    ),
                  ],
                ),
              ),

              // Status Badge & Dev Button
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                // margin: const EdgeInsets.only(left: 12),
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

              if (item.status != deletedStatus && item.status != pendingStatus)
                GestureDetector(
                  onTap: () {
                    _showDeleteScanner(context, item);
                  },
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: const Icon(
                      Icons.delete,
                      size: 16.0,
                      color: Colors.red,
                    ),
                  ),
                ),
              // CustomButton(
              //   elevation: 0,
              //   height: 23,
              //   width: 23,
              //   padding: const EdgeInsets.symmetric(
              //     vertical: 6,
              //     horizontal: 6,
              //     // horizontal: 8,
              //   ),
              //   radius: 8,
              //   color: Colors.red.withOpacity(0.1),
              //   borderColor: Colors.red,
              //   onPressed: () {
              //     _showDeleteScanner(context, item);
              //   },
              //   child: Center(
              //     child: const Icon(
              //       Icons.delete,
              //       size: 16.0,
              //       color: Colors.red,
              //     ),
              //   ),
              // ),

              // if (!Config.isProduction() && item.status != validatedStatus)
              //   Padding(
              //     padding: const EdgeInsets.only(left: 12.0, top: 4),
              //     child: CustomButton(
              //       elevation: 0,
              //       height: 28,
              //       width: 100,
              //       padding: const EdgeInsets.symmetric(
              //         vertical: 4,
              //         horizontal: 8,
              //       ),
              //       radius: 12,
              //       color: AppColors.primary.withOpacity(0.1),
              //       borderColor: AppColors.primary,
              //       onPressed: () {
              //         context.read<CreateLabelsCubit>().validateByQr(
              //           item.qrValue,
              //         );
              //       },
              //       child: Text(
              //         'Validate (Dev)',
              //         style: TextStyle(
              //           fontSize: 9,
              //           fontWeight: FontWeight.bold,
              //           color: AppColors.primary,
              //         ),
              //       ),
              //     ),
              //   ),
            ],
          ),
        ],
      ),
    );
  }

  // --- WIDGET: CONNECTION STATUS BAR ---
  // Update untuk _buildConnectionBar di SinglePrintScreen

  void _onSave() async {
    final sessionCubit = context.read<ReceivingSessionCubit>();
    final session = sessionCubit.state;

    final singleSetCubit = context.read<CreateLabelsCubit>();
    final singleSet = singleSetCubit.state;

    if (session.isActive) {
      final totalReceivedQty = singleSet.items.length * singleSet.contentQty;

      // Tampilkan Loading Blocking
      LoadingOverlay.show(context);

      try {
        // 2. HIT API PURCHASING (Online First)
        // Disarankan memanggil via Repository, tapi direct Service juga oke utk pragmatisme
        final service = PurchaseOrderService();

        final result = await service.receiveItem(
          poCode: session.poNumber ?? '-',
          poDetailId: session.poDetailId ?? 0,
          userPurchasingId: widget.userPurchasingId,
          qty: totalReceivedQty,
          uomId: int.parse(singleSet.contentUom?.purchasingId ?? '1'),
        );

        if (result.isSuccess) {
          // 3. JIKA SUKSES API -> SIMPAN KE DB LOKAL
          await singleSetCubit.finalize(widget.userId);

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
              title: 'Gagal sync ke Purchasing',
              description: "${result.errorMessage}",
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
      await singleSetCubit.finalize(widget.userId);
      if (mounted) Navigator.pop(context, true);
    }
  }

  Widget _buildConnectionBar(BuildContext context, PrinterState state) {
    final isConnected = state.isConnected;
    return InkWell(
      onTap: () async {
        // Navigate ke Printer Management Screen
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PrinterManagementScreen(),
          ),
        );
        // Setelah kembali, check connection lagi
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

  // --- WIDGET: BOTTOM BUTTONS ---

  Widget _buildBottomBar(
    BuildContext context,
    PrinterState printerState,
    PrinterCubit printerCubit,
    CreateLabelsState labelsState,
    bool isAllPending,
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
                  elevation: 0,
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _onSave,
                child: const Text(
                  "SIMPAN & SELESAI",
                  style: TextStyle(
                    color: AppColors.surface,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          else if (isAllPending)
            Expanded(
              child: Row(
                children: [
                  // TOMBOL CETAK
                  Expanded(
                    child: CustomButton(
                      elevation: 0,
                      radius: 40,
                      height: 50,
                      color: !printerState.isConnected
                          ? Colors.grey
                          : AppColors.secondary,
                      onPressed: !printerState.isConnected
                          ? null
                          : () {
                              _handlePrint(
                                context.read<PrinterCubit>(),
                                context.read<CreateLabelsCubit>(),
                              );
                            },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 10,
                        children: [
                          Icon(
                            Icons.print_outlined,
                            size: 18,
                            color: !printerState.isConnected
                                ? AppColors.onSurface.withAlpha(100)
                                : AppColors.onSurface,
                          ),
                          Text(
                            'CETAK LABEL',
                            style: TextStyle(
                              // letterSpacing: 1,
                              color: !printerState.isConnected
                                  ? AppColors.onSurface.withAlpha(100)
                                  : AppColors.onSurface,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          // STATE: ACTION (Cetak & Validasi)
          else
            Expanded(
              child: Row(
                children: [
                  // TOMBOL CETAK
                  Expanded(
                    child: CustomButton(
                      elevation: 0,
                      radius: 40,
                      height: 50,
                      color: !printerState.isConnected
                          ? Colors.grey
                          : AppColors.secondary,
                      onPressed: !printerState.isConnected
                          ? null
                          : () {
                              _handlePrint(
                                context.read<PrinterCubit>(),
                                context.read<CreateLabelsCubit>(),
                              );
                            },

                      child: Row(
                        spacing: 5,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.local_print_shop_outlined,
                            color: !printerState.isConnected
                                ? AppColors.onSurface.withAlpha(100)
                                : AppColors.onSurface,
                          ),
                          Text(
                            "Cetak",
                            style: TextStyle(
                              color: !printerState.isConnected
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
                  // TOMBOL VALIDASI
                  Expanded(
                    child: CustomButton(
                      color: AppColors.surface,
                      borderColor: AppColors.border,
                      elevation: 0,
                      radius: 40,
                      height: 50,
                      // Aktifkan validasi jika minimal 1 printed, ATAU user mau validasi manual boleh juga
                      onPressed: () =>
                          _openScanner(context.read<CreateLabelsCubit>()),
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
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    _audioPlayer = AudioPlayer();
    cameraController = MobileScannerController(
      formats: [BarcodeFormat.qrCode],
      detectionSpeed: DetectionSpeed.noDuplicates,
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    _audioPlayer.dispose();

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
        await _playSuccessSound();

        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) Navigator.pop(context);
        _showToast(result.message ?? "Valid!", Colors.green);

        // Cek Kelengkapan
        final total = state.items.length;
        final validated = state.items
            .where((i) => i.status == validatedStatus)
            .length;

        if (validated == total) {
          // _showToast("Semua Selesai! Menutup...", Colors.blue);
          await Future.delayed(const Duration(milliseconds: 800));
          if (mounted) Navigator.pop(context);
        }
      } else {
        await _playErrorSound();
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) Navigator.pop(context);
        _showToast(result?.message ?? "QR Salah / Duplikat", Colors.red);
      }
    } catch (e) {
      await _playErrorSound();
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

  Future<void> _playSuccessSound() async {
    await _audioPlayer.play(AssetSource('sounds/success.mp3'), volume: 1.0);
  }

  Future<void> _playErrorSound() async {
    await _audioPlayer.play(AssetSource('sounds/error.mp3'), volume: 1.0);
  }
}
