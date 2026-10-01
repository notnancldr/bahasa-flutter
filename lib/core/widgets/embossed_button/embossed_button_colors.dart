import 'package:bahasa/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

/// Color set for [EmbossedButton].
///
/// Every attribute is optional. Anything left `null` falls back to the
/// preset's default, which for this base class is the primary container look.
/// Presets extend this class and override the `resolve*` methods.
@immutable
class EmbossedButtonColor {
  /// Fill color (filled buttons only).
  final Color? background;

  /// Text and icon color.
  final Color? foreground;

  /// The solid "emboss" edge under the button (filled buttons only).
  final Color? shadow;

  /// Border color (outlined buttons only).
  final Color? border;

  /// Takes precedence over [background] when set (filled buttons only).
  final Gradient? gradient;

  const EmbossedButtonColor({
    this.background,
    this.foreground,
    this.shadow,
    this.border,
    this.gradient,
  });

  Color resolveBackground(ThemeData theme) =>
      background ?? theme.colorScheme.primaryContainer;

  Color resolveForeground(ThemeData theme, {required bool outlined}) =>
      foreground ?? theme.colorScheme.onPrimaryContainer;

  Color resolveShadow(ThemeData theme) =>
      shadow ?? theme.colorScheme.primaryFixedDim;

  Color resolveBorder(ThemeData theme) => border ?? theme.colorScheme.primary;

  Gradient? resolveGradient(ThemeData theme) => gradient;
}

/// Preset based on the theme's error colors.
@immutable
class EmbossedButtonErrorColor extends EmbossedButtonColor {
  const EmbossedButtonErrorColor({
    super.background,
    super.foreground,
    super.shadow,
    super.border,
    super.gradient,
  });

  @override
  Color resolveBackground(ThemeData theme) =>
      background ?? theme.colorScheme.errorContainer;

  @override
  Color resolveForeground(ThemeData theme, {required bool outlined}) =>
      foreground ?? theme.colorScheme.onErrorContainer;

  @override
  Color resolveShadow(ThemeData theme) => shadow ?? theme.colorScheme.error;

  @override
  Color resolveBorder(ThemeData theme) => border ?? theme.colorScheme.error;
}

@immutable
class EmbossedButtonSeededColor extends EmbossedButtonColor {
  final Color? seedColor;
  final Color Function(ThemeData theme)? colorBuilder;

  const EmbossedButtonSeededColor({
    super.background,
    super.foreground,
    super.shadow,
    super.border,
    super.gradient,

    this.seedColor,
    this.colorBuilder,
  });

  ColorScheme _cs(ThemeData theme) =>
      ColorScheme.fromSeed(
        seedColor: seedColor 
          ?? colorBuilder?.call(theme)
          ?? theme.primaryColor,
      );

  @override
  Color resolveBackground(ThemeData theme) =>
      background ?? _cs(theme).primaryContainer;

  @override
  Color resolveForeground(ThemeData theme, {required bool outlined}) =>
      foreground ?? _cs(theme).onPrimaryContainer;

  @override
  Color resolveShadow(ThemeData theme) =>
      shadow ?? _cs(theme).primaryFixedDim;

  @override
  Color resolveBorder(ThemeData theme) =>
      border ?? _cs(theme).outline;
}

@immutable
class EmbossedButtonWarningColor extends EmbossedButtonSeededColor {
  EmbossedButtonWarningColor({
    super.background,
    super.foreground,
    super.shadow,
    super.border,
    super.gradient,
  }) : super(
    colorBuilder: (theme) => theme.semanticColors.warning
  );
}

/// Shared behavior for presets built around a single accent color.
@immutable
abstract class _AccentEmbossedButtonColor extends EmbossedButtonColor {
  const _AccentEmbossedButtonColor({
    super.background,
    super.foreground,
    super.shadow,
    super.border,
    super.gradient,
  });

  Color accentOf(AppSemanticColors colors);

  Color _accent(ThemeData theme) => accentOf(theme.semanticColors);

  @override
  Color resolveBackground(ThemeData theme) => background ?? _accent(theme);

  @override
  Color resolveForeground(ThemeData theme, {required bool outlined}) =>
      foreground ?? (outlined ? _accent(theme) : Colors.white);

  @override
  Color resolveShadow(ThemeData theme) =>
      shadow ?? _darken(_accent(theme));

  @override
  Color resolveBorder(ThemeData theme) => border ?? _accent(theme);
}

/// Preset based on [AppSemanticColors.success].
@immutable
class EmbossedButtonSuccessColor extends _AccentEmbossedButtonColor {
  const EmbossedButtonSuccessColor({
    super.background,
    super.foreground,
    super.shadow,
    super.border,
    super.gradient,
  });

  @override
  Color accentOf(AppSemanticColors colors) => colors.success;
}

/// Preset based on [AppSemanticColors.info].
@immutable
class EmbossedButtonInfoColor extends _AccentEmbossedButtonColor {
  const EmbossedButtonInfoColor({
    super.background,
    super.foreground,
    super.shadow,
    super.border,
    super.gradient,
  });

  @override
  Color resolveForeground(ThemeData theme, {required bool outlined}) =>
      theme.colorScheme.onSurface;

  @override
  Color accentOf(AppSemanticColors colors) => colors.info;
}

/// Preset with a left-to-right gradient from
/// [AppSemanticColors.streakLight] to [AppSemanticColors.streakDark].
@immutable
class EmbossedButtonStreakColor extends EmbossedButtonColor {
  const EmbossedButtonStreakColor({
    super.background,
    super.foreground,
    super.shadow,
    super.border,
    super.gradient,
  });

  @override
  Color resolveBackground(ThemeData theme) =>
      background ?? theme.semanticColors.streakLight;

  @override
  Gradient? resolveGradient(ThemeData theme) =>
      gradient ??
      LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          theme.semanticColors.streakLight,
          theme.semanticColors.streakDark,
        ],
      );

  @override
  Color resolveForeground(ThemeData theme, {required bool outlined}) =>
      foreground ?? theme.colorScheme.onSurface;

  @override
  Color resolveShadow(ThemeData theme) =>
      shadow ?? theme.semanticColors.streakShadow;

  @override
  Color resolveBorder(ThemeData theme) =>
      border ?? theme.semanticColors.streakShadow;
}

extension on ThemeData {
  AppSemanticColors get semanticColors => extension<AppSemanticColors>()!;
}

Color _darken(Color color, [double amount = 0.12]) {
  final hsl = HSLColor.fromColor(color);
  return hsl
      .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
      .toColor();
}