import '../entities/deck_history_card_log.dart';
import '../entities/deck_history_item.dart';
import '../entities/deck_history_period.dart';
import '../entities/deck_history_summary.dart';

/// Repository interface contract for retrieving study activity history and session logs.
abstract class DeckHistoryRepository {
  /// Retrieves a list of completed study session items for [period].
  ///
  /// If [deckId] is provided, queries only sessions belonging to that deck.
  /// If [deckId] is null, aggregates sessions across all available decks.
  Future<List<DeckHistoryItem>> getHistoryItems({
    String? deckId,
    required DeckHistoryPeriod period,
    DateTime? referenceDate,
  });

  /// Calculates summary metrics (session count, active duration, avg accuracy) for [period].
  Future<DeckHistorySummary> getHistorySummary({
    String? deckId,
    required DeckHistoryPeriod period,
    DateTime? referenceDate,
  });

  /// Retrieves the detailed card-by-card question logs for a specific [sessionId] in [deckId].
  Future<List<DeckHistoryCardLog>> getSessionCardLogs({
    required String deckId,
    required String sessionId,
  });
}
