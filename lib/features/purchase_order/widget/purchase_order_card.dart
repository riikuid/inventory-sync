import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventory_sync_apps/core/styles/color_scheme.dart';
import 'package:inventory_sync_apps/features/purchase_order/models/purchase_order.dart';
import 'package:inventory_sync_apps/features/purchase_order/screen/purchase_order_detail_screen.dart';
import 'package:inventory_sync_apps/shared/presentation/widgets/primary_button.dart';

class PurchaseOrderCard extends StatelessWidget {
  final PurchaseOrder item;
  const PurchaseOrderCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat(
      'dd MMM yyyy',
    ).format(item.poDate ?? DateTime.now());
    final status =
        (item.totalItemReceivedQuantity ?? 0) == (item.totalItemsQuantity ?? 0)
        ? 'Selesai'
        : (item.totalItemReceivedQuantity ?? 0) > 0
        ? 'Parsial'
        : 'Menunggu Diterima';

    Color statusColor = AppColors.border;
    if (status == 'Selesai') {
      statusColor = AppColors.success;
    } else if (status == 'Parsial') {
      statusColor = AppColors.warning;
    }

    IconData icon = Icons.error_outline_outlined;
    if (status == 'Selesai') {
      icon = Icons.check_circle_outline;
    } else if (status == 'Parsial') {
      icon = Icons.access_time_outlined;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: CustomButton(
        padding: EdgeInsets.all(16),
        elevation: 0,
        color: AppColors.surface,
        borderColor: AppColors.border,
        radius: 20,
        borderWidth: 1.2,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  PurchaseOrderDetailScreen(poCode: item.purchaseOrderCode!),
            ),
          );
        },
        child: Row(
          spacing: 10,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0x19000000),
                    blurRadius: 14,
                    offset: Offset(0, 6),
                  ),
                ],
                color: statusColor.withAlpha(20),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Icon(icon, color: statusColor, size: 24.0),
            ),
            Expanded(
              child: Column(
                // spacing: 2,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.purchaseOrderCode ?? '-',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),

                  Text(
                    item.supplierName ?? '-',
                    style: TextStyle(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 5),
                  if (status != 'Menunggu Diterima')
                    LinearProgressIndicator(
                      borderRadius: BorderRadius.circular(10),
                      value:
                          (item.totalItemReceivedQuantity ?? 0) /
                          (item.totalItemsQuantity ?? 0),
                      color: statusColor,
                      backgroundColor: Colors.grey[300],
                      minHeight: 6,
                    ),
                ],
              ),
            ),
            Column(
              spacing: 1.2,
              children: [
                Text(
                  '${item.totalItemReceived}/${item.totalItem}',
                  style: TextStyle(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'ITEM',
                  style: TextStyle(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.onSurface),
          ],
        ),
      ),
    );
  }
}
