import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_sync_apps/core/utils/custom_back_button.dart';
import 'package:inventory_sync_apps/shared/presentation/widgets/primary_button.dart';
import 'package:inventory_sync_apps/shared/presentation/widgets/text_field_widget.dart';

import '../../../../core/styles/color_scheme.dart';
import '../../../../core/styles/text_theme.dart';
import '../../../../core/utils/loading_overlay.dart';
import '../../../../shared/models/selected_rack_result.dart';
import '../../../../shared/presentation/screen/rack_picker_screen.dart';
import '../bloc/edit_company_item/edit_company_item_cubit.dart';

class EditCompanyItemScreen extends StatefulWidget {
  final String companyItemId;
  final String companyCode;
  final String productName;

  const EditCompanyItemScreen({
    super.key,
    required this.companyItemId,
    required this.companyCode,
    required this.productName,
  });

  @override
  State<EditCompanyItemScreen> createState() => _EditCompanyItemScreenState();
}

class _EditCompanyItemScreenState extends State<EditCompanyItemScreen> {
  late final TextEditingController _rackController;
  bool _overlayShown = false;

  @override
  void initState() {
    super.initState();
    _rackController = TextEditingController();
  }

  @override
  void dispose() {
    _rackController.dispose();
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
      create: (_) => EditCompanyItemCubit(
        inventoryRepository: context.read(),
        companyItemId: widget.companyItemId,
      )..loadCompanyItem(),
      child: BlocConsumer<EditCompanyItemCubit, EditCompanyItemState>(
        listener: (context, state) {
          if (state.status == EditCompanyItemStatus.success) {
            _maybeShowOverlay(false);
            Navigator.of(context).pop(true);
          }

          if (state.status == EditCompanyItemStatus.loading) {
            _maybeShowOverlay(true);
          } else {
            _maybeShowOverlay(false);
          }

          if (state.status == EditCompanyItemStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'Gagal mengupdate lokasi item',
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<EditCompanyItemCubit>();

          // Sync controller dengan state
          if (_rackController.text != (state.rackName ?? '')) {
            _rackController.text = state.rackName ?? '';
          }

          // Show loading while initial load
          if (state.status == EditCompanyItemStatus.initial ||
              (state.status == EditCompanyItemStatus.loading &&
                  state.rackName == null)) {
            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                backgroundColor: AppColors.background,
                title: const Text('Atur Lokasi Item'),
              ),
              body: const Center(child: CircularProgressIndicator()),
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
                    'Atur Lokasi Item',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    widget.companyCode,
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
                onPressed: state.status == EditCompanyItemStatus.loading
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
                      'SIMPAN LOKASI',
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
                  // Info Card
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.productName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Tentukan lokasi rak default untuk item ini. Lokasi ini akan digunakan sebagai default saat membuat variant baru.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.onBackground,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),

                  // Rack Picker
                  TextFieldWidget(
                    controller: _rackController,
                    readonly: true,
                    required: true,
                    label: 'Lokasi Rak Default',
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
                            '${result.name} / ${result.warehouseName ?? ""}';
                        _rackController.text = name;
                        cubit.setRack(result.id, name);
                      }
                    },
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
