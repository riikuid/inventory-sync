// create_variant_screen.dart
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:inventory_sync_apps/core/db/app_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventory_sync_apps/core/utils/custom_back_button.dart';
import 'package:inventory_sync_apps/features/purchase_order/bloc/receiving_session/receiving_session_cubit.dart';
import 'package:inventory_sync_apps/shared/presentation/widgets/primary_button.dart';
import 'package:inventory_sync_apps/shared/presentation/widgets/receiving_session_banner.dart';
import 'package:inventory_sync_apps/shared/presentation/widgets/text_field_widget.dart';

import '../../../core/styles/color_scheme.dart';
import '../../../core/styles/text_theme.dart';
import '../../../core/utils/loading_overlay.dart';
import '../../../shared/models/selected_brand_result.dart';
import '../../../shared/models/selected_rack_result.dart';
import '../../../shared/presentation/screen/brand_picker_screen.dart';
import '../../../shared/presentation/screen/rack_picker_screen.dart';
import '../../company_item/screen/company_item_detail_screen.dart';
import '../bloc/create_variant/create_variant_cubit.dart';
import '../../../shared/presentation/widgets/uom_picker_sheet.dart';

class CreateVariantScreen extends StatefulWidget {
  final String companyItemId;
  final int userId;
  final String? companyCode;
  final String? productName; // auto base (ex: "Bearing")
  final String? defaultRackId;
  final String? defaultRackName;
  final String? purchasingUomId;
  final bool? isSetUp;

  const CreateVariantScreen({
    super.key,
    required this.companyItemId,
    required this.userId,
    this.isSetUp,
    this.companyCode,
    this.productName,
    this.defaultRackId,
    this.defaultRackName,
    this.purchasingUomId,
  });

  @override
  State<CreateVariantScreen> createState() => _CreateVariantScreenState();
}

