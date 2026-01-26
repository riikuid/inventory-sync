import 'package:flutter/material.dart';
import 'package:inventory_sync_apps/shared/presentation/widgets/primary_button.dart';

import '../styles/color_scheme.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const CustomBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomButton(
        color: AppColors.background,
        borderColor: AppColors.border,
        borderWidth: 1,
        radius: 16,
        width: 38,
        height: 38,
        padding: EdgeInsets.zero,

        onPressed:
            onPressed ??
            () {
              Navigator.pop(context);
            },
        child: Icon(
          Icons.arrow_back_ios_rounded,
          size: 18,
          weight: 260,
          color: AppColors.onSurface,
        ),
      ),
    );
  }
}
