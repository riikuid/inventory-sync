// // lib/features/labeling/presentation/screens/setup_company_item_screen.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:inventory_sync_apps/core/styles/color_scheme.dart';

// import '../../../inventory/presentation/widget/dotted_border_container.dart';
// import '../bloc/setup_company_item/setup_company_item_cubit.dart';

// class SetupCompanyItemScreen extends StatelessWidget {
//   final String companyItemId;
//   final String productId;
//   final String userId;

//   const SetupCompanyItemScreen({
//     super.key,
//     required this.companyItemId,
//     required this.productId,
//     required this.userId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<SetupCompanyItemCubit, SetupCompanyItemState>(
//       listenWhen: (prev, curr) =>
//           prev is! SetupCompanyItemError && curr is SetupCompanyItemError ||
//           curr is SetupCompanyItemSuccess,
//       listener: (context, state) {
//         if (state is SetupCompanyItemError) {
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(SnackBar(content: Text(state.message)));
//         } else if (state is SetupCompanyItemSuccess) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Setup berhasil disimpan')),
//           );
//           Navigator.of(context).pop(true); // return true ke detail
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Setup Company Item'),
//           backgroundColor: AppColors.secondary,
//           foregroundColor: Colors.white,
//         ),
//         body: const _SetupBody(),
//       ),
//     );
//   }
// }

// class _SetupBody extends StatefulWidget {
//   const _SetupBody();

//   @override
//   State<_SetupBody> createState() => _SetupBodyState();
// }

// class _SetupBodyState extends State<_SetupBody> {
//   final _variantNameCtrl = TextEditingController();
//   final _locationCtrl = TextEditingController();
//   final _specCtrl = TextEditingController();

//   @override
//   void dispose() {
//     _variantNameCtrl.dispose();
//     _locationCtrl.dispose();
//     _specCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<SetupCompanyItemCubit, SetupCompanyItemState>(
//       builder: (context, state) {
//         if (state is SetupCompanyItemLoading ||
//             state is SetupCompanyItemInitial) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (state is SetupCompanyItemError) {
//           return Center(child: Text('Error: ${state.message}'));
//         }
//         if (state is SetupCompanyItemSuccess) {
//           // body kosong, karena navigator sudah dipop di BlocListener
//           return const SizedBox.shrink();
//         }

//         // Di titik ini kita expect Loaded
//         if (state is! SetupCompanyItemLoaded) {
//           return const SizedBox.shrink();
//         }

//         final loaded = state;
//         final isSaving = state.isSaving;

//         // sinkronkan text field (sekali di awal)
//         _variantNameCtrl.text = loaded.variantName;
//         _locationCtrl.text = loaded.defaultLocation ?? '';
//         _specCtrl.text = loaded.specJson ?? '';

//         return AbsorbPointer(
//           absorbing: isSaving,
//           child: Stack(
//             children: [
//               ListView(
//                 padding: const EdgeInsets.all(16),
//                 children: [
//                   _buildHeader(loaded),
//                   const SizedBox(height: 12),

//                   if (loaded.canEditType) ...[
//                     _buildTypeSection(context, loaded),
//                     const SizedBox(height: 16),
//                   ],

//                   _buildVariantSection(context, loaded),
//                   const SizedBox(height: 16),
//                   _buildPhotoSection(context, loaded),
//                   const SizedBox(height: 24),
//                   _buildSaveButton(context, loaded, isSaving),
//                   const SizedBox(height: 16),
//                 ],
//               ),
//               if (isSaving)
//                 Container(
//                   color: Colors.black26,
//                   child: const Center(child: CircularProgressIndicator()),
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildHeader(SetupCompanyItemLoaded state) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           '${state.companyCode} — ${state.productName}',
//           style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           'Set tipe item dan variant awal untuk kode ini.',
//           style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
//         ),
//       ],
//     );
//   }

//   Widget _buildTypeSection(BuildContext context, SetupCompanyItemLoaded state) {
//     final cubit = context.read<SetupCompanyItemCubit>();

