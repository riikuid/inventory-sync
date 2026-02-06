import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_sync_apps/core/styles/app_style.dart';
import 'package:inventory_sync_apps/core/db/app_database.dart';
import 'package:inventory_sync_apps/core/utils/custom_back_button.dart';
import 'package:inventory_sync_apps/shared/presentation/widgets/primary_button.dart';
import 'package:inventory_sync_apps/shared/presentation/widgets/text_field_widget.dart';

import '../../../../core/styles/color_scheme.dart';
import '../../../../core/styles/text_theme.dart';
import '../../../../core/utils/loading_overlay.dart';
import '../../../../shared/models/selected_brand_result.dart';
import '../../../../shared/models/selected_rack_result.dart';
import '../../../../shared/presentation/screen/brand_picker_screen.dart';
import '../../../../shared/presentation/screen/rack_picker_screen.dart';
import '../../../../shared/presentation/widgets/offline_smart_image.dart';
import '../bloc/edit_variant/edit_variant_cubit.dart';
import '../../../../shared/presentation/widgets/uom_picker_sheet.dart';

class EditVariantScreen extends StatefulWidget {
  final String variantId;
  final int userId;
  final String? companyCode;
  final String? productName;
  final bool hasStock;

  const EditVariantScreen({
    super.key,
    required this.variantId,
    required this.userId,
    this.companyCode,
    this.productName,
    this.hasStock = false,
  });

  @override
  State<EditVariantScreen> createState() => _EditVariantScreenState();
}

class _EditVariantScreenState extends State<EditVariantScreen> {
  late final TextEditingController _brandController;
  late final TextEditingController _rackController;
  late final TextEditingController _nameController;
  late final TextEditingController _uomController;
  late final TextEditingController _manufCodeController;
  late final TextEditingController _specificationController;

  bool _overlayShown = false;

  @override
  void initState() {
    super.initState();
    _brandController = TextEditingController();
    _rackController = TextEditingController();
    _nameController = TextEditingController();
    _uomController = TextEditingController();
    _manufCodeController = TextEditingController();
    _specificationController = TextEditingController();
  }

  @override
  void dispose() {
    _brandController.dispose();
    _rackController.dispose();
    _nameController.dispose();
    _uomController.dispose();
    _manufCodeController.dispose();
    _specificationController.dispose();
    super.dispose();
  }

  void _maybeShowOverlay(bool show) {
    if (show && !_overlayShown) {
      LoadingOverlay.show(context);
      _overlayShown = true;
    } else if (!show && _overlayShown) {
      LoadingOverlay.hide();
      _overlayShown = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditVariantCubit(
        labelingRepository: context.read(),
        variantId: widget.variantId,
        userId: widget.userId,
      )..loadVariant(),
      child: BlocConsumer<EditVariantCubit, EditVariantState>(
        listener: (context, state) {
          if (state.status == EditVariantStatus.success) {
            _maybeShowOverlay(false);
            Navigator.of(context).pop(true);
          }

          if (state.status == EditVariantStatus.loading) {
            _maybeShowOverlay(true);
          } else {
            _maybeShowOverlay(false);
          }

          if (state.status == EditVariantStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Gagal mengupdate variant'),
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<EditVariantCubit>();

          // Sync controllers dengan state
          if (_brandController.text != (state.brandName ?? '')) {
            _brandController.text = state.brandName ?? '';
          }
          if (_rackController.text != (state.rackName ?? '')) {
            _rackController.text = state.rackName ?? '';
          }
          if (_uomController.text != (state.uom ?? '')) {
            _uomController.text = state.uom ?? '';
          }
          if (_nameController.text != state.name) {
            _nameController.text = state.name;
          }
          if (_manufCodeController.text != (state.manufCode ?? '')) {
            _manufCodeController.text = state.manufCode ?? '';
          }
          if (_specificationController.text != (state.specification ?? '')) {
            _specificationController.text = state.specification ?? '';
          }

          // Show loading while initial load
          if (state.status == EditVariantStatus.initial ||
              (state.status == EditVariantStatus.loading &&
                  state.name.isEmpty)) {
            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                backgroundColor: AppColors.background,
                title: Text('Edit Variant'),
              ),
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              iconTheme: IconThemeData(color: AppColors.onSurface),
              leading: CustomBackButton(),
              backgroundColor: AppColors.background,
              foregroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              elevation: 0.5,
              toolbarHeight: 60,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Edit Variant ${widget.productName ?? ''}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    '${widget.companyCode ?? ''}',
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.mono.copyWith(
                      color: AppColors.primary,
                      fontSize: 12,
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
                border: Border(
                  top: BorderSide(width: 0.3, color: AppColors.onAccent),
                ),
              ),
              child: CustomButton(
                elevation: 0,
                radius: 40,
                height: 50,
                color: AppColors.primary,
                onPressed: state.status == EditVariantStatus.loading
                    ? null
                    : (cubit.canSubmit ? cubit.submit : null),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.save_outlined,
                      color: AppColors.surface,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'SIMPAN PERUBAHAN',
                      style: TextStyle(
                        color: AppColors.surface,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
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
                  // Foto Produk (Read-only / Disabled)
                  Row(
                    children: [
                      Text(
                        'Foto Produk',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        ' *',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        '(tidak dapat diubah)',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Display existing photos (read-only)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: state.photos.map((photo) {
                      return Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: AppColors.border, width: 1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: OfflineSmartImage(
                            localPath: photo.localPath,
                            remoteUrl: photo.remoteUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 16),

                  // Brand
                  TextFieldWidget(
                    controller: _brandController,
                    readonly: true,
                    required: false,
                    label: 'Brand/Merk',
                    fillColor: !widget.hasStock
                        ? Colors.transparent
                        : AppColors.input.withAlpha(100),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: AppColors.border, width: 1),
                    ),
                    hintText: 'Pilih Brand',
                    hintStyle: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w400,
                    ),
                    suffixIcon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.primary,
                    ),
                    onFieldTap: !widget.hasStock
                        ? () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const BrandPickerScreen(),
                              ),
                            );

                            if (result is SelectedBrandResult) {
                              _brandController.text = result.name;
                              cubit.onBrandSelected(result.id, result.name);
                            }
                          }
                        : null,
                  ),
                  SizedBox(height: 16),

                  // Rack
                  TextFieldWidget(
                    controller: _rackController,
                    readonly: true,
                    required: false,
                    label: 'Lokasi Rak',
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: AppColors.border, width: 1),
                    ),
                    hintText: 'Pilih Lokasi Rak',
                    hintStyle: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w400,
                    ),
                    suffixIcon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.primary,
                    ),
                    onFieldTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RackPickerScreen(),
                        ),
                      );

