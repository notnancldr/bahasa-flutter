/// Represents a vocabulary card item defined within an `.euy` deck file.
class EuyCard {
  /// Unique identifier of the card.
  final String idCard;

  /// Original term or phrase text.
  final String defaultLanguage;

  /// Translated text.
  final String translation;

  /// Phonetic transcription or pronunciation guide.
  final String phoneticLang;

  /// Extra usage context, grammatical explanation, or notes.
  final String additionalContext;

  /// Total repetitions completed for this card.
  final int reps;

  /// Total number of correct answers for this card.
  final int correctAnswer;

  /// Final retention mastery score.
  final int finalScore;

  const EuyCard({
    required this.idCard,
    required this.defaultLanguage,
    required this.translation,
    required this.phoneticLang,
    required this.additionalContext,
    required this.reps,
    required this.correctAnswer,
    required this.finalScore,
  });
}
