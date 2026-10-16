import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Central configuration for Gemini AI integration.
///
/// **Developer Setup:**
/// Paste your Google AI Studio Gemini API key into [developerGeminiApiKey]
/// or supply it at build/run time using:
/// ```bash
/// flutter run --dart-define=GEMINI_API_KEY=your_gemini_api_key
/// ```
class GeminiConfig {
  GeminiConfig._();

  /// Placeholder key indicator when no key has been inserted.
  static final String placeholderKey = dotenv.get('GEMINI_API_KEY');

  /// Developer-provided Gemini API key.
  ///
  /// Replace [placeholderKey] with your actual Gemini API key,
  /// or compile with `--dart-define=GEMINI_API_KEY=your_key`.
  static String developerGeminiApiKey = String.fromEnvironment(
    dotenv.get('GEMINI_API_KEY'),
    defaultValue: placeholderKey,
  );

  /// Returns true when a non-placeholder developer API key is configured.
  static bool get isConfigured =>
      developerGeminiApiKey.trim().isNotEmpty &&
      developerGeminiApiKey.trim() != placeholderKey;
}
