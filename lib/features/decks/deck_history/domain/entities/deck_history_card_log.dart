/// Represents a card log entry within a completed study session.
class DeckHistoryCardLog {
  /// Unique log row identifier.
  final String logId;

  /// Card identifier.
  final String cardId;

  /// Front term in the card's default language.
  final String defaultLanguage;

  /// Back translation of the card.
  final String translation;

  /// Optional phonetic representation.
  final String? phoneticLang;

  /// Whether the user answered correctly or marked as memorized.
  final bool isCorrect;

  /// Time spent answering or reviewing this card in milliseconds.
  final int timeSpentMs;

  /// Timestamp when the answer was recorded.
  final DateTime timestamp;

  /// Creates a [DeckHistoryCardLog].
  const DeckHistoryCardLog({
    required this.logId,
    required this.cardId,
    required this.defaultLanguage,
    required this.translation,
    this.phoneticLang,
    required this.isCorrect,
    required this.timeSpentMs,
    required this.timestamp,
  });
}
