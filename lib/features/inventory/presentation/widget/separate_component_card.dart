import 'package:flutter/material.dart';

import '../../../../core/db/daos/component_dao.dart';
import '../../../../core/styles/app_style.dart';
import '../../../../core/styles/color_scheme.dart';

class SeparateComponentCard extends StatelessWidget {
  final ComponentWithBrandAndStock item;
  const SeparateComponentCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: AppColors.border),
        boxShadow: [AppStyle.defaultBoxShadow],
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              child: Text(
                item.component.name.isNotEmpty
                    ? item.component.name[0].toUpperCase()
                    : '?',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                // spacing: 2,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.component.name,
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  if ((item.brandName != null) ||
                      (item.component.manufCode != null))
                    Row(
                      children: [
                        if ((item.brandName != null))
                          Text(
                            '${item.brandName}',
                            style: TextStyle(
                              color: AppColors.onSurface,
                              fontSize: 14,
                            ),
                          ),
                        if ((item.brandName != null) &&
                            (item.component.manufCode != null))
                          Text(
                            ' - ',
                            style: TextStyle(
                              color: AppColors.onSurface,
                              fontSize: 14,
                            ),
                          ),
                        if ((item.component.manufCode != null))
                          Text(
                            '${item.component.manufCode}',
                            style: TextStyle(
                              color: AppColors.onSurface,
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${item.totalUnits}',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
