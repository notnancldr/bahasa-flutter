import 'package:flutter/material.dart';

/// Typography scale, kept separate so fonts/sizes can change
/// independently of color scheme.
abstract class AppTextTheme {
  static TextTheme build(ColorScheme scheme) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 32, fontWeight: FontWeight.bold, color: scheme.onSurface,
      ),

      titleSmall: TextStyle(
        fontSize: 14, fontWeight: FontWeight.w800, color: scheme.onSurface,
      ),
      titleMedium: TextStyle(
        fontSize: 18, fontWeight: FontWeight.w800, color: scheme.onSurface,
      ),
      titleLarge: TextStyle(
        fontSize: 22, fontWeight: FontWeight.w800, color: scheme.onSurface,
      ),

      bodyLarge: TextStyle(
        fontSize: 16, fontWeight: FontWeight.w600, color: scheme.onSurface,
      ),
      bodyMedium: TextStyle(
        fontSize: 14, fontWeight: FontWeight.w600, color: scheme.onSurface,
      ),

      labelLarge: TextStyle(
        fontSize: 14, fontWeight: FontWeight.w600, color: scheme.onSurfaceVariant,
      ),
      labelMedium: TextStyle(
        fontSize: 12, fontWeight: FontWeight.w600, color: scheme.onSurfaceVariant,
      ),
      labelSmall: TextStyle(
        fontSize: 10, fontWeight: FontWeight.w600, color: scheme.onSurfaceVariant,
      ),
    );
  }
}