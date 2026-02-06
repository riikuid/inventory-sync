import 'package:flutter/material.dart';

class AppColors {
  /// PRIMARY
  static const Color primary = Color(0xff142AB0); //DONE
  static const Color onPrimary = Color(0xffF8F6F2);

  /// SECONDARY
  static const Color secondary = Color(0xffFFCC00);
  static const Color onSecondary = Color(0xff161412);

  /// ACCENT / TERTIARY
  static const Color accent = Color(0xffe7e8ed);
  static const Color onAccent = Color(0xff161412);

  /// BASE
  static const Color background = Color(0xffF8F8FA);
  static const Color onBackground = Color(0xff161412);

  /// SURFACE (Card/Popover)
  static const Color surface = Color.fromARGB(255, 248, 248, 251);
  static const Color onSurface = Color(0xff161412);

  /// MUTED
  static const Color muted = Color.fromARGB(255, 220, 221, 229);
  static const Color onMuted = Color.fromARGB(255, 92, 95, 112);

  /// BORDER / INPUT / FOCUS
  static const Color border = Color(0xff9095ac);
  static const Color input = Color(0xff9095ac);
  static const Color focusRing = AppColors.primary;

  /// DESTRUCTIVE / ERROR
  static const Color error = Color(0xffD92626);
  static const Color warning = Colors.orange;
  static const Color success = Color(0xff1f9350);
  static const Color onError = Color(0xffffffff);
}

const ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,

  /// Brand
  primary: AppColors.primary,
  onPrimary: AppColors.onPrimary,
  primaryContainer: AppColors.accent,
  onPrimaryContainer: AppColors.onAccent,

  secondary: AppColors.secondary,
  onSecondary: AppColors.onSecondary,
  secondaryContainer: AppColors.muted,
  onSecondaryContainer: AppColors.onMuted,

  /// Optional (kalau kamu pakai tertiary di component tertentu)
  tertiary: AppColors.accent,
  onTertiary: AppColors.onAccent,
  tertiaryContainer: AppColors.muted,
  onTertiaryContainer: AppColors.onMuted,

  /// Surfaces
  background: AppColors.background,
  onBackground: AppColors.onBackground,
  surface: AppColors.surface,
  onSurface: AppColors.onSurface,

  /// Status
  error: AppColors.error,
  onError: AppColors.onError,

  /// Borders / outlines
  outline: AppColors.border,
  outlineVariant: AppColors.muted,

  /// Effects
  shadow: Color(0xff000000),
  scrim: Color(0xff000000),
  surfaceTint: AppColors.primary,
);
