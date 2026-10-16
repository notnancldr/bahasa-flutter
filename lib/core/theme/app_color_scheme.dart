import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Builds Material 3 ColorSchemes from AppColors.
abstract class AppColorScheme {
  static ColorScheme get light => ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    tertiary: AppColors.tertiary,

    primaryContainer: AppColors.primaryBackground,
    onPrimaryContainer: AppColors.onPrimaryBackground,

    error: AppColors.error,
    surface: AppColors.lightSurface,
    onSurface: AppColors.lightOnSurface,
    outline: AppColors.lightOutline,

    brightness: Brightness.light,
  );

  static ColorScheme get dark => ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    primary: AppColors.primary,
    onPrimary: AppColors.darkOnPrimary,
    secondary: AppColors.secondary,
    tertiary: AppColors.tertiary,

    primaryContainer: AppColors.darkPrimaryContainer,
    // onPrimaryContainer: AppColors.onPrimaryBackground,

    error: AppColors.error,
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkOnSurface,
    outline: AppColors.darkOutline,

    brightness: Brightness.dark,
  );
}
