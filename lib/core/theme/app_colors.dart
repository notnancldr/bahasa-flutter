import 'package:flutter/material.dart';

/// Raw brand/base colors — the single source of truth for hex values.
/// Nothing else in the app should hardcode a Color(0x...) value.
abstract class AppColors {
  // Brand
  static const primary = Color(0xFFA9D6E5);
  static const secondary = Color(0xFFFFD3B0);
  static const tertiary = Color(0xFFC9B6E4); // TODO

  static const primaryDark = Color(0xFF5B93AE);
  static const darkPrimaryDark = Color(0xFF5B93AE);

  static const primaryBackground = Color(0xFFA9D6E5);
  static const onPrimaryBackground = Color(0xFF2F3A3F);

  static const mainText = Color(0xFF2F3A3F);
  static const secodaryText = Color(0xFF7D8A8F);

  static const streakLight = Color(0xFFFFD59E);
  static const streakDark = Color(0xFFFFB68F);
  static const streakShadow = Color(0xFFAF855A);

  // Semantic
  static const success = Color(0xFFA8D5A2);
  static const warning = Color(0xFFFFD59E);
  static const error = Color(0xFFF4A6A6);
  static const info = Color(0xFFA8D8EA);

  // Neutrals — light theme
  static const lightBackground = Color(0xFFFAFAF8);
  static const lightSurface = Color(0xFFF4F4F2);
  static const lightOnSurface = Color(0xFF2F3A3F);
  static const lightOutline = Color.fromARGB(102, 204, 204, 204);

  // Neutrals — dark theme (same blue-gray hue as mainText, hue ~200°)
  static const darkBackground = Color(0xFF0F1417);
  static const darkSurface = Color(0xFF171F23);
  static const darkSurfaceElevated = Color(
    0xFF1F292E,
  ); // cards, sheets, dialogs
  static const darkOnSurface = Color(0xFFE8EFF1);
  static const darkOnSurfaceMuted = Color(
    0xFF9AA8AD,
  ); // dark counterpart of secodaryText
  static const darkOutline = Color(0xFF2F3A3F); // reuses mainText for cohesion

  // Dark theme brand accents
  // Pastels already have strong contrast on dark, so primary/secondary/
  // tertiary can be used as-is. Only containers need a deeper tone.
  static const darkPrimaryContainer = Color(0xFF2B4A58);
  static const darkOnPrimary = Color(0xFF16252C);
}