                      if (result is SelectedRackResult) {
                        String name =
                            '${result.name} - ${result.warehouseName ?? ""}';
                        _rackController.text = name;
                        cubit.setRack(result.id, name);
                      }
                    },
                  ),
                  SizedBox(height: 16),

                  // Variant name
                  TextFieldWidget(
                    controller: _nameController,
                    readonly: widget.hasStock,
                    required: true,
                    label: 'Nama Variant',
                    fillColor: !widget.hasStock
                        ? Colors.transparent
                        : AppColors.input.withAlpha(100),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: AppColors.border, width: 1),
                    ),
                    hintText: 'Contoh: Bearing Timken A',
                    hintStyle: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w400,
                    ),
                    onChanged: (value) => cubit.setName(value),
                  ),
                  SizedBox(height: 16),

                  // UOM
                  TextFieldWidget(
                    controller: _uomController,
                    readonly: true,
                    required: true,
                    label: 'Satuan UOM',
                    fillColor: !widget.hasStock
                        ? Colors.transparent
                        : AppColors.input.withAlpha(100),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: AppColors.border, width: 1),
                    ),
                    hintText: 'Pilih Satuan',
                    hintStyle: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w400,
                    ),
                    suffixIcon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.primary,
                    ),
                    onFieldTap: !widget.hasStock
                        ? () async {
                            final selected = await showModalBottomSheet<Uom>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (ctx) =>
                                  UomPickerSheet(uoms: state.uomList),
                            );

                            if (selected != null) {
                              cubit.setUom(selected.id, selected.name);
                              _uomController.text = selected.name;
                            }
                          }
                        : null,
                  ),
                  SizedBox(height: 16),

                  // Kode Manufaktur
                  TextFieldWidget(
                    controller: _manufCodeController,
                    readonly: widget.hasStock,
                    maxCharValidation: 20,
                    required: false,
                    label: 'Kode Manufaktur',
                    fillColor: !widget.hasStock
                        ? Colors.transparent
                        : AppColors.input.withAlpha(100),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: AppColors.border, width: 1),
                    ),
                    // hintText: 'Contoh: 31274/2322',
                    hintStyle: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w400,
                    ),
                    onChanged: (v) => cubit.setManufCode(v),
                  ),
                  SizedBox(height: 16),

                  // Spesifikasi
                  TextFieldWidget(
                    controller: _specificationController,
                    readonly: widget.hasStock,
                    required: false,
                    label: 'Spesifikasi',
                    fillColor: !widget.hasStock
                        ? Colors.transparent
                        : AppColors.input.withAlpha(100),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: AppColors.border, width: 1),
                    ),
                    maxLines: 4,
                    hintStyle: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w400,
                    ),
                    onChanged: (v) => cubit.setSpecification(v),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
