import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_sync_apps/core/styles/text_theme.dart';
import 'package:inventory_sync_apps/core/user_storage.dart';
import 'package:ribbon_widget/ribbon_widget.dart';

import '../../../core/db/daos/company_item_dao.dart';
import '../../../core/styles/app_style.dart';
import '../../../core/styles/color_scheme.dart';
import '../../auth/models/user.dart';
import '../screen/company_item_detail_screen.dart';
import '../../variant/screen/create_variant_screen.dart';

class CompanyItemCard extends StatelessWidget {
  final CompanyItemListRow row;
  // final VoidCallback? onTap;

  const CompanyItemCard({super.key, required this.row});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    bool needToSetupVariant = row.totalVariants == 0;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () async {
        dev.log('TOTAL VARIANT: ${row.totalVariants}');
        if (row.totalVariants == 0) {
          User _user = (await UserStorage.getUser())!;
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => CreateVariantScreen(
                companyItemId: row.companyItemId,
                userId: _user.id!,
                productName: row.productName,
                companyCode: row.companyCode,
                isSetUp: true,
                defaultRackId: row.defaultRackId,
                defaultRackName: row.defaultRackName,
              ),
            ),
          );

          // if (result == true) {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (_) =>
          //           CompanyItemDetailScreen(companyItemId: row.companyItemId),
          //     ),
          //   );
          // }
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
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(width: 1.2, color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left text block
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        row.companyCode,
                        style: AppTextStyles.mono.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                          color: AppColors.primary,
                        ),
                      ),
                      // const SizedBox(height: 2),
                      Text(
                        row.productName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (row.defaultRackName != null)
                        Row(
                          children: [
                            Icon(
                              Icons.room_preferences_outlined,
                              size: 14,
                              color: cs.onSurface.withOpacity(0.6),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              row.defaultRackName ?? '-',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(width: 1.0, color: AppColors.focusRing),
                  ),
                  child: Text(
                    // needToSetupVariant ? '+ Tambah' : '',
                    '${row.categoryName}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (row.isLabeled)
            Positioned(
              bottom: 1,
              right: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Text(
                    'Sudah Dilabeli',
                    style: TextStyle(
                      color: AppColors.surface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
