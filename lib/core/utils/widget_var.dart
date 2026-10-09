import 'package:bahasa/core/theme/theme_extensions.dart';
import 'package:bahasa/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class WidgetVars {
  /// ### Current Theme
  /// 
  /// Equivalent to:
  /// ```
  /// Theme.of(context)
  /// ```
  final ThemeData theme;

  /// ### Color Schemes
  /// 
  /// Equivalent to:
  /// ```
  /// Theme.of(context).colorScheme
  /// ```
  final ColorScheme c;

  /// ### Text Themes
  /// 
  /// Equivalent to:
  /// ```
  /// Theme.of(context).textTheme
  /// ```
  final TextTheme t;

  /// ### Text Themes
  /// 
  /// Equivalent to:
  /// ```
  /// Theme.of(context).extension<AppSemanticColors>()!
  /// ```
  final AppSemanticColors s;

  /// ### App Localizations
  /// 
  /// Equivalent to:
  /// ```
  /// AppLocalizations.of(context)!
  /// ```
  final AppLocalizations l;

  const WidgetVars({
    required this.theme,

    required this.c,
    required this.t,
    required this.s,

    required this.l,
  });

  factory of(BuildContext context) {
    final theme = Theme.of(context);

    final c = theme.colorScheme;
    final t = theme.textTheme;
    final s = theme.extension<AppSemanticColors>()!;

    final l = AppLocalizations.of(context)!;

    return WidgetVars(
      theme: theme,
      c: c,
      t: t,
      s: s,
      l: l,
    );
  }
}