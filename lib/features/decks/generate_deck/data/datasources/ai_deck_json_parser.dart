import 'dart:convert';

import 'package:bahasa/core/utils/random_char.dart';
import 'package:bahasa/features/decks/generate_deck/domain/entities/deck_generation_request.dart';
import 'package:bahasa/features/decks/import_deck/data/models/euy_card_model.dart';
import 'package:bahasa/features/decks/import_deck/data/models/euy_deck_model.dart';

/// Helper to parse, repair, and normalize AI generated JSON outputs into [EuyDeckModel].
class AiDeckJsonParser {
  const AiDeckJsonParser();

  /// Cleans raw text response from AI (strips markdown formatting if any) and decodes JSON.
  /// Automatically repairs truncated JSON outputs if text was cut off mid-response.
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

    final startIdx = cleaned.indexOf('{');
    if (startIdx != -1) {
      cleaned = cleaned.substring(startIdx);
    }

    // 1. Try direct standard JSON decode
    try {
      final decoded = jsonDecode(cleaned);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {}

    // 2. Attempt automatic truncated JSON repair
    final repaired = _tryRepairTruncatedJson(cleaned);
    if (repaired != null) {
      return repaired;
    }

    // 3. Fallback bound clipping
    final endIdx = cleaned.lastIndexOf('}');
    if (endIdx != -1 && endIdx > 0) {
      final clipped = cleaned.substring(0, endIdx + 1);
      try {
        final decoded = jsonDecode(clipped);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
      } catch (_) {}
    }

    throw FormatException(
      'Failed to parse AI JSON response: $rawText',
    );
  }

  static Map<String, dynamic>? _tryRepairTruncatedJson(String text) {
    final cardsMarker = text.indexOf('"cards"');
    if (cardsMarker == -1) return null;

    final lastObjectEnd = text.lastIndexOf('}');
    if (lastObjectEnd <= cardsMarker) return null;

    var candidate = text.substring(0, lastObjectEnd + 1).trimRight();
    if (candidate.endsWith(',')) {
      candidate = candidate.substring(0, candidate.length - 1).trimRight();
    }

    if (!candidate.endsWith(']}')) {
      candidate = '$candidate]}';
    }

    try {
      final decoded = jsonDecode(candidate);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {}

    return null;
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
