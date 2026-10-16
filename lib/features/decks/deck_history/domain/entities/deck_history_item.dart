/// Represents a single completed study session item in the history list.
class DeckHistoryItem {
  /// Unique session identifier.
  final String sessionId;

  /// Identifier of the deck studied in this session.
  final String deckId;

  /// Display name of the deck.
  final String deckName;

  /// Game type played in this session (e.g. `'quiz'` or `'flashcard'`).
  final String gameType;

  /// Timestamp when the session was initiated.
  final DateTime startedAt;

  /// Timestamp when the session was finalized.
  final DateTime completedAt;

  /// Total number of questions or cards encountered in the session.
  final int totalQuestions;

  /// Total count of correct answers or memorized cards.
  final int correctCount;

  /// Final accuracy score percentage (0.0 to 100.0).
  final double finalScore;

  /// Total duration elapsed during the session in milliseconds.
  final int durationMs;

  /// Creates a [DeckHistoryItem].
  const DeckHistoryItem({
    required this.sessionId,
    required this.deckId,
    required this.deckName,
    required this.gameType,
    required this.startedAt,
    required this.completedAt,
    required this.totalQuestions,
    required this.correctCount,
    required this.finalScore,
    required this.durationMs,
  });

  /// Whether this session was a quiz game.
  bool get isQuiz => gameType.toLowerCase() == 'quiz';

  /// Whether this session was a flashcard game.
  bool get isFlashcard => gameType.toLowerCase() == 'flashcard';
}
