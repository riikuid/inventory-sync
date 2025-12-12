import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:inventory_sync_apps/features/labeling/presentation/bloc/assembly/assembly_cubit.dart';
import 'package:inventory_sync_apps/core/styles/color_scheme.dart'; // Sesuaikan path

class AssemblyScreen extends StatefulWidget {
  final String variantId;
  final String variantName;
  final String companyCode;
  final String userId;

  const AssemblyScreen({
    super.key,
    required this.variantId,
    required this.variantName,
    required this.companyCode,
    required this.userId,
  });

  @override
  State<AssemblyScreen> createState() => _AssemblyScreenState();
}

class _AssemblyScreenState extends State<AssemblyScreen> {
  // Controller scanner untuk pause/resume camera
  final MobileScannerController _scannerController = MobileScannerController(
    formats: [BarcodeFormat.qrCode],
    detectionSpeed: DetectionSpeed.normal,
  );

  bool _isScanningActive = false;

  @override
  void initState() {
    super.initState();
    // Load data komponen saat screen dibuka
    context.read<AssemblyCubit>().loadRequirements();
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Perakitan Set (In-Box)',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              widget.variantName,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        actions: [
          // Indikator Company Code
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Chip(
                label: Text(
                  widget.companyCode,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
                backgroundColor: AppColors.primaryLight,
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<AssemblyCubit, AssemblyState>(
        listener: (context, state) {
          if (state.status == AssemblyStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error ?? 'Terjadi kesalahan'),
                backgroundColor: Colors.red,
              ),
            );
          }

          // Feedback suara/snack saat scan berhasil
          if (state.lastScanMessage != null) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.lastScanMessage!),
                backgroundColor: state.lastScanMessage!.contains('❌')
                    ? Colors.red
                    : Colors.green,
                duration: const Duration(milliseconds: 1500),
              ),
            );
          }

          // Sukses Finalisasi
          if (state.status == AssemblyStatus.success) {
            _showSuccessDialog(state.parentSetQr ?? '-');
          }
        },
        builder: (context, state) {
          if (state.status == AssemblyStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // 1. PROGRESS HEADER
              _buildProgressHeader(state),

              // 2. LIST COMPONENTS
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: state.components.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = state.components[index];
                    return _ComponentCard(
                      item: item,
                      onPrintTap: () {
                        context.read<AssemblyCubit>().generateComponentLabel(
                          index,
                          widget.userId,
                          widget.companyCode,
                        );
                      },
                    );
                  },
                ),
              ),

              // 3. SCANNER & ACTION AREA
              _buildBottomActionArea(context, state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProgressHeader(AssemblyState state) {
    final total = state.components.length;
    final scanned = state.components.where((c) => c.isScanned).length;
    final progress = total == 0 ? 0.0 : scanned / total;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$scanned/$total Komponen Lengkap',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(color: AppColors.primaryDark),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade200,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionArea(BuildContext context, AssemblyState state) {
    final isComplete = state.isAllComponentsScanned;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Area Scanner (Bisa di-toggle on/off untuk hemat baterai)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isScanningActive && !isComplete ? 200 : 0,
            child: _isScanningActive && !isComplete
                ? Stack(
                    children: [
                      MobileScanner(
                        controller: _scannerController,
                        onDetect: (capture) {
                          final barcodes = capture.barcodes;
                          if (barcodes.isNotEmpty) {
                            final code = barcodes.first.rawValue;
                            if (code != null) {
                              context.read<AssemblyCubit>().onScanQr(code);
                            }
                          }
                        },
                      ),
                      Center(
                        child: Container(
                          width: 200,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: IconButton(
                          icon: const Icon(Icons.flash_on, color: Colors.white),
                          onPressed: () => _scannerController.toggleTorch(),
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),

          // Tombol Kontrol
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: isComplete
                ? SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: state.status == AssemblyStatus.generating_set
                          ? null
                          : () => context.read<AssemblyCubit>().createFinalSet(
                              widget.userId,
                            ),
                      child: state.status == AssemblyStatus.generating_set
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'GENERATE SET & SELESAI',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                    ),
                  )
                : Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: Icon(
                            _isScanningActive ? Icons.stop : Icons.camera_alt,
                          ),
                          label: Text(
                            _isScanningActive
                                ? 'Stop Scan'
                                : 'Mulai Scan Validasi',
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () {
                            setState(() {
                              _isScanningActive = !_isScanningActive;
                              if (_isScanningActive) {
                                _scannerController.start();
                              } else {
                                _scannerController.stop();
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String setQr) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('🎉 Assembly Berhasil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 64),
            const SizedBox(height: 16),
            const Text('Unit Set berhasil dibuat!'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.grey.shade100,
              child: Text(
                setQr,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Silakan tempel label QR Set pada box utama.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // back to variant detail
            },
            child: const Text('Selesai'),
          ),
        ],
      ),
    );
  }
}

// WIDGET CARD TERPISAH
class _ComponentCard extends StatelessWidget {
  final AssemblyItemState item;
  final VoidCallback onPrintTap;

  const _ComponentCard({required this.item, required this.onPrintTap});

  @override
  Widget build(BuildContext context) {
    // Tentukan Warna & Icon berdasarkan status
    Color bgColor = Colors.white;
    Color borderColor = Colors.grey.shade300;
    IconData statusIcon = Icons.circle_outlined;
    Color iconColor = Colors.grey;

    if (item.isScanned) {
      bgColor = Colors.green.shade50;
      borderColor = Colors.green.shade200;
      statusIcon = Icons.check_circle;
      iconColor = Colors.green;
    } else if (item.isPrinted) {
      bgColor = Colors.orange.shade50;
      borderColor = Colors.orange.shade200;
      statusIcon = Icons.access_time_filled; // Waiting for scan
      iconColor = Colors.orange;
    }

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(statusIcon, color: iconColor),
        ),
        title: Text(
          item.componentName,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: item.isScanned ? TextDecoration.lineThrough : null,
            color: item.isScanned ? Colors.grey : Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manuf: ${item.manufCode}',
              style: const TextStyle(fontSize: 12),
            ),
            if (item.qrValue != null)
              Text(
                item.qrValue!,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
          ],
        ),
        trailing: !item.isPrinted
            ? ElevatedButton.icon(
                icon: const Icon(Icons.print, size: 16),
                label: const Text('Cetak'),
                style: ElevatedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  backgroundColor: AppColors.primaryDark,
                  foregroundColor: Colors.white,
                ),
                onPressed: onPrintTap,
              )
            : item.isScanned
            ? const Icon(Icons.done_all, color: Colors.green)
            : const Chip(
                label: Text('Scan Box'),
                backgroundColor: Colors.orangeAccent,
                labelStyle: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mobile_scanner/mobile_scanner.dart'; // Pastikan package ini ada
// import '../../../../core/styles/color_scheme.dart'; // Sesuaikan import style Anda
// import '../bloc/assembly/assembly_cubit.dart';

// class AssemblyScreen extends StatefulWidget {
//   final String variantId;
//   final String variantName;
//   final String companyCode;
//   final String userId;

//   const AssemblyScreen({
//     super.key,
//     required this.variantId,
//     required this.variantName,
//     required this.companyCode,
//     required this.userId,
//   });

//   @override
//   State<AssemblyScreen> createState() => _AssemblyScreenState();
// }

// class _AssemblyScreenState extends State<AssemblyScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Load data komponen saat masuk screen
//     context.read<AssemblyCubit>().loadRequirements();
//   }

//   void _showScanner(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => AssemblyScannerModal(
//         cubit: context.read<AssemblyCubit>(), // Pass existing cubit instance
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<AssemblyCubit, AssemblyState>(
//       listener: (context, state) {
//         if (state.status == AssemblyStatus.failure) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(state.error ?? 'Terjadi kesalahan'),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
        
//         // Feedback visual saat scan berhasil/gagal
//         if (state.lastScanMessage != null) {
//           ScaffoldMessenger.of(context).hideCurrentSnackBar();
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(state.lastScanMessage!),
//               backgroundColor: state.lastScanMessage!.contains('❌') 
//                   ? Colors.red 
//                   : (state.lastScanMessage!.contains('⚠️') ? Colors.orange : Colors.green),
//               duration: const Duration(milliseconds: 1500),
//             ),
//           );
//         }

//         // Redirect jika sukses finalize set
//         if (state.status == AssemblyStatus.success) {
//           showDialog(
//             context: context,
//             barrierDismissible: false,
//             builder: (_) => AlertDialog(
//               title: const Text('🎉 Assembly Selesai'),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(Icons.check_circle, color: Colors.green, size: 60),
//                   const SizedBox(height: 16),
//                   Text('Unit Set berhasil dibuat:\n${state.parentSetQr}'),
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop(); // Close dialog
//                     Navigator.of(context).pop(); // Back to Detail Variant
//                   },
//                   child: const Text('Kembali'),
//                 ),
//               ],
//             ),
//           );
//         }
//       },
//       builder: (context, state) {
//         if (state.status == AssemblyStatus.loading) {
//           return const Scaffold(body: Center(child: CircularProgressIndicator()));
//         }

//         // Hitung progress
//         final total = state.components.length;
//         final scanned = state.components.where((c) => c.isScanned).length;
//         final isComplete = total > 0 && total == scanned;

//         return Scaffold(
//           backgroundColor: Colors.grey[50],
//           appBar: AppBar(
//             title: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text('Perakitan Set (Assembly)', style: TextStyle(fontSize: 16)),
//                 Text(
//                   widget.variantName,
//                   style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
//                 ),
//               ],
//             ),
//             actions: [
//               Center(
//                 child: Padding(
//                   padding: const EdgeInsets.only(right: 16.0),
//                   child: Text(
//                     '$scanned/$total',
//                     style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                 ),
//               )
//             ],
//           ),
//           body: Column(
//             children: [
//               // 1. Header Info / Instruction
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(12),
//                 color: Colors.blue.shade50,
//                 child: const Text(
//                   'Instruksi: Cetak label tiap komponen, tempel, lalu Scan untuk memverifikasi kelengkapan.',
//                   style: TextStyle(fontSize: 12, color: Colors.blue),
//                 ),
//               ),

//               // 2. List Components
//               Expanded(
//                 child: state.components.isEmpty
//                     ? const Center(child: Text('Tidak ada komponen In-Box'))
//                     : ListView.separated(
//                         padding: const EdgeInsets.all(12),
//                         itemCount: state.components.length,
//                         separatorBuilder: (_, __) => const SizedBox(height: 8),
//                         itemBuilder: (ctx, index) {
//                           final item = state.components[index];
//                           return _AssemblyComponentCard(
//                             item: item,
//                             onPrint: () {
//                               context.read<AssemblyCubit>().generateComponentLabel(
//                                     index,
//                                     widget.userId,
//                                     widget.companyCode,
//                                   );
//                             },
//                           );
//                         },
//                       ),
//               ),
//             ],
//           ),
          
//           // 3. Bottom Action Bar
//           bottomNavigationBar: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.1))],
//             ),
//             child: Row(
//               children: [
//                 // Tombol Scan (Selalu aktif kecuali loading/success)
//                 Expanded(
//                   flex: 1,
//                   child: OutlinedButton.icon(
//                     onPressed: state.status == AssemblyStatus.generating_set
//                         ? null
//                         : () => _showScanner(context),
//                     icon: const Icon(Icons.qr_code_scanner),
//                     label: const Text('Scan'),
//                     style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 // Tombol Selesai (Hanya aktif jika semua scanned)
//                 Expanded(
//                   flex: 2,
//                   child: ElevatedButton(
//                     onPressed: isComplete && state.status != AssemblyStatus.generating_set
//                         ? () {
//                             context.read<AssemblyCubit>().createFinalSet(widget.userId);
//                           }
//                         : null, // Disabled sampai lengkap
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: isComplete ? Colors.green : Colors.grey[300],
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                     ),
//                     child: state.status == AssemblyStatus.generating_set
//                         ? const SizedBox(
//                             height: 20, 
//                             width: 20, 
//                             child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
//                           )
//                         : const Text('Selesai & Gabungkan'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// /// Widget Card terpisah agar kode rapi
// class _AssemblyComponentCard extends StatelessWidget {
//   final AssemblyItemState item;
//   final VoidCallback onPrint;

//   const _AssemblyComponentCard({
//     required this.item,
//     required this.onPrint,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // Logic Warna & Icon Status
//     Color bgColor = Colors.white;
//     Color borderColor = Colors.grey.shade300;
//     IconData statusIcon = Icons.circle_outlined;
//     Color iconColor = Colors.grey;
//     String statusText = 'Pending';

//     if (item.isScanned) {
//       // Status: DONE
//       bgColor = Colors.green.shade50;
//       borderColor = Colors.green;
//       statusIcon = Icons.check_circle;
//       iconColor = Colors.green;
//       statusText = 'Tervalidasi';
//     } else if (item.isPrinted) {
//       // Status: Printed but not Scanned
//       bgColor = Colors.orange.shade50;
//       borderColor = Colors.orange.shade300;
//       statusIcon = Icons.print;
//       iconColor = Colors.orange.shade800;
//       statusText = 'Tercetak (Scan untuk validasi)';
//     }

//     return Container(
//       decoration: BoxDecoration(
//         color: bgColor,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: borderColor),
//       ),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         leading: Icon(statusIcon, color: iconColor, size: 32),
//         title: Text(
//           item.componentName,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Manuf: ${item.manufCode}'),
//             const SizedBox(height: 4),
//             Text(
//               statusText,
//               style: TextStyle(
//                 fontSize: 10,
//                 fontWeight: FontWeight.bold,
//                 color: iconColor,
//               ),
//             ),
//           ],
//         ),
//         trailing: !item.isScanned
//             ? ElevatedButton(
//                 onPressed: item.isPrinted ? null : onPrint, // Disable kalau sudah print
//                 style: ElevatedButton.styleFrom(
//                   visualDensity: VisualDensity.compact,
//                   backgroundColor: item.isPrinted ? Colors.grey : Colors.blue,
//                 ),
//                 child: Text(item.isPrinted ? 'Cetak Ulang' : 'Cetak'),
//               )
//             : const SizedBox.shrink(), // Kosong jika sudah scanned
//       ),
//     );
//   }
// }

// /// Scanner Modal khusus untuk Assembly
// class AssemblyScannerModal extends StatefulWidget {
//   final AssemblyCubit cubit;
//   const AssemblyScannerModal({required this.cubit, super.key});

//   @override
//   State<AssemblyScannerModal> createState() => _AssemblyScannerModalState();
// }

// class _AssemblyScannerModalState extends State<AssemblyScannerModal> {
//   late MobileScannerController controller;
//   bool isProcessing = false;

//   @override
//   void initState() {
//     super.initState();
//     controller = MobileScannerController(
//       detectionSpeed: DetectionSpeed.noDuplicates,
//       formats: [BarcodeFormat.qrCode],
//     );
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.6,
//       decoration: const BoxDecoration(
//         color: Colors.black,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: Column(
//         children: [
//           // Handle Bar
//           Container(
//             margin: const EdgeInsets.only(top: 12, bottom: 8),
//             width: 40,
//             height: 4,
//             decoration: BoxDecoration(
//               color: Colors.grey,
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//           const Text(
//             'Scan Label Komponen',
//             style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 10),
          
//           Expanded(
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: MobileScanner(
//                 controller: controller,
//                 onDetect: (capture) async {
//                   if (isProcessing) return;
//                   final barcodes = capture.barcodes;
//                   if (barcodes.isEmpty) return;
                  
//                   final raw = barcodes.first.rawValue;
//                   if (raw == null) return;

//                   setState(() => isProcessing = true);

//                   // Panggil Cubit logic
//                   await widget.cubit.onScanQr(raw);

//                   // Delay sedikit untuk UX (supaya gak spam scan)
//                   await Future.delayed(const Duration(milliseconds: 1000));
//                   if (mounted) setState(() => isProcessing = false);
//                 },
//               ),
//             ),
//           ),
          
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 IconButton(
//                   onPressed: () => controller.toggleTorch(),
//                   icon: const Icon(Icons.flash_on, color: Colors.white),
//                   tooltip: 'Flash',
//                 ),
//                 const SizedBox(width: 20),
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text('Tutup Scanner', style: TextStyle(color: Colors.white)),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }