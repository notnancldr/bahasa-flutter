/// Domain enum for theme preference (pure Dart, decoupled from Flutter).
enum AppThemeMode {
  light,
  dark,
  system;

  static AppThemeMode fromString(String? value) {
    return switch (value?.toLowerCase()) {
      'dark' => AppThemeMode.dark,
      'system' => AppThemeMode.system,
      _ => AppThemeMode.light,
    };
  }

  String toStorageString() => name;
}
