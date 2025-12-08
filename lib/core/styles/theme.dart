import 'package:flutter/material.dart';
import 'color_scheme.dart';
import 'text_theme.dart';

// Light Theme
final lightThemeData = ThemeData(
  dialogTheme: DialogThemeData().copyWith(
    titleTextStyle: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  ),
  colorScheme: lightColorScheme,
  textTheme: customTextTheme,
  useMaterial3: true,
);
// Dark Theme
// final darkThemeData = ThemeData(
//   dialogTheme: DialogThemeData().copyWith(
//     titleTextStyle: TextStyle(
//       fontSize: 16.0,
//       fontWeight: FontWeight.bold,
//       color: Colors.black,
//     ),
//   ),
//   colorScheme: darkColorScheme,
//   textTheme: customTextTheme,
//   useMaterial3: true,
// );
