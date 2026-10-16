import '../../domain/entities/deck_history_card_log.dart';
import '../../domain/entities/deck_history_item.dart';
import '../../domain/entities/deck_history_period.dart';
import '../../domain/entities/deck_history_summary.dart';
import '../../domain/repositories/deck_history_repository.dart';
import '../datasources/deck_history_local_data_source.dart';

/// Implementation of [DeckHistoryRepository] backed by [DeckHistoryLocalDataSource].
class DeckHistoryRepositoryImpl implements DeckHistoryRepository {
  final DeckHistoryLocalDataSource _localDataSource;

  /// Creates a [DeckHistoryRepositoryImpl].
  const DeckHistoryRepositoryImpl({required this._localDataSource});

  @override
  Future<List<DeckHistoryItem>> getHistoryItems({
    String? deckId,
    required DeckHistoryPeriod period,
    DateTime? referenceDate,
  }) async {
    final (startEpochMs, endEpochMs) = _resolveDateRange(
      period: period,
      referenceDate: referenceDate,
    );

    return _localDataSource.getSessionsForRange(
      deckId: deckId,
      startEpochMs: startEpochMs,
      endEpochMs: endEpochMs,
    );
  }

  @override
  Future<DeckHistorySummary> getHistorySummary({
    String? deckId,
    required DeckHistoryPeriod period,
    DateTime? referenceDate,
  }) async {
    final items = await getHistoryItems(
      deckId: deckId,
      period: period,
      referenceDate: referenceDate,
    );

    if (items.isEmpty) {
      return DeckHistorySummary.empty;
    }

    final totalActivities = items.length;
    final totalDurationMs = items.fold<int>(
      0,
      (sum, item) => sum + item.durationMs,
    );

    final totalQuestions = items.fold<int>(
      0,
      (sum, item) => sum + item.totalQuestions,
    );
    final totalCorrect = items.fold<int>(
      0,
      (sum, item) => sum + item.correctCount,
    );

    final averageAccuracy = totalQuestions > 0
        ? ((totalCorrect * 100) / totalQuestions).round().clamp(0, 100)
        : 0;

    return DeckHistorySummary(
      totalActivities: totalActivities,
      totalDurationMs: totalDurationMs,
      averageAccuracy: averageAccuracy,
    );
  }

  @override
  Future<List<DeckHistoryCardLog>> getSessionCardLogs({
    required String deckId,
    required String sessionId,
  }) {
    return _localDataSource.getSessionCardLogs(
      deckId: deckId,
      sessionId: sessionId,
    );
  }

  /// Calculates the inclusive timestamp boundary `(startEpochMs, endEpochMs)` for [period].
  (int, int) _resolveDateRange({
    required DeckHistoryPeriod period,
    DateTime? referenceDate,
  }) {
    final now = referenceDate ?? DateTime.now();

    switch (period) {
      case DeckHistoryPeriod.week:
        final startOfWeek = DateTime(
          now.year,
          now.month,
          now.day - (now.weekday - 1),
        );
        final endOfWeek = DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day + 6,
          23,
          59,
          59,
          999,
        );
        return (
          startOfWeek.millisecondsSinceEpoch,
          endOfWeek.millisecondsSinceEpoch,
        );

      case DeckHistoryPeriod.month:
        final startOfMonth = DateTime(now.year, now.month, 1);
        final endOfMonth = DateTime(
          now.year,
          now.month + 1,
          0,
          23,
          59,
          59,
          999,
        );
        return (
          startOfMonth.millisecondsSinceEpoch,
          endOfMonth.millisecondsSinceEpoch,
        );

      case DeckHistoryPeriod.year:
        final startOfYear = DateTime(now.year, 1, 1);
        final endOfYear = DateTime(now.year, 12, 31, 23, 59, 59, 999);
        return (
          startOfYear.millisecondsSinceEpoch,
          endOfYear.millisecondsSinceEpoch,
        );
    }
  }
}
