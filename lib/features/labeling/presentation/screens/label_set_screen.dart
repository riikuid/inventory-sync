// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:inventory_sync_apps/core/styles/color_scheme.dart';
// import 'package:pretty_qr_code/pretty_qr_code.dart';

// import '../bloc/label_set/label_set_state.dart';
// import '../bloc/label_set/label_state_cubit.dart';

// class LabelSetScreen extends StatelessWidget {
//   const LabelSetScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<LabelSetCubit, LabelSetState>(
//       listenWhen: (prev, curr) =>
//           prev.errorMessage != curr.errorMessage ||
//           prev.isSuccess != curr.isSuccess,
//       listener: (context, state) {
//         if (state.errorMessage != null) {
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
//         }
//         if (state.isSuccess) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Unit berhasil disimpan (offline)')),
//           );
//           Navigator.of(context).pop(); // kembali ke detail
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Label as Set'),
//           backgroundColor: AppColors.secondary,
//           foregroundColor: Colors.white,
//         ),
//         body: const Padding(
//           padding: EdgeInsets.all(16),
//           child: _LabelSetBody(),
//         ),
//       ),
//     );
//   }
// }

// class _LabelSetBody extends StatelessWidget {
//   const _LabelSetBody();

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LabelSetCubit, LabelSetState>(
//       builder: (context, state) {
//         return Column(
//           children: [
//             _buildVariantInfo(state),
//             const SizedBox(height: 16),
//             _buildQrSection(context, state),
//             const Spacer(),
//             _buildBottomButtons(context, state),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildVariantInfo(LabelSetState state) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           children: [
//             Icon(Icons.widgets_outlined, color: AppColors.secondary, size: 28),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     state.variantName ?? 'Variant',
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 16,
//                     ),
//                   ),
//                   if (state.brandName != null) ...[
//                     const SizedBox(height: 4),
//                     Text(
//                       state.brandName!,
//                       style: TextStyle(
//                         color: Colors.grey.shade700,
//                         fontSize: 13,
//                       ),
//                     ),
//                   ],
//                   if (state.defaultLocation != null) ...[
//                     const SizedBox(height: 4),
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.location_on_outlined,
//                           size: 14,
//                           color: Colors.grey.shade600,
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           state.defaultLocation!,
//                           style: TextStyle(
//                             color: Colors.grey.shade700,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildQrSection(BuildContext context, LabelSetState state) {
//     if (!state.isGenerated || state.qrValue == null) {
//       return Expanded(
//         child: Center(
//           child: Text(
//             'Belum ada QR.\nTap "Generate QR" di bawah untuk membuat kode unik.',
//             textAlign: TextAlign.center,
//             style: TextStyle(color: Colors.grey.shade700),
//           ),
//         ),
//       );
//     }

//     return Expanded(
//       child: Column(
//         children: [
//           Card(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             elevation: 2,
//             child: Container(
//               width: 220,
//               height: 220,
//               alignment: Alignment.center,
//               padding: const EdgeInsets.all(16),
//               // Di sini nanti kamu bisa ganti pakai qr_flutter
//               child: PrettyQrView.data(
//                 data: state.qrValue!,
//                 decoration: const PrettyQrDecoration(
//                   // image: PrettyQrDecorationImage(
//                   //   image: AssetImage('images/flutter.png'),
//                   // ),
//                   quietZone: PrettyQrQuietZone.standart,
//                 ),
//               ),
//               // child: Text(
//               //   state.qrValue!,
//               //   textAlign: TextAlign.center,
//               //   style: const TextStyle(fontSize: 12),
//               // ),
//             ),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 state.isScanConfirmed
//                     ? Icons.check_circle
//                     : Icons.radio_button_unchecked,
//                 color: state.isScanConfirmed
//                     ? Colors.green
//                     : Colors.grey.shade500,
//                 size: 18,
//               ),
//               const SizedBox(width: 6),
//               Text(
//                 state.isScanConfirmed
//                     ? 'QR sudah dikonfirmasi'
//                     : 'Menunggu konfirmasi scan',
//                 style: TextStyle(
//                   fontSize: 13,
//                   color: state.isScanConfirmed
//                       ? Colors.green
//                       : Colors.grey.shade700,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBottomButtons(BuildContext context, LabelSetState state) {
//     final cubit = context.read<LabelSetCubit>();

//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         if (!state.isGenerated) ...[
//           SizedBox(
//             width: double.infinity,
//             child: FilledButton(
//               style: FilledButton.styleFrom(
//                 backgroundColor: AppColors.secondary,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 12,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               onPressed: () => cubit.generateQr(),
//               child: const Text(
//                 'Generate QR Code',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//         ] else ...[
//           SizedBox(
//             width: double.infinity,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton.icon(
//                     icon: const Icon(Icons.print),
//                     label: const Text('Cetak QR'),
//                     style: OutlinedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 12,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     onPressed: () async {
//                       // TODO: Integrasikan dengan library scanner beneran (mobile_scanner, qr_code_scanner, dll)
//                       // sementara untuk testing bisa manual:
//                       // final scanned = await _mockScanDialog(
//                       //   context,
//                       //   state.qrValue,
//                       // );
//                       // if (scanned != null) {
//                       //   cubit.confirmScan(scanned);
//                       // }
//                     },
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: OutlinedButton.icon(
//                     icon: const Icon(Icons.qr_code_scanner),
//                     label: const Text('Scan & Confirm'),
//                     style: OutlinedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 12,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     onPressed: () async {
//                       // TODO: Integrasikan dengan library scanner beneran (mobile_scanner, qr_code_scanner, dll)
//                       // sementara untuk testing bisa manual:
//                       final scanned = await _mockScanDialog(
//                         context,
//                         state.qrValue,
//                       );
//                       if (scanned != null) {
//                         cubit.confirmScan(scanned);
//                       }
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 8),
//           SizedBox(
//             width: double.infinity,
//             child: FilledButton(
//               style: FilledButton.styleFrom(
//                 backgroundColor: state.isScanConfirmed
//                     ? AppColors.secondary
//                     : Colors.grey.shade400,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 12,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               onPressed: (state.isScanConfirmed && !state.isSaving)
//                   ? () => cubit.saveUnit()
//                   : null,
//               child: state.isSaving
//                   ? const SizedBox(
//                       width: 18,
//                       height: 18,
//                       child: CircularProgressIndicator(strokeWidth: 2),
//                     )
//                   : const Text(
//                       'Simpan Unit',
//                       style: TextStyle(color: Colors.black),
//                     ),
//             ),
//           ),
//         ],
//       ],
//     );
//   }

//   Future<String?> _mockScanDialog(
//     BuildContext context,
//     String? expected,
//   ) async {
//     final controller = TextEditingController(text: expected ?? '');
//     return showDialog<String?>(
//       context: context,
//       builder: (ctx) {
//         return AlertDialog(
//           title: const Text('Mock Scan QR'),
//           content: TextField(
//             controller: controller,
//             decoration: const InputDecoration(labelText: 'Scanned QR value'),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(ctx).pop(null),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () => Navigator.of(ctx).pop(controller.text),
//               child: const Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
