import 'package:flutter/material.dart';

sealed class ThemeEvent {
  const ThemeEvent();
}

class LoadThemeEvent extends ThemeEvent {
  const LoadThemeEvent();
}

class ChangeThemeEvent extends ThemeEvent {
  final ThemeMode themeMode;
  const ChangeThemeEvent(this.themeMode);
}