//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Tipe Item',
//               style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Expanded(
//                   child: RadioListTile<bool>(
//                     value: false,
//                     groupValue: state.isSet,
//                     title: const Text('Single (tanpa set)'),
//                     onChanged: (val) {
//                       if (val == null) return;
//                       cubit.updateIsSet(val);
//                       cubit.updateHasComponents(false);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: RadioListTile<bool>(
//                     value: true,
//                     groupValue: state.isSet,
//                     title: const Text('Set (punya beberapa komponen)'),
//                     onChanged: (val) {
//                       if (val == null) return;
//                       cubit.updateIsSet(val);
//                       cubit.updateHasComponents(true);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Contoh set: bearing dengan cone + cup.\nSingle: air mineral, bolpoin.',
//               style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildVariantSection(
//     BuildContext context,
//     SetupCompanyItemLoaded state,
//   ) {
//     final cubit = context.read<SetupCompanyItemCubit>();

//     final selectedBrandName = state.brandName ?? 'Pilih brand';

//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Daftarkan Varian',
//               style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
//             ),
//             const SizedBox(height: 12),

//             // BRAND PICKER
//             InkWell(
//               onTap: () async {
//                 final selected = await _showBrandPicker(
//                   context,
//                   state.brands,
//                   state.brandId,
//                   state.usedBrandIds,
//                 );
//                 if (selected != null) {
//                   cubit.onBrandSelected(selected);
//                 }
//               },
//               child: InputDecorator(
//                 decoration: const InputDecoration(
//                   labelText: 'Brand',
//                   border: OutlineInputBorder(),
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         selectedBrandName,
//                         style: TextStyle(
//                           color: state.brandId == null
//                               ? Colors.grey.shade500
//                               : Colors.black,
//                         ),
//                       ),
//                     ),
//                     const Icon(Icons.arrow_drop_down),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 12),

//             // NAMA VARIANT
//             TextField(
//               controller: _variantNameCtrl,
//               decoration: const InputDecoration(
//                 labelText: 'Nama variant',
//                 hintText: 'contoh: 043 Bearing Timken',
//                 border: OutlineInputBorder(),
//               ),
//               onChanged: cubit.updateVariantName,
//             ),
//             const SizedBox(height: 12),

//             // LOKASI
//             TextField(
//               controller: _locationCtrl,
//               decoration: const InputDecoration(
//                 labelText: 'Lokasi default (opsional)',
//                 hintText: 'contoh: RAK-A1',
//                 border: OutlineInputBorder(),
//               ),
//               onChanged: (v) => cubit.updateLocation(v.isEmpty ? null : v),
//             ),
//             const SizedBox(height: 12),

//             // SPEK
//             TextField(
//               controller: _specCtrl,
//               maxLines: 3,
//               decoration: const InputDecoration(
//                 labelText: 'Spek teknis singkat (opsional)',
//                 hintText: 'contoh: ID 20mm, OD 50mm',
//                 border: OutlineInputBorder(),
//               ),
//               onChanged: (v) => cubit.updateSpecJson(v.isEmpty ? null : v),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPhotoSection(
//     BuildContext context,
//     SetupCompanyItemLoaded state,
//   ) {
//     final cubit = context.read<SetupCompanyItemCubit>();
//     final photos = state.photoLocalPaths;

//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Foto Produk (minimal 3)',
//               style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Ambil foto dari beberapa sudut berbeda untuk memudahkan identifikasi.',
//               style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
//             ),
//             const SizedBox(height: 12),
//             GridView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: photos.length + 1,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3,
//                 mainAxisSpacing: 8,
//                 crossAxisSpacing: 8,
//               ),
//               itemBuilder: (context, index) {
//                 if (index == photos.length) {
//                   return _buildAddPhotoTile(context, cubit);
//                 }
//                 final path = photos[index];
//                 return Stack(
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         color: Colors.grey.shade200,
//                       ),
//                       alignment: Alignment.center,
//                       child: Text(
//                         'Foto ${index + 1}',
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(fontSize: 12),
//                       ),
//                       // TODO: nanti ganti pakai Image.file(File(path))
//                     ),
//                     Positioned(
//                       top: 4,
//                       right: 4,
//                       child: InkWell(
//                         onTap: () => cubit.removePhotoAt(index),
//                         child: Container(
//                           decoration: const BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.black54,
//                           ),
//                           padding: const EdgeInsets.all(2),
//                           child: const Icon(
//                             Icons.close,
//                             size: 14,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAddPhotoTile(BuildContext context, SetupCompanyItemCubit cubit) {
//     return InkWell(
//       onTap: () async {
//         // TODO: ganti dengan image_picker. Untuk sekarang mock:
//         final path = 'mock/path/${DateTime.now().millisecondsSinceEpoch}.jpg';
//         cubit.addPhoto(path);
//       },
//       child: DottedBorderContainer(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: const [
//             Icon(Icons.add_a_photo_outlined),
//             SizedBox(height: 4),
//             Text('Tambah', style: TextStyle(fontSize: 12)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSaveButton(
//     BuildContext context,
//     SetupCompanyItemLoaded state,
//     bool isSaving,
//   ) {
//     final cubit = context.read<SetupCompanyItemCubit>();

