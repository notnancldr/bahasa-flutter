import 'package:flutter/material.dart';

/// Typography scale, kept separate so fonts/sizes can change
/// independently of color scheme.
abstract class AppTextTheme {
  static TextTheme build(ColorScheme scheme) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 32, fontWeight: FontWeight.bold, color: scheme.onSurface,
      ),
      titleLarge: TextStyle(
        fontSize: 22, fontWeight: FontWeight.w600, color: scheme.onSurface,
      ),
      bodyLarge: TextStyle(
        fontSize: 16, fontWeight: FontWeight.normal, color: scheme.onSurface,
      ),
      bodyMedium: TextStyle(
        fontSize: 14, fontWeight: FontWeight.normal, color: scheme.onSurface,
      ),
      labelLarge: TextStyle(
        fontSize: 14, fontWeight: FontWeight.w500, color: scheme.onSurface,
      ),
    );
  }
}