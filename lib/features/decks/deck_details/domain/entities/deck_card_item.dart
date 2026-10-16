/// Domain entity representing a single flashcard stored in a per-deck SQLite database.
class DeckCardItem {
  /// Unique identifier of the card (`idCard`).
  final String idCard;

  /// Meaning or phrase in the user's default language (`defaultLanguage`).
  final String defaultLanguage;

  /// Target language word or phrase (`translation`).
  final String translation;

  /// Phonetic transcription or pronunciation reading (`phoneticLang`).
  final String phoneticLang;

  /// Additional usage context or explanation (`additionalContext`).
  final String additionalContext;

  /// Total number of study repetitions recorded for this card.
  final int reps;

  /// Total number of correct answers recorded for this card.
  final int correctAnswer;

  /// Mastery score percentage (0 to 100).
  final int finalScore;

  /// Creates a [DeckCardItem].
  const DeckCardItem({
    required this.idCard,
    required this.defaultLanguage,
    required this.translation,
    required this.phoneticLang,
    required this.additionalContext,
    required this.reps,
    required this.correctAnswer,
    required this.finalScore,
  });

  /// Number of incorrect answers recorded for this card.
  int get wrongCount => (reps - correctAnswer).clamp(0, reps);

  /// Computed accuracy percentage (0 to 100) based on [correctAnswer] and [reps].
  int get accuracyPercent =>
      reps > 0 ? ((correctAnswer * 100) / reps).round().clamp(0, 100) : 0;
}
