import 'package:flutter/material.dart';

/// Raw brand/base colors — the single source of truth for hex values.
/// Nothing else in the app should hardcode a Color(0x...) value.
abstract class AppColors {
  // Brand
  static const primary = Color(0xFF5B93AE);
  static const secondary = Color(0xFFA8E0D3);
  static const tertiary = Color(0xFFF59E0B); // TODO

  static const primaryBackground = Color(0xFFA9D6E5);
  static const onPrimaryBackground = Color(0xFF2F3A3F);

  // Semantic
  static const success = Color(0xFFA8E0D3);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);
  static const info = Color(0xFF3B82F6);

  // Neutrals — light theme
  static const lightBackground = Color(0xFFFFFFFF);
  static const lightSurface = Color(0xFFFAFAF8);
  static const lightOnSurface = Color(0xFF111827);
  static const lightOutline = Color(0xFFE5E7EB);

  // Neutrals — dark theme
  static const darkBackground = Color(0xFF0B0F19);
  static const darkSurface = Color(0xFF1A1F2E);
  static const darkOnSurface = Color(0xFFF3F4F6);
  static const darkOutline = Color(0xFF2E3446);
}