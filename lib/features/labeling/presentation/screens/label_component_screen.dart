// // lib/features/labeling/presentation/screens/label_component_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:inventory_sync_apps/core/styles/color_scheme.dart';

// import '../bloc/label_component/label_component_cubit.dart';
// import '../bloc/label_component/label_component_state.dart';

// class LabelComponentScreen extends StatelessWidget {
//   final String variantId;
//   final String variantName;
//   final String componentId;
//   final String componentName;
//   final String? defaultLocation;
//   final String userId;

//   const LabelComponentScreen({
//     super.key,
//     required this.variantId,
//     required this.variantName,
//     required this.componentId,
//     required this.componentName,
//     this.defaultLocation,
//     required this.userId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (ctx) => LabelComponentCubit(
//         labelingRepository: ctx.read(),
//         variantId: variantId,
//         variantName: variantName,
//         componentId: componentId,
//         componentName: componentName,
//         defaultLocation: defaultLocation,
//         userId: userId,
//       ),
//       child: const _LabelComponentView(),
//     );
//   }
// }

// class _LabelComponentView extends StatefulWidget {
//   const _LabelComponentView();

//   @override
//   State<_LabelComponentView> createState() => _LabelComponentViewState();
// }

// class _LabelComponentViewState extends State<_LabelComponentView> {
//   final _qtyCtrl = TextEditingController(text: '1');
//   final _locationCtrl = TextEditingController();

//   @override
//   void dispose() {
//     _qtyCtrl.dispose();
//     _locationCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<LabelComponentCubit, LabelComponentState>(
//       listenWhen: (prev, curr) =>
//           curr is LabelComponentSuccess || curr is LabelComponentError,
//       listener: (context, state) {
//         if (state is LabelComponentError) {
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(SnackBar(content: Text(state.message)));
//         } else if (state is LabelComponentSuccess) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                 'Berhasil membuat ${state.generatedCount} label komponen',
//               ),
//             ),
//           );
//           // kalau mau langsung pop ke detail variant:
//           Navigator.of(context).pop(true);
//         }
//       },
//       builder: (context, state) {
//         if (state is LabelComponentReady) {
//           // sync text field dengan state (sekali per build)
//           _qtyCtrl.text = state.quantity.toString();
//           _locationCtrl.text = state.location ?? state.defaultLocation ?? '';

//           return Scaffold(
//             appBar: AppBar(
//               title: Text('Label Komponen — ${state.componentName}'),
//               backgroundColor: AppColors.secondary,
//               foregroundColor: Colors.white,
//             ),
//             body: Stack(
//               children: [
//                 ListView(
//                   padding: const EdgeInsets.all(16),
//                   children: [
//                     _buildHeader(state),
//                     const SizedBox(height: 16),
//                     _buildForm(context, state),
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
//         } else if (state is LabelComponentInitial) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }
//         // Success/Error sudah di-handle oleh listener → bisa tampilkan kosong
//         return const Scaffold(body: SizedBox.shrink());
//       },
//     );
//   }

//   Widget _buildHeader(LabelComponentReady s) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           s.variantName,
//           style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           'Komponen: ${s.componentName}',
//           style: const TextStyle(fontSize: 14),
//         ),
//         const SizedBox(height: 4),
//         if (s.defaultLocation != null)
//           Text(
//             'Lokasi default: ${s.defaultLocation}',
//             style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
//           ),
//       ],
//     );
//   }

//   Widget _buildForm(BuildContext context, LabelComponentReady s) {
//     final cubit = context.read<LabelComponentCubit>();

//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Jumlah & Lokasi',
//               style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
//             ),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _qtyCtrl,
//                     decoration: const InputDecoration(
//                       labelText: 'Jumlah unit',
//                       border: OutlineInputBorder(),
//                     ),
//                     keyboardType: TextInputType.number,
//                     onChanged: (v) {
//                       final val = int.tryParse(v) ?? 1;
//                       cubit.changeQuantity(val);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: _locationCtrl,
//               decoration: const InputDecoration(
//                 labelText: 'Lokasi (opsional)',
//                 border: OutlineInputBorder(),
//               ),
//               onChanged: (v) => cubit.changeLocation(v),
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: FilledButton(
//                 style: FilledButton.styleFrom(
//                   backgroundColor: AppColors.secondary,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 12,
//                   ),
//                 ),
//                 onPressed: s.isSaving ? null : () => cubit.submit(),
//                 child: const Text(
//                   'Generate & Simpan Label',
//                   style: TextStyle(color: Colors.black),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
