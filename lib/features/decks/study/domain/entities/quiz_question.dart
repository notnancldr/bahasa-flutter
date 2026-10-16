import 'package:bahasa/features/decks/deck_details/domain/entities/deck_card_item.dart';

/// Supported question formats in the Quiz game.
enum QuizQuestionType {
  /// Translating question with 4 multiple-choice options.
  multipleChoice,

  /// Writing / word arrangement question where the user assembles word tokens.
  jumbleWords,
}

/// Domain entity representing a single generated question in a Quiz session.
class QuizQuestion {
  /// The target vocabulary card being tested.
  final DeckCardItem card;

  /// Question interaction format.
  final QuizQuestionType type;

  /// 4 multiple-choice options (used when [type] is [QuizQuestionType.multipleChoice]).
  final List<String> options;

  /// Target answer split into ordered words (used when [type] is [QuizQuestionType.jumbleWords]).
  final List<String> targetWords;

  /// Shuffled word bank including [targetWords] and distractor words.
  final List<String> wordBank;

  /// Canonical expected answer string (`card.defaultLanguage`).
  final String correctAnswer;

  /// Creates a [QuizQuestion].
  const QuizQuestion({
    required this.card,
    required this.type,
    required this.options,
    required this.targetWords,
    required this.wordBank,
    required this.correctAnswer,
  });

  /// Database log label for this question type (`'translating'` or `'writing'`).
  String get dbQuestionType =>
      type == QuizQuestionType.multipleChoice ? 'translating' : 'writing';
}
