import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Colors Material's ColorScheme doesn't cover (success/warning etc.)
/// exposed as a ThemeExtension so they're still theme-aware and
/// accessible via Theme.of(context).extension&lt;AppSemanticColors&gt;().
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  final Color success;
  final Color warning;
  final Color info;

  final Color streakLight;
  final Color streakDark;

  const AppSemanticColors({
    required this.success,
    required this.warning,
    required this.info,
    required this.streakLight,
    required this.streakDark,
  });

  static const light = AppSemanticColors(
    success: AppColors.success,
    warning: AppColors.warning,
    info: AppColors.info,
    streakLight: AppColors.streakLight,
    streakDark: AppColors.streakDark,
  );

  static const dark = AppSemanticColors(
    success: AppColors.success,
    warning: AppColors.warning,
    info: AppColors.info,
    streakLight: AppColors.streakLight,
    streakDark: AppColors.streakDark,
  );

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? warning,
    Color? info,
    Color? streakLight,
    Color? streakDark,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      streakLight: streakLight ?? this.streakLight,
      streakDark: streakDark ?? this.streakDark,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      streakLight: Color.lerp(streakLight, other.streakLight, t)!,
      streakDark: Color.lerp(streakDark, other.streakDark, t)!,
    );
  }
}