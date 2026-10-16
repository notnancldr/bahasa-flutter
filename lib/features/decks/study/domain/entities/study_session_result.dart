/// Summary result of a completed Flashcard or Quiz study session.
class StudySessionResult {
  /// Unique identifier of the session in `sessions`.
  final String sessionId;

  /// Deck identifier studied in this session.
  final String deckId;

  /// Game mode (`'flashcard'` or `'quiz'`).
  final String gameType;

  /// Total number of questions answered in the session.
  final int totalQuestions;

  /// Number of questions answered correctly / memorized.
  final int correctCount;

  /// Number of questions answered incorrectly / not memorized.
  final int wrongCount;

  /// Total active duration of the session in milliseconds.
  final int durationMs;

  /// Ordered list of per-question outcomes (`true` = correct/memorized, `false` = wrong).
  final List<bool> outcomes;

  /// Creates a [StudySessionResult].
  const StudySessionResult({
    required this.sessionId,
    required this.deckId,
    required this.gameType,
    required this.totalQuestions,
    required this.correctCount,
    required this.wrongCount,
    required this.durationMs,
    required this.outcomes,
  });

  /// Whole minutes component of [durationMs].
  int get durationMinutes => (durationMs ~/ 60000).clamp(0, 999);

  /// Remaining seconds component of [durationMs] (at least 1s if duration > 0 and minutes == 0).
  int get durationSeconds {
    final totalSecs = (durationMs / 1000).ceil();
    final secs = totalSecs % 60;
    if (durationMinutes == 0 && secs == 0) return 1;
    return secs;
  }
}
