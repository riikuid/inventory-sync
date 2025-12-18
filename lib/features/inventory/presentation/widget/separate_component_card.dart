import 'package:flutter/material.dart';
import 'package:inventory_sync_apps/core/db/app_database.dart';
import 'package:inventory_sync_apps/core/db/daos/variant_dao.dart';

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
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.component.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),

                  if ((item.brandName != null) ||
                      (item.component.manufCode != null)) ...[
                    SizedBox(height: 3),
                    Text(
                      '${item.brandName}${item.component.manufCode != null && item.component.manufCode!.isNotEmpty ? '  •  ${item.component.manufCode}' : ''}',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
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
              child: Text('${item.totalUnits}'),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