//     return SizedBox(
//       width: double.infinity,
//       child: FilledButton(
//         style: FilledButton.styleFrom(
//           backgroundColor: AppColors.secondary,
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//         onPressed: isSaving
//             ? null
//             : () {
//                 final parent = context
//                     .findAncestorWidgetOfExactType<SetupCompanyItemScreen>();
//                 if (parent == null) return;
//                 cubit.submit(
//                   userId: parent.userId,
//                   productId: parent.productId,
//                 );
//               },
//         child: isSaving
//             ? const SizedBox(
//                 width: 18,
//                 height: 18,
//                 child: CircularProgressIndicator(strokeWidth: 2),
//               )
//             : const Text('Simpan Setup', style: TextStyle(color: Colors.black)),
//       ),
//     );
//   }

//   Future<BrandOption?> _showBrandPicker(
//     BuildContext context,
//     List<BrandOption> brands,
//     String? currentId,
//     List<String> usedBrandIds, // ⬅️ tambahan
//   ) async {
//     final controller = TextEditingController();

//     return showModalBottomSheet<BrandOption>(
//       context: context,
//       isScrollControlled: true,
//       builder: (ctx) {
//         List<BrandOption> filtered = List.from(brands);

//         void applyFilter(String query) {
//           filtered = brands
//               .where((b) => b.name.toLowerCase().contains(query.toLowerCase()))
//               .toList();
//         }

//         applyFilter('');

//         return StatefulBuilder(
//           builder: (ctx, setState) {
//             return Padding(
//               padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(ctx).viewInsets.bottom,
//               ),
//               child: SizedBox(
//                 height: 400,
//                 child: Column(
//                   children: [
//                     const Padding(
//                       padding: EdgeInsets.all(12),
//                       child: Text(
//                         'Pilih Brand',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 8,
//                       ),
//                       child: TextField(
//                         controller: controller,
//                         decoration: const InputDecoration(
//                           prefixIcon: Icon(Icons.search),
//                           hintText: 'Cari brand...',
//                           border: OutlineInputBorder(),
//                         ),
//                         onChanged: (value) {
//                           setState(() {
//                             applyFilter(value);
//                           });
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Expanded(
//                       child: ListView.builder(
//                         itemCount: filtered.length,
//                         itemBuilder: (ctx, index) {
//                           final b = filtered[index];
//                           final isCurrent = b.id == currentId;
//                           final isUsed =
//                               usedBrandIds.contains(b.id) && !isCurrent;

//                           return ListTile(
//                             enabled: !isUsed,
//                             title: Text(
//                               b.name,
//                               style: TextStyle(
//                                 color: isUsed ? Colors.grey : Colors.black,
//                               ),
//                             ),
//                             subtitle: isUsed
//                                 ? const Text(
//                                     'Sudah dipakai variant lain',
//                                     style: TextStyle(
//                                       fontSize: 11,
//                                       color: Colors.grey,
//                                     ),
//                                   )
//                                 : null,
//                             trailing: isCurrent
//                                 ? const Icon(Icons.check, color: Colors.green)
//                                 : null,
//                             onTap: isUsed
//                                 ? null
//                                 : () {
//                                     Navigator.of(ctx).pop(b);
//                                   },
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
