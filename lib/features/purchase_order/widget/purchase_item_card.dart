import 'package:flutter/material.dart';
import 'package:inventory_sync_apps/core/styles/color_scheme.dart';
import 'package:inventory_sync_apps/features/purchase_order/models/purchase_order_item.dart';
import 'package:inventory_sync_apps/shared/presentation/widgets/primary_button.dart';

class PurchaseItemCard extends StatelessWidget {
  final PurchaseOrderItem item;
  final VoidCallback onTap;
  const PurchaseItemCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    bool isUrgent = item.requestStatus?.toUpperCase() == 'URGENT';
    bool isCompleted = (item.qtyReceived ?? 0) >= (item.qtyPurchase ?? 0);

    return CustomButton(
      padding: EdgeInsets.all(16),
      elevation: 0,
      color: AppColors.surface,
      borderColor: AppColors.border,
      radius: 20,
      borderWidth: 1.2,
      onPressed: isCompleted ? null : onTap,
      child: Row(
        spacing: 10,
        children: [
          Expanded(
            child: Column(
              spacing: 2,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isUrgent) ...[
                  Container(
                    margin: EdgeInsets.only(right: 5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    // margin: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'URGENT',
                      style: TextStyle(
                        color: AppColors.surface,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
                Row(
                  children: [
                    Text(
                      item.itemCode ?? '',
                      style: TextStyle(
                        color: isCompleted
                            ? AppColors.onMuted
                            : AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),

                Text(
                  item.itemName ?? '',
                  style: TextStyle(
                    color: isCompleted
                        ? AppColors.onMuted
                        : AppColors.onSurface,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Column(
            spacing: 1.2,
            children: [
              Text(
                '${item.qtyReceived}/${item.qtyPurchase}',
                style: TextStyle(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                item.uomName ?? '',
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
    );
  }
}
