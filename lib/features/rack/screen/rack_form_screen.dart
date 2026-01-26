import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_sync_apps/core/styles/color_scheme.dart';
import 'package:inventory_sync_apps/core/styles/text_theme.dart';
import 'package:inventory_sync_apps/core/utils/custom_back_button.dart';
import 'package:inventory_sync_apps/core/utils/loading_overlay.dart';
import 'package:inventory_sync_apps/shared/presentation/widgets/primary_button.dart';
import 'package:inventory_sync_apps/shared/presentation/widgets/text_field_widget.dart';

import '../../../core/db/app_database.dart';
import '../bloc/form_rack/rack_form_cubit.dart';

class RackFormScreen extends StatefulWidget {
  final bool isEditMode;

  const RackFormScreen({super.key, required this.isEditMode});

  @override
  State<RackFormScreen> createState() => _RackFormScreenState();
}

class _RackFormScreenState extends State<RackFormScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _warehouseController;
  bool _overlayShown = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _warehouseController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _warehouseController.dispose();
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
    return BlocConsumer<RackFormCubit, RackFormState>(
      listener: (context, state) {
        if (state.status == RackFormStatus.success) {
          _maybeShowOverlay(false);
          Navigator.of(context).pop(true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.isEditMode
                    ? 'Rak berhasil diperbarui'
                    : 'Rak berhasil ditambahkan',
              ),
              backgroundColor: Colors.green,
            ),
          );
        }

        if (state.status == RackFormStatus.loading) {
          _maybeShowOverlay(true);
        } else {
          _maybeShowOverlay(false);
        }

        if (state.status == RackFormStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Gagal menyimpan rak'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<RackFormCubit>();

        // Sync controllers
        if (_nameController.text != state.name) {
          _nameController.text = state.name;
        }

        // Get warehouse name for controller
        final selectedWarehouse = state.warehouses.firstWhere(
          (w) => w.id == state.warehouseId,
          orElse: () => state.warehouses.isNotEmpty
              ? state.warehouses.first
              : Warehouse(id: '', name: ''),
        );

        if (state.warehouseId != null &&
            _warehouseController.text != selectedWarehouse.name) {
          _warehouseController.text = selectedWarehouse.name;
        }

        // Show loading for initial data load
        if ((state.status == RackFormStatus.loading ||
                state.status == RackFormStatus.initial) &&
            state.warehouses.isEmpty) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              title: Text(widget.isEditMode ? 'Edit Rak' : 'Tambah Rak'),
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
            title: Text(
              widget.isEditMode ? 'Edit Rak' : 'Tambah Rak',
              style: TextStyle(
                color: AppColors.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
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
              onPressed: state.status == RackFormStatus.loading
                  ? null
                  : (cubit.canSubmit ? cubit.submit : null),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save_outlined, color: AppColors.surface, size: 18),
                  SizedBox(width: 8),
                  Text(
                    widget.isEditMode ? 'SIMPAN PERUBAHAN' : 'SIMPAN RAK',
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
                // Info banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.primary,
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Rak digunakan untuk mengorganisir lokasi penyimpanan item dalam warehouse.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.onBackground,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // Nama Rak
                TextFieldWidget(
                  controller: _nameController,
                  required: true,
                  label: 'Nama Rak',
                  fillColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: AppColors.border, width: 1),
                  ),
                  hintText: 'Contoh: Rak A1, Rak Utama',
                  hintStyle: TextStyle(
                    color: AppColors.primary.withOpacity(0.5),
                    fontWeight: FontWeight.w400,
                  ),
                  onChanged: (value) => cubit.setName(value),
                ),
                SizedBox(height: 16),

                // Warehouse Dropdown
                TextFieldWidget(
                  controller: _warehouseController,
                  readonly: true,
                  required: true,
                  label: 'Warehouse',
                  fillColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: AppColors.border, width: 1),
                  ),
                  hintText: 'Pilih Warehouse',
                  hintStyle: TextStyle(
                    color: AppColors.primary.withOpacity(0.5),
                    fontWeight: FontWeight.w400,
                  ),
                  suffixIcon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.primary,
                  ),
                  onFieldTap: () async {
                    if (state.warehouses.isEmpty) return;

                    final selected = await showModalBottomSheet<String>(
                      context: context,
                      isScrollControlled: true,
                      builder: (ctx) {
                        return SafeArea(
                          child: DraggableScrollableSheet(
                            expand: false,
                            initialChildSize: 0.5,
                            minChildSize: 0.25,
                            maxChildSize: 0.9,
                            builder: (context, scrollController) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Text(
                                      'Pilih Warehouse',
                                      style: AppTextStyles.mono.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Divider(height: 1),
                                  Expanded(
                                    child: ListView.builder(
                                      controller: scrollController,
                                      itemCount: state.warehouses.length,
                                      itemBuilder: (_, i) {
                                        final warehouse = state.warehouses[i];
                                        return ListTile(
                                          leading: Icon(
                                            Icons.warehouse_outlined,
                                            color: AppColors.primary,
                                          ),
                                          title: Text(warehouse.name),
                                          onTap: () => Navigator.of(
                                            ctx,
                                          ).pop(warehouse.id),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      },
                    );

                    if (selected != null) {
                      cubit.setWarehouse(selected);
                    }
                  },
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
