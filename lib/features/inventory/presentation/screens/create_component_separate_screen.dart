// create_variant_screen.dart (relevant parts)
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventory_sync_apps/core/utils/custom_back_button.dart';
import '../../../../core/constant.dart';
import '../../../../core/db/daos/variant_dao.dart';
import '../../../../core/db/model/variant_detail_row.dart';
import '../../../../core/styles/text_theme.dart';
import '../../data/model/component_request.dart';
import '../../../../core/styles/app_style.dart';
import '../../../../core/styles/color_scheme.dart';
import '../../../../shared/presentation/widgets/primary_button.dart';
import '../../../../shared/presentation/widgets/text_field_widget.dart';

class CreateComponentSeparateScreen extends StatefulWidget {
  final VariantDetailRow variantDetailRow;

  const CreateComponentSeparateScreen({
    super.key,
    required this.variantDetailRow,
  });

  @override
  State<CreateComponentSeparateScreen> createState() =>
      _CreateComponentSeparateScreenState();
}

class _CreateComponentSeparateScreenState
    extends State<CreateComponentSeparateScreen> {
  final ImagePicker _picker = ImagePicker();

  late final TextEditingController _nameController;
  late final TextEditingController _codeController;
  late final TextEditingController _specController;

  // Local photo state: menyimpan path file lokal
  final List<String> _photos = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _codeController = TextEditingController();
    _specController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _specController.dispose();
    super.dispose();
  }

  // Fungsi menambah foto
  Future<void> _addPhoto(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85, // mengurangi ukuran file
      );
      if (picked == null) return;
      // Simpan path langsung (opsional: salin ke app dir jika perlu)
      setState(() {
        _photos.add(picked.path);
      });
    } catch (e) {
      // handle error ringan
      debugPrint('Error picking image: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengambil foto')));
    }
  }

  void _removePhoto(int index) {
    if (index < 0 || index >= _photos.length) return;
    setState(() => _photos.removeAt(index));
  }

  void _showAddPhotoMenu(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: const Text("Tambah Foto"),
        actions: [
          CupertinoActionSheetAction(
            child: const Text("Kamera"),
            onPressed: () {
              Navigator.pop(ctx);
              _addPhoto(ImageSource.camera);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text("Galeri"),
            onPressed: () {
              Navigator.pop(ctx);
              _addPhoto(ImageSource.gallery);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.onSurface),
        leading: CustomBackButton(),
        backgroundColor: AppColors.background,
        elevation: 0.5,
        toolbarHeight: 60,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tambah Komponen',
              style: TextStyle(
                color: AppColors.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3),
            Text(
              '${widget.variantDetailRow.companyCode} • ${widget.variantDetailRow.name}',
              style: AppTextStyles.mono.copyWith(
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border(top: BorderSide(width: 0.3, color: AppColors.accent)),
        ),
        child: CustomButton(
          elevation: 0,
          radius: 40,
          height: 50,
          color: AppColors.primary,
          onPressed: () {
            // Validasi sederhana: pastikan minimal 1 foto & nama ada (ubah sesuai kebutuhan)
            if (_nameController.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Nama komponen wajib diisi')),
              );
              return;
            }
            if (_photos.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tambahkan minimal 1 foto')),
              );
              return;
            }

            final result = ComponentRequest(
              name: _nameController.text.trim(),
              type: separateType,
              manufCode: _codeController.text.trim(),
              specification: _specController.text.trim(),
              pathPhotos: List<String>.from(_photos),
            );

            Navigator.of(context).pop(result);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.save_outlined, color: AppColors.surface),
              SizedBox(width: 8),
              Text(
                'Simpan Komponen',
                style: TextStyle(
                  color: AppColors.surface,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(30),
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Icon(
                    Icons.layers_outlined,
                    size: 28,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      spacing: 2,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Komponen Box Terpisah',
                          style: TextStyle(
                            color: AppColors.onSurface,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Komponen dengan box/kemasan terpisah',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  'Foto Komponen',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                Text(
                  ' *',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                SizedBox(width: 5),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...List.generate(_photos.length, (i) {
                  return Stack(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: FileImage(File(_photos[i])),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: -8,
                        top: -8,
                        child: IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () => _removePhoto(i),
                        ),
                      ),
                    ],
                  );
                }),
                if (_photos.length < 5)
                  DottedBorder(
                    options: RoundedRectDottedBorderOptions(
                      radius: Radius.circular(15),
                      dashPattern: [10, 5],
                      strokeWidth: 2,
                      color: AppColors.border,
                    ),
                    child: GestureDetector(
                      onTap: () => _showAddPhotoMenu(context),
                      child: Container(
                        width: 90,
                        height: 90,
                        color: Colors.transparent,
                        child: const Icon(
                          Icons.add_a_photo_outlined,
                          size: 32,
                          color: AppColors.border,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16),
            Divider(color: AppColors.border),
            SizedBox(height: 10),

            TextFieldWidget(
              controller: _nameController,
              required: true,
              label: 'Nama Komponen',
              fillColor: Colors.transparent,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: AppColors.border, width: 1),
              ),
              hintText: 'Contoh: Cup Bearing A',
            ),
            SizedBox(height: 16),

            TextFieldWidget(
              required: false,
              controller: _codeController,
              label: 'Kode Manufaktur',
              fillColor: Colors.transparent,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: AppColors.border, width: 1),
              ),
              hintText: 'Contoh: 31274/2322',
            ),
            SizedBox(height: 16),

            TextFieldWidget(
              controller: _specController,
              required: false,
              label: 'Spesifikasi ',
              fillColor: Colors.transparent,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: AppColors.border, width: 1),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
