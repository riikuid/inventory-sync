import 'package:flutter/material.dart';

const TextTheme _baseTextTheme = TextTheme(
  displayLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
  displayMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
  displaySmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
  headlineLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
  headlineMedium: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
  headlineSmall: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold),
  titleLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
  titleMedium: TextStyle(fontSize: 14.0),
  titleSmall: TextStyle(fontSize: 12.0),
  bodyLarge: TextStyle(fontSize: 14.0),
  bodyMedium: TextStyle(fontSize: 12.0),
  bodySmall: TextStyle(fontSize: 10.0),
  labelLarge: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
  labelMedium: TextStyle(fontSize: 10.0),
  labelSmall: TextStyle(fontSize: 8.0),
);

final TextTheme customTextTheme = _baseTextTheme.apply(fontFamily: 'Poppins');

class AppTextStyles {
  static final TextStyle mono = TextStyle(fontFamily: 'Poppins');

  static final FontWeight regular = FontWeight.w400;
  static final FontWeight medium = FontWeight.w500;
}
