import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_sync_apps/core/styles/text_theme.dart';
import 'package:inventory_sync_apps/core/utils/custom_back_button.dart';
import 'package:inventory_sync_apps/features/rack/bloc/rack_list/rack_list_cubit.dart';
import '../../../core/db/app_database.dart';
import '../../../core/db/daos/rack_dao.dart'; // pastikan tersedia
import '../../../core/styles/app_style.dart';
import '../../../core/styles/color_scheme.dart';
import '../../models/selected_rack_result.dart';
import '../widgets/search_field_widget.dart';

class RackPickerScreen extends StatefulWidget {
  const RackPickerScreen({super.key});

  @override
  State<RackPickerScreen> createState() => _RackPickerScreenState();
}

class _RackPickerScreenState extends State<RackPickerScreen> {
  String search = "";
  String? selectedWarehouseId;

  List<WarehouseInfo> _extractWarehouses(List<RackWithContext> data) {
    final warehouses = <String, String>{}; // Map<ID, Name>
    for (var item in data) {
      if (item.rack.warehouseId != null && item.warehouseName != null) {
        warehouses[item.rack.warehouseId!] = item.warehouseName!;
      }
    }
    return warehouses.entries
        .map((e) => WarehouseInfo(id: e.key, name: e.value))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();

    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
        title: const Text(
          "Pilih Rak",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: AppColors.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SearchFieldWidget(
              hintText: 'Cari kata kunci...',
              onChanged: (v) => setState(() => search = v),
            ),
          ),

          StreamBuilder<List<RackWithContext>>(
            stream: db.rackDao.watchRacks(
              search: "",
            ), // Ambil semua untuk list gudang
            builder: (context, snapshot) {
              final allData = snapshot.data ?? [];
              final warehouses = _extractWarehouses(allData);

              if (warehouses.isEmpty) return const SizedBox.shrink();

              return Container(
                height: 50,
                padding: const EdgeInsets.only(bottom: 12),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: warehouses.length + 1,
                  itemBuilder: (context, index) {
                    final isAll = index == 0;
                    final label = isAll ? 'Semua' : warehouses[index - 1].name;
                    final id = isAll ? null : warehouses[index - 1].id;
                    final isSelected = selectedWarehouseId == id;

                    return _buildFilterChip(
                      label: label,
                      isSelected: isSelected,
                      onTap: () => setState(() => selectedWarehouseId = id),
                    );
                  },
                ),
              );
            },
          ),

          Divider(height: 0),

          Expanded(
            child: StreamBuilder<List<RackWithContext>>(
              stream: db.rackDao.watchRacks(search: search),
              builder: (context, snapshot) {
                var data = snapshot.data ?? [];

                if (data.isEmpty) {
                  return const Center(child: Text("Tidak ada rak ditemukan"));
                }

                if (selectedWarehouseId != null) {
                  data = data
                      .where((r) => r.rack.warehouseId == selectedWarehouseId)
                      .toList();
                }

                return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: data.length,
                  separatorBuilder: (_, __) => SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final rack = data[i];
                    return GestureDetector(
                      onTap: () => Navigator.pop(
                        context,
                        SelectedRackResult(
                          id: rack.rack.id,
                          name: rack.rack.name,
                          warehouseName: rack.warehouseName,
                          sectionName: rack.sectionName,
                          departmentName: rack.departmentName,
                        ),
                      ),
                      child: _buildRackCard(rack),
                    );
                    // return ListTile(
                    //   title: Text(rack.rack.name),
                    //   subtitle: Text(
                    //     '${rack.warehouseName} - ${rack.departmentName}',
                    //   ),
                    //   onTap: () {},
                    // );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRackCard(RackWithContext rack) {
    return Container(
      // margin: EdgeInsets.only(bottom: 12),
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
                        rack.rack.name,
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
                              rack.warehouseName ?? '',
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
            // if (rack.sectionCodes.isNotEmpty) ...[
            //   SizedBox(height: 12),
            //   Wrap(
            //     spacing: 6,
            //     runSpacing: 6,
            //     children: rack.sectionCodes.map((code) {
            //       return Container(
            //         padding: const EdgeInsets.symmetric(
            //           horizontal: 10,
            //           vertical: 4,
            //         ),
            //         decoration: BoxDecoration(
            //           color: AppColors.secondary.withOpacity(0.2),
            //           border: Border.all(
            //             color: AppColors.secondary.withOpacity(0.5),
            //           ),
            //           borderRadius: BorderRadius.circular(6),
            //         ),
            //         child: Text(
            //           code,
            //           style: TextStyle(
            //             fontSize: 11,
            //             fontWeight: FontWeight.w600,
            //             color: AppColors.onSurface,
            //           ),
            //         ),
            //       );
            //     }).toList(),
            //   ),
            // ],
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
