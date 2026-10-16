/// Summary statistics for study activities within a specified time period.
class DeckHistorySummary {
  /// Total number of completed study sessions.
  final int totalActivities;

  /// Aggregate duration of all sessions in milliseconds.
  final int totalDurationMs;

  /// Overall average accuracy percentage (0 to 100).
  final int averageAccuracy;

  /// Creates a [DeckHistorySummary].
  const DeckHistorySummary({
    required this.totalActivities,
    required this.totalDurationMs,
    required this.averageAccuracy,
  });

  /// An empty summary instance with zeroed metrics.
  static const DeckHistorySummary empty = DeckHistorySummary(
    totalActivities: 0,
    totalDurationMs: 0,
    averageAccuracy: 0,
  );
}
