import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// State holding the currently active app locale.
class LanguageState {
  final Locale locale;

  const LanguageState(this.locale);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LanguageState &&
          runtimeType == other.runtimeType &&
          locale == other.locale;

  @override
  int get hashCode => locale.hashCode;
}

class LocaleCubit extends Cubit<LanguageState> {
  static const _prefsKey = 'app_language';
  static const _defaultLanguageCode = 'id';

  LocaleCubit() : super(const LanguageState(Locale(_defaultLanguageCode))) {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(_prefsKey);

    if (savedLanguage != null && savedLanguage != state.locale.languageCode) {
      emit(LanguageState(Locale(savedLanguage)));
    }
  }

  /// Persists [language] and applies it as the active app locale immediately.
  Future<void> changeLanguage(String language) async {
    if (language == state.locale.languageCode) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, language);

    emit(LanguageState(Locale(language)));
  }

  /// Resets to the default locale and clears the saved preference.
  Future<void> resetToDefault() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);

    emit(const LanguageState(Locale(_defaultLanguageCode)));
  }
}
