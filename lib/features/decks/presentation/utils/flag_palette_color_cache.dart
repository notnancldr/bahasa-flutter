import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:palette_generator_master/palette_generator_master.dart';

/// Caches and resolves deck card background colors generated from country flag images.
///
/// Pipeline:
/// 1. Extracts `dominantColor` from the flag `ui.Image` using [PaletteGeneratorMaster].
/// 2. Generates a seeded [ColorScheme] via [ColorScheme.fromSeed].
/// 3. Resolves the scheme's `primary` color and caches it by language code.
abstract class FlagPaletteColorCache {
  static final Map<String, Color> _cache = <String, Color>{};

  /// Fallback deck card color before the flag image palette is extracted.
  static const Color defaultCardColor = Color(0xFFFA8989);

  /// Returns the cached primary color for [languageCode], if already computed.
  static Color? getCachedColor(String languageCode) {
    return _cache[languageCode.toLowerCase()];
  }

  /// Stores a resolved [color] for [languageCode] in the cache.
  static void setCachedColor(String languageCode, Color color) {
    _cache[languageCode.toLowerCase()] = color;
  }

  /// Clears all cached colors (useful for testing).
  static void clearCache() {
    _cache.clear();
  }

  /// Extracts the dominant color from [flagImage] using [PaletteGeneratorMaster],
  /// creates a seeded [ColorScheme], and returns its primary color.
  ///
  /// Returns `null` if [flagImage] has no extractable non-transparent pixels yet.
  static Future<Color?> extractPrimaryColorFromImage(
    ui.Image flagImage, {
    required String languageCode,
  }) async {
    final key = languageCode.toLowerCase();
    final cached = _cache[key];
    if (cached != null) {
      return cached;
    }

    var palette = await PaletteGeneratorMaster.fromImage(
      flagImage,
      maximumColorCount: 16,
      generateHarmony: false,
    );

    var dominantColor = palette.dominantColor?.color;
    if (dominantColor == null) {
      // Fallback without the near-white/black filter in case the flag is monochromatic
      palette = await PaletteGeneratorMaster.fromImage(
        flagImage,
        maximumColorCount: 16,
        filters: const <PaletteFilterMaster>[],
        generateHarmony: false,
      );
      dominantColor = palette.dominantColor?.color;
    }

    if (dominantColor == null) {
      return null;
    }

    final seededScheme = ColorScheme.fromSeed(seedColor: dominantColor);
    final resolvedPrimary = seededScheme.primary;
    _cache[key] = resolvedPrimary;
    return resolvedPrimary;
  }

  /// Computes the card background color for selection state.
  ///
  /// When [isSelected] is `true`, returns a darkened variant of [baseColor].
  static Color resolveCardBackgroundColor(
    Color baseColor, {
    required bool isSelected,
  }) {
    if (!isSelected) {
      // Blend slightly toward a soft pastel coral/primary tone for readability
      // while preserving the seeded ColorScheme.primary hue.
      return Color.lerp(baseColor, Colors.white, 0.28) ?? baseColor;
    }
    return Color.lerp(baseColor, Colors.black, 0.12) ?? baseColor;
  }
}
