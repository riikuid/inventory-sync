import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_sync_apps/core/utils/custom_back_button.dart';
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

          Expanded(
            child: StreamBuilder<List<RackWithContext>>(
              stream: db.rackDao.watchRacks(search: search),
              builder: (context, snapshot) {
                final data = snapshot.data ?? [];

                if (data.isEmpty) {
                  return const Center(child: Text("Tidak ada rak ditemukan"));
                }

                return ListView.separated(
                  itemCount: data.length,
                  separatorBuilder: (_, __) => SizedBox(height: 16),
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
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          // border: Border.all(width: 1.0, color: AppColors.border),
                          color: AppColors.surface,
                          boxShadow: [AppStyle.defaultBoxShadow],
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  spacing: 10,
                                  children: [
                                    Icon(Icons.room_preferences_outlined),
                                    Text(
                                      rack.rack.name,
                                      style: TextStyle(
                                        color: AppColors.onSurface,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                // DecoratedBox(
                                //   decoration: BoxDecoration(
                                //     color: AppColors.primary.withAlpha(30),
                                //     border: Border.all(
                                //       width: 1.0,
                                //       color: AppColors.border,
                                //     ),
                                //     borderRadius: BorderRadius.circular(8),
                                //   ),
                                //   child: Padding(
                                //     padding: EdgeInsets.symmetric(
                                //       vertical: 6,
                                //       horizontal: 12,
                                //     ),
                                //     child: Text(
                                //       rack.departmentCode ?? ' ',
                                //       style: TextStyle(
                                //         color: AppColors.primary,
                                //         fontSize: 12,
                                //         fontWeight: FontWeight.w500,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              (rack.warehouseName ?? '').trimLeft(),
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
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
}
