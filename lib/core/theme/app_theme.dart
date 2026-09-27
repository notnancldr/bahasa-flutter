import 'package:flutter/material.dart';
import 'app_color_scheme.dart';
import 'app_text_theme.dart';
import 'theme_extensions.dart';

/// Assembles the final ThemeData used by MaterialApp.
abstract class AppTheme {
  static ThemeData get light {
    final scheme = AppColorScheme.light;
    return ThemeData(
      fontFamily: "NunitoSans",
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: AppTextTheme.build(scheme),
      scaffoldBackgroundColor: scheme.surface,
      extensions: const [AppSemanticColors.light],
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  static ThemeData get dark {
    final scheme = AppColorScheme.dark;
    return ThemeData(
      fontFamily: "NunitoSans",
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: AppTextTheme.build(scheme),
      scaffoldBackgroundColor: scheme.surface,
      extensions: const [AppSemanticColors.dark],
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}