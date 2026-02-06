import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:inventory_sync_apps/core/db/app_database.dart';
import 'package:inventory_sync_apps/core/db/model/unit_row.dart';
import 'package:inventory_sync_apps/core/styles/app_style.dart';
import 'package:inventory_sync_apps/core/styles/color_scheme.dart';
import 'package:inventory_sync_apps/core/utils/custom_date_format.dart';
import 'package:inventory_sync_apps/features/unit/screen/unit_detail_screen.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class UnitCard extends StatelessWidget {
  final UnitRow row;
  const UnitCard({super.key, required this.row});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UnitDetailScreen(unitId: row.unit.id),
          ),
        );
      },
      child: Container(
        // margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: [AppStyle.defaultBoxShadow],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DottedBorder(
                  options: RoundedRectDottedBorderOptions(
                    color: AppColors.primary,
                    strokeWidth: 1,
                    dashPattern: [8, 4],
                    radius: Radius.circular(8),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(30),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: PrettyQrView.data(data: row.unit.qrValue),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        row.unit.id,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 4),
                      SizedBox(
                        height: 16,
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 12,
                              color: Colors.grey.shade600,
                            ),
                            SizedBox(width: 4),
                            Text(
                              CustomDateFormat.todMY(row.unit.createdAt) ?? '-',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            VerticalDivider(
                              color: Colors.grey.shade600,
                              width: 20,
                            ),
                            Icon(
                              Icons.assignment_outlined,
                              size: 12,
                              color: Colors.grey.shade600,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '${row.unit.quantity} ${row.uom.name}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
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
}
