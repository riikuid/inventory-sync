import 'package:flutter/material.dart';

class AppColors {
  /// CORE BRAND COLORS
  static const Color primary = Color(0xffC9A227); // Gold Matte
  static const Color primaryDark = Color(0xff5C4A11); // Dark Gold Brown
  static const Color primaryLight = Color(0xffF3E9C3); // Light Gold

  static const Color secondary = Color(0xff1E1E1E); // Almost Black / Coffee
  static const Color secondaryLight = Color(0xff2C2C2C);
  static const Color secondaryDark = Color(0xff000000);

  /// BACKGROUND
  static const Color background = Color(0xffFAF7F2); // Cream Warm
  static const Color surface = Color(0xffffffff);

  /// SUPPORTING
  static const Color border = Color(0xffD7D3CC); // Soft grey beige
  static const Color divider = Color(0xffE5E1DA);

  /// STATUS COLORS
  static const Color error = Color(0xffE53935);
  static const Color success = Color(0xff4CAF50);

  /// TEXT COLORS
  static const Color onPrimary = Color(0xff1E1E1E);
  static const Color onSecondary = Color(0xffffffff);
  static const Color onBackground = Color(0xff1E1E1E);
  static const Color onSurface = Color(0xff1E1E1E);
  static const Color onError = Color(0xffffffff);
}

const ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: AppColors.primary,
  onPrimary: AppColors.onPrimary,
  primaryContainer: AppColors.primaryLight,
  onPrimaryContainer: AppColors.primaryDark,

  secondary: AppColors.secondary,
  onSecondary: AppColors.onSecondary,
  secondaryContainer: AppColors.secondaryLight,
  onSecondaryContainer: AppColors.onSecondary,

  surface: AppColors.surface,
  onSurface: AppColors.onSurface,
  background: AppColors.background,
  onBackground: AppColors.onBackground,

  error: AppColors.error,
  onError: AppColors.onError,

  outline: AppColors.border,
  outlineVariant: AppColors.divider,
  shadow: Color(0xff000000),
  scrim: Color(0xff000000),
  surfaceTint: AppColors.primary,
);
