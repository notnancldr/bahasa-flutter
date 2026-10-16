import 'package:bahasa/features/decks/generate_deck/data/datasources/ai_deck_json_parser.dart';
import 'package:bahasa/features/decks/generate_deck/domain/entities/deck_generation_request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AiDeckJsonParser', () {
    test('cleanAndDecodeJson parses plain json correctly', () {
      const raw = '{"name": "Belajar Jepang", "listCards": []}';
      final parsed = AiDeckJsonParser.cleanAndDecodeJson(raw);
      expect(parsed['name'], equals('Belajar Jepang'));
      expect(parsed['listCards'], isEmpty);
    });

    test(
      'cleanAndDecodeJson strips ```json markdown blocks and surrounding text',
      () {
        const raw = '''
Here is your requested deck output:
```json
{
  "name": "JLPT N5 Vocab",
  "explanationRolePlay": "Basic Japanese vocabularies",
  "listCards": [
    {
      "defaultLanguage": "Neko",
      "translation": "Kucing",
      "phoneticLang": "ねこ",
      "additionalContext": "Hewan peliharaan"
    }
  ]
}
```
Hope you enjoy learning!
''';
        final parsed = AiDeckJsonParser.cleanAndDecodeJson(raw);
        expect(parsed['name'], equals('JLPT N5 Vocab'));
        expect(
          parsed['explanationRolePlay'],
          equals('Basic Japanese vocabularies'),
        );
        final cards = parsed['listCards'] as List<dynamic>;
        expect(cards.length, equals(1));
      },
    );

    test(
      'cleanAndDecodeJson throws FormatException on invalid json or non-object',
      () {
        expect(
          () => AiDeckJsonParser.cleanAndDecodeJson('Not a JSON string'),
          throwsA(isA<FormatException>()),
        );
        expect(
          () => AiDeckJsonParser.cleanAndDecodeJson('[1, 2, 3]'),
          throwsA(isA<FormatException>()),
        );
      },
    );

    test(
      'parseCards parses valid items and ignores malformed/empty entries',
      () {
        final rawCards = [
          {
            'defaultLanguage': 'Inu',
            'translation': 'Anjing',
            'phoneticLang': 'いぬ',
            'additionalContext': 'Sahabat manusia',
          },
          // Missing translation -> should be filtered out
          {'defaultLanguage': 'Tori', 'translation': ''},
          // Non-map element -> should be ignored
          'invalid item',
        ];

        final cards = AiDeckJsonParser.parseCards(rawCards);
        expect(cards.length, equals(1));
        expect(cards.first.defaultLanguage, equals('Inu'));
        expect(cards.first.translation, equals('Anjing'));
        expect(cards.first.phoneticLang, equals('いぬ'));
        expect(cards.first.additionalContext, equals('Sahabat manusia'));
        expect(cards.first.idCard, startsWith('c_'));
        expect(cards.first.reps, equals(0));
        expect(cards.first.correctAnswer, equals(0));
        expect(cards.first.finalScore, equals(0));
      },
    );

    test(
      'buildEuyDeck constructs EuyDeckModel with generated values and fallback',
      () {
        const request = DeckGenerationRequest(
          name: 'Japanese Basics',
          language: 'Japanese',
          difficulty: 'beginner',
          description: 'Original description',
        );

        final cards = AiDeckJsonParser.parseCards([
          {'defaultLanguage': 'Mizu', 'translation': 'Air'},
        ]);

        // Case 1: Provided generated name and explanation
        final deck1 = AiDeckJsonParser.buildEuyDeck(
          request: request,
          generatedName: 'JLPT N5 Kanji & Vocab',
          generatedExplanation: 'Essential Kanji and words for N5',
          cards: cards,
        );

        expect(deck1.name, equals('JLPT N5 Kanji & Vocab'));
        expect(
          deck1.explanationRolePlay,
          equals('Essential Kanji and words for N5'),
        );
        expect(deck1.language, equals('Japanese'));
        expect(deck1.difficulty, equals('beginner'));
        expect(deck1.listCards.length, equals(1));
        expect(deck1.id, startsWith('gen_'));

        // Case 2: Null generated name and explanation -> fall back to request
        final deck2 = AiDeckJsonParser.buildEuyDeck(
          request: request,
          generatedName: null,
          generatedExplanation: null,
          cards: cards,
        );

        expect(deck2.name, equals('Japanese Basics'));
        expect(deck2.explanationRolePlay, equals('Original description'));
      },
    );
  });
}
