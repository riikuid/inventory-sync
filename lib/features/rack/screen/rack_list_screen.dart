import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_sync_apps/core/styles/app_style.dart';
import 'package:inventory_sync_apps/core/styles/color_scheme.dart';
import 'package:inventory_sync_apps/core/styles/text_theme.dart';
import 'package:inventory_sync_apps/core/utils/custom_back_button.dart';
import 'package:inventory_sync_apps/core/utils/custom_toast.dart';
import 'package:inventory_sync_apps/shared/presentation/widgets/primary_button.dart';

import '../../../core/db/model/rack_with_warehouse_sections.dart';
import '../../printer/screen/printer_management_screen.dart';
import '../../printer/bloc/printer_cubit.dart';
import '../bloc/form_rack/rack_form_cubit.dart';
import '../bloc/rack_list/rack_list_cubit.dart';
import 'rack_form_screen.dart';

class RackListScreen extends StatelessWidget {
  const RackListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RackListCubit(
        rackRepository: context.read(),
        printerCubit: context.read<PrinterCubit>(),
      )..watchRacks(),
      child: _RackListView(),
    );
  }
}

class _RackListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<PrinterCubit, PrinterState>(
      listener: (printerCtx, printerState) {
        if (printerState.error != null) {
          CustomToast.error(
            context,
            description: printerState.error,
            title: printerState.statusMessage,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: CustomBackButton(),
          iconTheme: IconThemeData(color: AppColors.onSurface),
          backgroundColor: AppColors.background,
          title: Text(
            'Kelola Rak',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          elevation: 0.5,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => RackFormCubit(
                    repo: context.read(),
                    rackId: null, // Create mode
                  )..loadWarehouses(),
                  child: RackFormScreen(isEditMode: false),
                ),
              ),
            );
          },
          backgroundColor: AppColors.primary,
          icon: Icon(Icons.add, color: AppColors.surface),
          label: Text(
            'Tambah Rak',
            style: TextStyle(
              color: AppColors.surface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await context.read<PrinterCubit>().checkConnection();
          },
          child: Column(
            children: [
              // Printer Status Banner
              BlocBuilder<RackListCubit, RackListState>(
                builder: (context, state) {
                  return _buildPrinterStatusBanner(context, state);
                },
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari rak...',
                    prefixIcon: Icon(Icons.search, color: AppColors.primary),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                  ),
                  onChanged: (query) {
                    context.read<RackListCubit>().searchRacks(query);
                  },
                ),
              ),

              // Warehouse Filter (Horizontal Scrollable)
              BlocBuilder<RackListCubit, RackListState>(
                builder: (context, state) {
                  if (state.warehouses.isEmpty) return SizedBox.shrink();

                  return Container(
                    height: 50,
                    padding: EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.border),
                      ),
                    ),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.warehouses.length + 1, // +1 for "Semua"
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // "Semua" chip
                          return _buildWarehouseChip(
                            context,
                            label: 'Semua',
                            isSelected: state.selectedWarehouseId == null,
                            onTap: () => context
                                .read<RackListCubit>()
                                .selectWarehouse(null),
                          );
                        }

                        final warehouse = state.warehouses[index - 1];
                        return _buildWarehouseChip(
                          context,
                          label: warehouse.name,
                          isSelected: state.selectedWarehouseId == warehouse.id,
                          onTap: () => context
                              .read<RackListCubit>()
                              .selectWarehouse(warehouse.id),
                        );
                      },
                    ),
                  );
                },
              ),

              // Rack List
              Expanded(
                child: BlocBuilder<RackListCubit, RackListState>(
                  builder: (context, state) {
                    if (state.status == RackListStatus.loading ||
                        state.status == RackListStatus.initial) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (state.status == RackListStatus.error) {
                      return Center(
                        child: Text('Error: ${state.errorMessage}'),
                      );
                    }

                    if (state.filteredRacks.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              state.searchQuery != null &&
                                      state.searchQuery!.isNotEmpty
                                  ? 'Tidak ada rak yang cocok'
                                  : 'Belum ada rak',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.fromLTRB(16, 12, 16, 96),
                      itemCount: state.filteredRacks.length,
                      itemBuilder: (context, index) {
                        final rack = state.filteredRacks[index];
                        final isPrinterConnected =
                            state.printerStatus ==
                            PrinterConnectionStatus.connected;

                        return _buildRackCard(
                          context,
                          rack,
                          isPrinterConnected,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrinterStatusBanner(BuildContext context, RackListState state) {
    final isConnected =
        state.printerStatus == PrinterConnectionStatus.connected;

    return InkWell(
      onTap: () async {
        // Navigate ke Printer Management Screen
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PrinterManagementScreen(),
          ),
        );
        // Setelah kembali, check connection lagi
        if (context.mounted) {
          context.read<RackListCubit>().checkPrinterConnection();
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isConnected ? Colors.green.shade50 : Colors.orange.shade50,
          border: Border.symmetric(
            vertical: BorderSide(
              color: isConnected ? Colors.green : Colors.orange,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              isConnected
                  ? Icons.bluetooth_connected
                  : Icons.bluetooth_disabled,
              size: 20,
              color: isConnected ? Colors.green : Colors.orange,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isConnected
                        ? "Printer Terhubung"
                        : "Printer Belum Terhubung",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isConnected
                          ? Colors.green.shade800
                          : Colors.orange.shade800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isConnected
                        ? context
                                  .read<PrinterCubit>()
                                  .state
                                  .selectedDevice
                                  ?.name ??
                              'Unknown'
                        : "Tap untuk menghubungkan",
                    style: TextStyle(
                      fontSize: 12,
                      color: isConnected
                          ? Colors.green.shade700
                          : Colors.orange.shade700,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.settings,
              size: 20,
              color: isConnected
                  ? Colors.green.shade700
                  : Colors.orange.shade700,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRackCard(
    BuildContext context,
    RackWithWarehouseAndSections rack,
    bool isPrinterConnected,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [AppStyle.defaultBoxShadow],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.inventory_2_outlined,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rack.rackName,
                        style: AppTextStyles.mono.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.warehouse_outlined,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              rack.warehouseName,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Section Badges
            if (rack.sectionCodes.isNotEmpty) ...[
              SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: rack.sectionCodes.map((code) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.2),
                      border: Border.all(
                        color: AppColors.secondary.withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      code,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],

            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    elevation: 0,
                    height: 36,
                    radius: 10,
                    color: isPrinterConnected
                        ? AppColors.secondary
                        : Colors.grey.shade300,
                    onPressed: isPrinterConnected
                        ? () => _printRackLabel(context, rack)
                        : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.print_outlined,
                          size: 16,
                          color: isPrinterConnected
                              ? AppColors.onSurface
                              : Colors.grey.shade500,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Cetak Label',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isPrinterConnected
                                ? AppColors.onSurface
                                : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CustomButton(
                  elevation: 0,
                  width: 36,
                  height: 36,
                  radius: 10,
                  color: AppColors.accent,
                  borderColor: AppColors.border,
                  onPressed: () => _editRack(context, rack),
                  child: Icon(
                    Icons.edit_outlined,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _printRackLabel(
    BuildContext context,
    RackWithWarehouseAndSections rack,
  ) {
    context.read<PrinterCubit>().printRakLabel(
      rakName: rack.rackName,
      rakId: rack.rackId,
    );
  }

  void _editRack(BuildContext context, RackWithWarehouseAndSections rack) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => RackFormCubit(
            repo: context.read(),
            rackId: rack.rackId, // Edit mode
          )..loadRack(),
          child: RackFormScreen(isEditMode: true),
        ),
      ),
    );
  }

  Widget _buildWarehouseChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 8),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.surface : AppColors.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
