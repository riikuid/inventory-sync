import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xff9f8f68);
  static const Color primaryLight = Color(0xffd1e4ff);
  static const Color primaryDark = Color(0xff6b7d99);

  static const Color secondary = Color(0xffF0C300);
  static const Color secondaryLight = Color(0xffffdcc6);
  static const Color secondaryDark = Color(0xffb28c00);

  static const Color background = Color(0xfffbf9fd);
  static const Color surface = Color(0xffffffff);
  static const Color error = Color(0xffba1a1a);

  static const Color onPrimary = Color(0xffffffff);
  static const Color onSecondary = Color(0xffffffff);
  static const Color onBackground = Color(0xff1b1b1f);
  static const Color onSurface = Color(0xff1b1b1f);
  static const Color onError = Color(0xffffffff);
}

const ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: AppColors.primary,
  onPrimary: AppColors.onPrimary,
  primaryContainer: AppColors.primaryLight,
  onPrimaryContainer: AppColors.primary,
  // secondary: Color(0xff755846),
  secondary: Color(0xffF0C300),
  onSecondary: Color(0xffffffff),
  secondaryContainer: Color(0xffffdcc6),
  onSecondaryContainer: Color(0xff2b1708),
  // tertiary: Color(0xff5c5b7e),
  tertiary: Color(0xff9f8f68),
  onTertiary: Color(0xffffffff),
  tertiaryContainer: Color(0xffe2dfff),
  onTertiaryContainer: Color(0xff181837),
  error: Color(0xffba1a1a),
  onError: Color(0xffffffff),
  errorContainer: Color(0xffffdad6),
  onErrorContainer: Color(0xff410002),
  surface: Color(0xfffbf9fd),
  onSurface: Color(0xff1b1b1f),
  surfaceContainerHighest: Color(0xffdfe0eb),
  onSurfaceVariant: Color(0xff44464f),
  outline: Color(0xff757780),
  outlineVariant: Color(0xffc5c6d0),
  shadow: Color(0xff000000),
  scrim: Color(0xff000000),
  inverseSurface: Color(0xff303034),
  onInverseSurface: Color(0xfff2f0f4),
  inversePrimary: Color(0xffb1c5ff),
  // surfaceTint: Color(0xff395ba9),
  surfaceTint: Color(0xff9f8f68),
);

const ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xff9dcaff),
  onPrimary: Color(0xff9f8f68),
  primaryContainer: Color(0xff9f8f68),
  onPrimaryContainer: Color(0xffd1e4ff),
  secondary: Color(0xffd8c4a0),
  onSecondary: Color(0xff3b2f15),
  secondaryContainer: Color(0xff52452a),
  onSecondaryContainer: Color(0xfff5e0bb),
  tertiary: Color(0xffc2c3eb),
  onTertiary: Color(0xff2b2e4d),
  tertiaryContainer: Color(0xff424465),
  onTertiaryContainer: Color(0xffe0e0ff),
  error: Color(0xffffb4ab),
  onError: Color(0xff690005),
  errorContainer: Color(0xff93000a),
  onErrorContainer: Color(0xffffb4ab),
  surface: Color(0xff1e2125),
  onSurface: Color(0xffe2e2e6),
  surfaceContainerHighest: Color(0xff444b53),
  onSurfaceVariant: Color(0xffc3c7cf),
  outline: Color(0xff8d9199),
  outlineVariant: Color(0xff42474e),
  shadow: Color(0xff000000),
  scrim: Color(0xff000000),
  inverseSurface: Color(0xffdfe1e6),
  onInverseSurface: Color(0xff2f3033),
  inversePrimary: Color(0xff0061a2),
  surfaceTint: Color(0xff9dcaff),
);
