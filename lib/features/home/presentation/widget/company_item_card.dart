import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:inventory_sync_apps/core/styles/text_theme.dart';

import '../../../../core/db/daos/company_item_dao.dart';
import '../../../../core/styles/app_style.dart';
import '../../../../core/styles/color_scheme.dart';
import '../../../inventory/presentation/screens/company_item_detail_screen.dart';
import '../../../variant/presentation/screen/create_variant_screen.dart';

class CompanyItemCard extends StatelessWidget {
  final CompanyItemListRow row;
  // final VoidCallback? onTap;

  const CompanyItemCard({super.key, required this.row});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () async {
        dev.log('TOTAL VARIANT: ${row.totalVariants}');
        if (row.totalVariants == 0) {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => CreateVariantScreen(
                companyItemId: row.companyItemId,
                userId: 'SDWDSD',
                productName: row.productName,
                companyCode: row.companyCode,
              ),
            ),
          );

          if (result == true) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    CompanyItemDetailScreen(companyItemId: row.companyItemId),
              ),
            );
          }
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  CompanyItemDetailScreen(companyItemId: row.companyItemId),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left text block
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    row.companyCode,
                    style: AppStyle.monoTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    row.productName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: cs.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        row.categoryName ?? '-',
                        style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Right pill stock
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '${row.totalUnits} Unit Aktif',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
