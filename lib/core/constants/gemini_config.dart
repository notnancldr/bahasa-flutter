import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Central configuration for Gemini AI integration.
///
/// **Developer Setup:**
/// Put your Google AI Studio Gemini API key into the `.env` file (`GEMINI_API_KEY=your_key`)
/// or supply it at build/run time using:
/// ```bash
/// flutter run --dart-define=GEMINI_API_KEY=your_gemini_api_key
/// ```
class GeminiConfig {
  GeminiConfig._();

  /// Placeholder key indicator when no key has been inserted.
  static const String placeholderKey = 'YOUR_GEMINI_API_KEY';

  static String _cleanKey(String rawKey) {
    var cleaned = rawKey.trim();
    if ((cleaned.startsWith('"') && cleaned.endsWith('"')) ||
        (cleaned.startsWith("'") && cleaned.endsWith("'"))) {
      cleaned = cleaned.substring(1, cleaned.length - 1).trim();
    }
    return cleaned;
  }

  /// Developer-provided Gemini API key.
  ///
  /// Checks `--dart-define=GEMINI_API_KEY=your_key` first,
  /// then checks `.env` file (`GEMINI_API_KEY`), falling back to [placeholderKey].
  static String get developerGeminiApiKey {
    // 1. Check compile-time --dart-define=GEMINI_API_KEY=...
    const fromEnv = String.fromEnvironment('GEMINI_API_KEY');
    if (fromEnv.isNotEmpty) return _cleanKey(fromEnv);

    // 2. Check loaded .env file
    if (dotenv.isInitialized) {
      final key = dotenv.maybeGet('GEMINI_API_KEY');
      if (key != null) {
        final cleaned = _cleanKey(key);
        if (cleaned.isNotEmpty && cleaned != placeholderKey) {
          return cleaned;
        }
      }
    }

    return placeholderKey;
  }

  /// Returns true when a valid developer API key is configured.
  static bool get isConfigured =>
      developerGeminiApiKey.trim().isNotEmpty &&
      developerGeminiApiKey.trim() != placeholderKey;
}
