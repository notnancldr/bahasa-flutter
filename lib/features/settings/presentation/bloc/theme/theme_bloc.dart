import 'package:bahasa/features/settings/domain/entities/app_theme_mode.dart';
import 'package:bahasa/features/settings/domain/usecases/get_theme_mode_usecase.dart';
import 'package:bahasa/features/settings/domain/usecases/set_theme_mode_usecase.dart';
import 'package:bahasa/features/settings/presentation/bloc/theme/theme_event.dart';
import 'package:bahasa/features/settings/presentation/bloc/theme/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final GetThemeModeUseCase _getThemeModeUseCase;
  final SetThemeModeUseCase _setThemeModeUseCase;

  ThemeBloc({
    required this._getThemeModeUseCase,
    required this._setThemeModeUseCase,
  }) : super(const ThemeState(themeMode: ThemeMode.light)) {
    on<LoadThemeEvent>(_onLoadTheme);
    on<ChangeThemeEvent>(_onChangeTheme);
  }

  Future<void> _onLoadTheme(
    LoadThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final mode = await _getThemeModeUseCase();
    emit(ThemeState(themeMode: _mapToFlutterTheme(mode), isApplied: false));
  }

  Future<void> _onChangeTheme(
    ChangeThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final appMode = _mapFromFlutterTheme(event.themeMode);
    await _setThemeModeUseCase(appMode);
    emit(ThemeState(themeMode: event.themeMode, isApplied: true));
  }

  static ThemeMode _mapToFlutterTheme(AppThemeMode mode) {
    return switch (mode) {
      AppThemeMode.dark => ThemeMode.dark,
      AppThemeMode.system => ThemeMode.system,
      AppThemeMode.light => ThemeMode.light,
    };
  }

  static AppThemeMode _mapFromFlutterTheme(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.dark => AppThemeMode.dark,
      ThemeMode.system => AppThemeMode.system,
      ThemeMode.light => AppThemeMode.light,
    };
  }
}
