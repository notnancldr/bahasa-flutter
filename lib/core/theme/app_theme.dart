import 'package:flutter/material.dart';

import 'app_color_scheme.dart';
import 'app_text_theme.dart';
import 'theme_extensions.dart';

/// Assembles the final ThemeData used by MaterialApp.
abstract class AppTheme {
  static ThemeData get light =>
      _build(AppColorScheme.light, AppSemanticColors.light);

  static ThemeData get dark =>
      _build(AppColorScheme.dark, AppSemanticColors.dark);

  static ThemeData _build(ColorScheme scheme, AppSemanticColors semantic) {
    return ThemeData(
      fontFamily: "NunitoSans",
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: AppTextTheme.build(scheme),
      scaffoldBackgroundColor: scheme.surface,
      extensions: [semantic],

      // box variant: surfaceBright, outline border
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLowest,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: scheme.surfaceBright,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: scheme.outline),
          borderRadius: BorderRadiusGeometry.circular(10),
        ),
      ),

      dividerTheme: DividerThemeData(color: scheme.outline, space: 0),

      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
