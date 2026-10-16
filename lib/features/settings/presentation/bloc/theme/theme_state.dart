import 'package:flutter/material.dart';

class ThemeState {
  final ThemeMode themeMode;
  final bool isApplied;

  const ThemeState({required this.themeMode, this.isApplied = false});

  ThemeState copyWith({ThemeMode? themeMode, bool? isApplied}) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      isApplied: isApplied ?? this.isApplied,
    );
  }
}