class _CreateVariantScreenState extends State<CreateVariantScreen> {
  late final TextEditingController _brandController;
  late final TextEditingController _rackController;
  late final TextEditingController _nameController;
  late final TextEditingController _uomController;
  late final TextEditingController _manufCodeController;
  late final TextEditingController _specController;
  bool _overlayShown = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _brandController = TextEditingController();
    _rackController = TextEditingController();
    _nameController = TextEditingController();
    _uomController = TextEditingController();
    _manufCodeController = TextEditingController();
    _specController = TextEditingController();
  }

  @override
  void dispose() {
    _brandController.dispose();
    _rackController.dispose();
    _nameController.dispose();
    _uomController.dispose();
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
      create: (_) => CreateVariantCubit(
        labelingRepository: context.read(),
        companyItemId: widget.companyItemId,
        userId: widget.userId,
        defaultRackId: widget.defaultRackId,
        isSetUp: widget.isSetUp ?? false,
        purchasingUomId: widget.purchasingUomId,
      ),
      child: BlocConsumer<CreateVariantCubit, CreateVariantState>(
        listener: (context, state) {
          // success -> pop with true
          if (state.status == CreateVariantStatus.success) {
            _maybeShowOverlay(false);
            Navigator.of(context).pop(true);
            if (widget.isSetUp ?? false) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CompanyItemDetailScreen(
                    companyItemId: widget.companyItemId,
                  ),
                ),
              );
            }
          }

          // show/hide overlay based on loading state
          if (state.status == CreateVariantStatus.loading) {
            _maybeShowOverlay(true);
          } else {
            _maybeShowOverlay(false);
          }
        },
        builder: (context, state) {
          final cubit = context.read<CreateVariantCubit>();

          // call initFor once after the first build to prefill autoBase, etc.
          if (!_initialized) {
            _initialized = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // productName can be null -> initFor handles it
              cubit.initFor(
                productName: widget.productName ?? '',
                defaultRackId: widget.defaultRackId,
                defaultRackName: widget.defaultRackName,
                purchasingUomId: widget.purchasingUomId,
              );
            });
          }

          // sinkronisasi safety: update controller saat build (menangani initial state)
          // hindari overwrite bila user sedang mengetik: simple guard not implemented full,
          // but builder-run updates only when contents differ.
          if (_brandController.text != (state.brandName ?? '')) {
            _brandController.text = state.brandName ?? '';
          }
          if (_rackController.text != (state.rackName ?? '')) {
            _rackController.text = state.rackName ?? '';
          }
          if (_uomController.text != (state.uom ?? '')) {
            _uomController.text = state.uom ?? '';
          }

          if (_nameController.text != (state.name)) {
            _nameController.text = state.name;
          }

          return BlocBuilder<ReceivingSessionCubit, ReceivingSessionState>(
            builder: (context, sessionState) {
              return Scaffold(
                backgroundColor: AppColors.background,
                appBar: AppBar(
                  iconTheme: IconThemeData(color: AppColors.onSurface),
                  leading: CustomBackButton(),
                  backgroundColor: AppColors.background,
                  foregroundColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  bottom: const PreferredSize(
                    preferredSize: Size.fromHeight(1),
                    child: Divider(height: 1, thickness: 1),
                  ),
                  elevation: 0.5,
                  toolbarHeight: 60,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tambah Variant ${widget.productName}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        '${widget.companyCode}',
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
                    onPressed: state.status == CreateVariantStatus.loading
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
                          'SIMPAN VARIAN',
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
                      if (sessionState.isActive) ...[
                        ReceivingSessionBanner(state: sessionState),
                        SizedBox(height: 12),
                      ],
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
                        ],
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
                                    borderRadius: BorderRadius.circular(15),
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
                            DottedBorder(
                              options: RoundedRectDottedBorderOptions(
                                radius: Radius.circular(15),
                                dashPattern: [10, 5],
                                strokeWidth: 2,
                                color: AppColors.border,
                              ),
                              child: GestureDetector(
                                onTap: () => _showAddPhotoMenu(context, cubit),
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
                      // Brand (readonly, tap to pick)
                      TextFieldWidget(
                        controller: _brandController,
                        readonly: true,
                        required: false,
                        label: 'Brand/Merk',

                        fillColor: Colors.transparent,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: AppColors.border,
                            width: 1,
                          ),
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
                        onFieldTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const BrandPickerScreen(),
                            ),
                          );

                          if (result is SelectedBrandResult) {
                            // tampilkan nama segera di UI
                            final displayName = result.name;
                            _brandController.text = displayName;

                            // panggil onBrandSelected agar cubit auto-compose name
                            // (ini akan menambahkan brand ke belakang autoBase bila perlu)
                            cubit.onBrandSelected(result.id, result.name);
                          }
                        },
                      ),
                      SizedBox(height: 16),

                      // Rack (readonly, tap to pick)
                      TextFieldWidget(
                        controller: _rackController,
                        readonly: true,
                        required: false,
                        label: 'Lokasi Rak',
                        fillColor: Colors.transparent,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: AppColors.border,
                            width: 1,
                          ),
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
                                '${result.name} - ${result.warehouseName}';
                            _rackController.text = name;
                            cubit.setRack(result.id, name);
                          }
                        },
                      ),
                      SizedBox(height: 16),

                      // Variant name
                      TextFieldWidget(
                        controller: _nameController,
                        required: true,
                        label: 'Nama Variant',
                        fillColor: Colors.transparent,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: AppColors.border,
                            width: 1,
                          ),
                        ),
                        hintText: 'Contoh: Bearing Timken A',
                        hintStyle: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w400,
                        ),
                        onChanged: (value) => cubit.setName(value),
                      ),
                      SizedBox(height: 16),

                      // UOM: use modal bottom sheet instead of dropdown
                      TextFieldWidget(
                        controller: _uomController,
                        readonly: true,
                        required: true,
                        label: 'Satuan UOM',
                        fillColor: Colors.transparent,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: AppColors.border,
                            width: 1,
                          ),
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
                        onFieldTap: () async {
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
                        },
                      ),
                      SizedBox(height: 16),

                      // Kode Manufaktur
                      TextFieldWidget(
                        required: false,
                        label: 'Kode Manufaktur',
                        fillColor: Colors.transparent,
                        controller: _manufCodeController,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: AppColors.border,
                            width: 1,
                          ),
                        ),
                        maxCharValidation: 20,
                        hintText: 'Contoh: 31274/2322',
                        hintStyle: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w400,
                        ),
                        onChanged: (v) => cubit.setManufCode(v),
                      ),
                      SizedBox(height: 16),

                      // Spesifikasi
                      TextFieldWidget(
                        required: false,
                        label: 'Spesifikasi ',
                        controller: _specController,
                        fillColor: Colors.transparent,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: AppColors.border,
                            width: 1,
                          ),
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
            child: const Text(
              "Kamera",
              style: TextStyle(color: AppColors.primary),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              cubit.addPhoto(ImageSource.camera);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text(
              "Galeri",
              style: TextStyle(color: AppColors.primary),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              cubit.addPhoto(ImageSource.gallery);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          child: const Text(
            "Batal",
            style: TextStyle(color: AppColors.focusRing),
          ),
          onPressed: () => Navigator.pop(ctx),
        ),
      ),
    );
  }
}

/// Small fallback LoadingOverlay util in case project doesn't have one.
/// If you have your own LoadingOverlay, remove this and import yours instead.
