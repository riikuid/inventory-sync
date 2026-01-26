import 'package:flutter/material.dart';

import '../../../core/db/daos/category_dao.dart';
import '../../../core/styles/color_scheme.dart';

class CategoryCard extends StatelessWidget {
  final CategorySummary category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final config = _categoryUiConfig(category);

    return GestureDetector(
      onTap: () {
        // TODO: navigate ke list company item per category
        // misal: Navigator.push(... CategoryItemListScreen(categoryId: category.categoryId));
      },
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: config.iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(config.iconData, size: 18, color: cs.onPrimary),
            ),
            const Spacer(),
            Text(
              config.displayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 2),
            Text(
              '${category.companyItemCount} item',
              style: TextStyle(
                fontSize: 11,
                color: cs.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryUiConfig {
  final String displayName;
  final IconData iconData;
  final Color iconBgColor;

  _CategoryUiConfig({
    required this.displayName,
    required this.iconData,
    required this.iconBgColor,
  });
}

_CategoryUiConfig _categoryUiConfig(CategorySummary category) {
  // Mapping sederhana berdasarkan name/code. Bisa kamu tweak.
  final name = category.name.toLowerCase();
  if (name.contains('spare')) {
    return _CategoryUiConfig(
      displayName: 'Spare Part',
      iconData: Icons.inventory_2_rounded,
      iconBgColor: AppColors.secondary,
    );
  }
  if (name.contains('running')) {
    return _CategoryUiConfig(
      displayName: 'Running Store',
      iconData: Icons.shopping_bag_rounded,
      iconBgColor: const Color(0xffD6A94A),
    );
  }
  if (name.contains('repair')) {
    return _CategoryUiConfig(
      displayName: 'Repair',
      iconData: Icons.build_rounded,
      iconBgColor: const Color(0xffD05B4C),
    );
  }

  return _CategoryUiConfig(
    displayName: category.name,
    iconData: Icons.more_horiz_rounded,
    iconBgColor: AppColors.secondary.withOpacity(0.9),
  );
}
