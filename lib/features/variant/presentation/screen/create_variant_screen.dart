import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../shared/models/selected_brand_result.dart';
import '../../../../shared/models/selected_rack_result.dart';
import '../../../../shared/presentation/screen/brand_picker_screen.dart';
import '../../../../shared/presentation/screen/rack_picker_screen.dart';
import '../bloc/create_variant/create_variant_cubit.dart';

class CreateVariantScreen extends StatelessWidget {
  final String companyItemId;
  final String userId;
  final String? defaultRackId;

  const CreateVariantScreen({
    super.key,
    required this.companyItemId,
    required this.userId,
    this.defaultRackId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateVariantCubit(
        labelingRepository: context.read(),
        companyItemId: companyItemId,
        userId: userId,
        defaultRackId: defaultRackId,
      ),
      child: BlocConsumer<CreateVariantCubit, CreateVariantState>(
        listener: (context, state) {
          if (state.status == CreateVariantStatus.success) {
            Navigator.of(context).pop(true); // kembali ke company item detail
          }
        },
        builder: (context, state) {
          final cubit = context.read<CreateVariantCubit>();

          return Scaffold(
            appBar: AppBar(title: const Text("Create Variant")),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // RACK SELECT
                  Text("Lokasi", style: TextStyle(fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RackPickerScreen(),
                        ),
                      );

                      String name =
                          '${result?.name ?? ""} - ${result?.departmentName ?? ""} / ${result?.sectionName ?? ""} / ${result?.warehouseName ?? ""}';

                      if (result is SelectedRackResult) {
                        cubit.setRack(result.id, name);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(state.rackName ?? "Pilih Lokasi"),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // BRAND SELECT
                  Text(
                    "Brand (Opsional)",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BrandPickerScreen(),
                        ),
                      );

                      if (result is SelectedBrandResult) {
                        cubit.setBrand(result.id, result.name);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(state.brandName ?? "Tanpa Brand"),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // NAME
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "Variant Name",
                    ),
                    onChanged: cubit.setName,
                  ),
                  const SizedBox(height: 16),

                  // UOM
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: "Satuan UOM"),
                    value: state.uom,
                    items:
                        const [
                              "pcs",
                              "box",
                              "unit",
                              "set",
                              "kg",
                              "roll",
                              "meter",
                              "pack",
                            ]
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                    onChanged: (v) => cubit.setUom(v!),
                  ),
                  const SizedBox(height: 16),

                  // SPEC
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "Kode Manufaktur (opsional)",
                    ),
                    minLines: 2,
                    maxLines: 4,
                    onChanged: cubit.setManufCode,
                  ),
                  const SizedBox(height: 16),

                  // SPEC
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "Spesifikasi (opsional)",
                    ),
                    minLines: 2,
                    maxLines: 4,
                    onChanged: cubit.setSpecification,
                  ),
                  const SizedBox(height: 16),

                  // PHOTOS
                  Text(
                    "Foto (min 3, maks 5)",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...List.generate(state.photos.length, (i) {
                        return Stack(
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: FileImage(File(state.photos[i])),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              right: -8,
                              top: -8,
                              child: IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                onPressed: () => cubit.removePhoto(i),
                              ),
                            ),
                          ],
                        );
                      }),
                      if (state.photos.length < 5)
                        GestureDetector(
                          onTap: () => _showAddPhotoMenu(context, cubit),
                          child: Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.add_a_photo_rounded,
                              size: 32,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // SUBMIT
                  ElevatedButton(
                    onPressed: state.status == CreateVariantStatus.loading
                        ? null
                        : cubit.canSubmit
                        ? cubit.submit
                        : null,
                    child: state.status == CreateVariantStatus.loading
                        ? const CircularProgressIndicator()
                        : const Text("Simpan Variant"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddPhotoMenu(BuildContext context, CreateVariantCubit cubit) {
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: const Text("Tambah Foto"),
        actions: [
          CupertinoActionSheetAction(
            child: const Text("Kamera"),
            onPressed: () {
              Navigator.pop(ctx);
              cubit.addPhoto(ImageSource.camera);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text("Galeri"),
            onPressed: () {
              Navigator.pop(ctx);
              cubit.addPhoto(ImageSource.gallery);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          child: const Text("Batal"),
          onPressed: () => Navigator.pop(ctx),
        ),
      ),
    );
  }
}
