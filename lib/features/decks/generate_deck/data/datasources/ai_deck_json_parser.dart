import 'dart:convert';

import 'package:bahasa/core/utils/random_char.dart';
import 'package:bahasa/features/decks/generate_deck/domain/entities/deck_generation_request.dart';
import 'package:bahasa/features/decks/import_deck/data/models/euy_card_model.dart';
import 'package:bahasa/features/decks/import_deck/data/models/euy_deck_model.dart';

/// Helper to parse and normalize AI generated JSON outputs into [EuyDeckModel].
class AiDeckJsonParser {
  const AiDeckJsonParser();

  /// Cleans raw text response from AI (strips markdown formatting if any) and decodes JSON.
  static Map<String, dynamic> cleanAndDecodeJson(String rawText) {
    var cleaned = rawText.trim();

    // Strip ```json ... ``` markdown if present
    if (cleaned.startsWith('```json')) {
      cleaned = cleaned.substring(7);
    } else if (cleaned.startsWith('```')) {
      cleaned = cleaned.substring(3);
    }

    if (cleaned.endsWith('```')) {
      cleaned = cleaned.substring(0, cleaned.length - 3);
    }

    cleaned = cleaned.trim();

    // Find JSON object bounds '{' and '}'
    final startIdx = cleaned.indexOf('{');
    final endIdx = cleaned.lastIndexOf('}');
    if (startIdx != -1 && endIdx != -1 && endIdx > startIdx) {
      cleaned = cleaned.substring(startIdx, endIdx + 1);
    }

    try {
      final decoded = jsonDecode(cleaned);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      throw const FormatException('Decoded JSON is not an object.');
    } catch (e) {
      throw FormatException(
        'Failed to parse AI JSON response: $e\nRaw: $rawText',
      );
    }
  }

  /// Extracts card items from a cards JSON array.
  static List<EuyCardModel> parseCards(List<dynamic> rawCards) {
    final result = <EuyCardModel>[];

    for (final item in rawCards) {
      if (item is Map<String, dynamic>) {
        final defLang = item['defaultLanguage']?.toString() ?? '';
        final trans = item['translation']?.toString() ?? '';
        final phonetic = item['phoneticLang']?.toString() ?? '';
        final context = item['additionalContext']?.toString() ?? '';

        if (defLang.isNotEmpty && trans.isNotEmpty) {
          result.add(
            EuyCardModel(
              idCard: 'c_${randomChar(8)}',
              defaultLanguage: defLang,
              translation: trans,
              phoneticLang: phonetic,
              additionalContext: context,
              reps: 0,
              correctAnswer: 0,
              finalScore: 0,
            ),
          );
        }
      }
    }

    return result;
  }

  /// Builds a complete [EuyDeckModel] conforming to `euy_schema.json`.
  static EuyDeckModel buildEuyDeck({
    required DeckGenerationRequest request,
    required String? generatedName,
    required String? generatedExplanation,
    required List<EuyCardModel> cards,
  }) {
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final deckId = 'gen_${nowMs}_${randomChar(8)}';

    final name = (generatedName != null && generatedName.trim().isNotEmpty)
        ? generatedName.trim()
        : request.name;

    final explanation =
        (generatedExplanation != null && generatedExplanation.trim().isNotEmpty)
        ? generatedExplanation.trim()
        : (request.description.isNotEmpty
              ? request.description
              : 'Kosakata harian terstruktur');

    return EuyDeckModel(
      id: deckId,
      name: name,
      language: request.language,
      difficulty: request.difficulty,
      rolePlay: 'AI generated assistant',
      explanationRolePlay: explanation,
      listCards: cards,
    );
  }
}
