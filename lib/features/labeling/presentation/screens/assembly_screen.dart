// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:inventory_sync_apps/core/styles/color_scheme.dart';

// import '../../data/labeling_repository.dart';
// import '../../data/models/assembly_result.dart';
// import '../../data/models/scan_unit_result.dart';
// import '../bloc/assembly/assembly_cubit.dart';
// import '../bloc/assembly/assembly_state.dart';

// class AssemblyScreen extends StatelessWidget {
//   final String variantId;
//   final String variantName;
//   final String userId;
//   final List<String> componentIds;

//   const AssemblyScreen({
//     super.key,
//     required this.variantId,
//     required this.componentIds,
//     required this.variantName,
//     required this.userId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (ctx) => AssemblyCubit(
//         labelingRepository: ctx.read<LabelingRepository>(),
//         variantId: variantId,
//         variantName: variantName,
//         componentIds: componentIds,
//         userId: userId,
//       ),
//       child: const _AssemblyView(),
//     );
//   }
// }

// class _AssemblyView extends StatefulWidget {
//   const _AssemblyView();

//   @override
//   State<_AssemblyView> createState() => _AssemblyViewState();
// }

// class _AssemblyViewState extends State<_AssemblyView> {
//   final _qrController = TextEditingController();
//   final _locationCtrl = TextEditingController();

//   @override
//   void dispose() {
//     _qrController.dispose();
//     _locationCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<AssemblyCubit, AssemblyState>(
//       listenWhen: (prev, curr) =>
//           curr is AssemblyReady && curr.errorMessage != null ||
//           curr is AssemblyError,
//       listener: (context, state) {
//         if (state is AssemblyReady && state.errorMessage != null) {
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
//         } else if (state is AssemblyError) {
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(SnackBar(content: Text(state.message)));
//         }
//       },
//       builder: (context, state) {
//         if (state is AssemblyReady) {
//           return Scaffold(
//             appBar: AppBar(
//               title: Text('Assembly — ${state.variantName}'),
//               backgroundColor: AppColors.primary,
//               foregroundColor: Colors.white,
//             ),
//             body: Stack(
//               children: [
//                 ListView(
//                   padding: const EdgeInsets.all(16),
//                   children: [
//                     _buildHeader(state),
//                     const SizedBox(height: 16),
//                     _buildScanSection(context, state),
//                     const SizedBox(height: 16),
//                     _buildAssembleSection(context, state),
//                   ],
//                 ),
//                 if (state.isSaving)
//                   Container(
//                     color: Colors.black26,
//                     child: const Center(child: CircularProgressIndicator()),
//                   ),
//               ],
//             ),
//           );
//         }

//         return const Scaffold(body: Center(child: CircularProgressIndicator()));
//       },
//     );
//   }

//   Widget _buildHeader(AssemblyReady s) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           s.variantName,
//           style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           'Satukan beberapa unit komponen menjadi 1 unit set.\n'
//           'Scan QR untuk setiap komponen yang menjadi bagian dari set ini.',
//           style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
//         ),
//       ],
//     );
//   }

//   Widget _buildScanSection(BuildContext context, AssemblyReady s) {
//     final cubit = context.read<AssemblyCubit>();
//     final total = s.requiredComponentIds.length;
//     final scannedCount = s.scannedByComponentId.length;

//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Scan Komponen',
//               style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Sudah discan: $scannedCount / $total komponen',
//               style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
//             ),
//             const SizedBox(height: 12),

//             // List status komponen
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: s.requiredComponentIds.length,
//               itemBuilder: (context, index) {
//                 final compId = s.requiredComponentIds[index];
//                 final scanned = s.scannedByComponentId[compId];

//                 // Kalau unit hasil scan punya componentName, pakai itu
//                 final title =
//                     scanned?.componentName != null &&
//                         scanned!.componentName!.isNotEmpty
//                     ? scanned.componentName!
//                     : 'Komponen ${index + 1}';

//                 final subtitle = scanned != null
//                     ? 'QR: ${scanned.qrValue}'
//                     : 'Belum discan';

//                 final color = scanned != null
//                     ? Colors.green.shade600
//                     : Colors.grey.shade500;

//                 return ListTile(
//                   contentPadding: EdgeInsets.zero,
//                   leading: Icon(
//                     scanned != null
//                         ? Icons.check_circle
//                         : Icons.radio_button_unchecked,
//                     color: color,
//                   ),
//                   title: Text(title, style: const TextStyle(fontSize: 14)),
//                   subtitle: Text(
//                     subtitle,
//                     style: const TextStyle(fontSize: 12),
//                   ),
//                 );
//               },
//             ),

//             const SizedBox(height: 16),

//             // Input QR (sementara, nanti ganti scanner beneran)
//             TextField(
//               controller: _qrController,
//               decoration: InputDecoration(
//                 labelText: 'QR komponen',
//                 hintText: 'Tempel hasil scan QR di sini',
//                 border: const OutlineInputBorder(),
//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.qr_code_scanner),
//                   onPressed: () async {
//                     final qr = _qrController.text.trim();
//                     if (qr.isNotEmpty) {
//                       await cubit.scanComponent(qr);
//                       _qrController.clear();
//                     }
//                   },
//                 ),
//               ),
//               onSubmitted: (value) async {
//                 final qr = value.trim();
//                 if (qr.isNotEmpty) {
//                   await cubit.scanComponent(qr);
//                   _qrController.clear();
//                 }
//               },
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Scan satu per satu QR komponen sampai semua berstatus hijau.',
//               style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAssembleSection(BuildContext context, AssemblyReady s) {
//     final cubit = context.read<AssemblyCubit>();

//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Assembly',
//               style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: _locationCtrl,
//               decoration: const InputDecoration(
//                 labelText: 'Lokasi set (opsional)',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 12),
//             SizedBox(
//               width: double.infinity,
//               child: FilledButton(
//                 style: FilledButton.styleFrom(
//                   backgroundColor: s.canAssemble
//                       ? AppColors.secondary
//                       : Colors.grey.shade400,
//                   foregroundColor: s.canAssemble ? Colors.black : Colors.white,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 12,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 onPressed: s.canAssemble
//                     ? () async {
//                         await cubit.assemble(
//                           location: _locationCtrl.text.trim().isEmpty
//                               ? null
//                               : _locationCtrl.text.trim(),
//                         );
//                       }
//                     : null,
//                 child: Text(
//                   s.canAssemble
//                       ? 'Generate Unit Set'
//                       : 'Scan semua komponen dulu',
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             if (s.assemblyResult != null)
//               _buildAssemblyResult(s.assemblyResult!),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAssemblyResult(AssemblyResult result) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.green.shade50,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Assembly Berhasil',
//             style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             'QR unit set: ${result.parentQrValue}',
//             style: const TextStyle(fontSize: 12),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             'Komponen terikat: ${result.boundComponentUnitIds.length} unit',
//             style: const TextStyle(fontSize: 12),
//           ),
//           const SizedBox(height: 4),
//           const Text(
//             'Tempel QR ini ke barang set (cone+cup) setelah disatukan.',
//             style: TextStyle(fontSize: 12),
//           ),
//         ],
//       ),
//     );
//   }
// }
