import '../../domain/entities/deck_history_period.dart';

/// Base class for all Deck History events.
abstract class DeckHistoryEvent {
  const DeckHistoryEvent();
}

/// Event dispatched to load or reload study history and summary metrics.
class LoadDeckHistory extends DeckHistoryEvent {
  /// Target deck identifier, or null to query across all decks.
  final String? deckId;

  /// Target period to load (defaults to current period or week).
  final DeckHistoryPeriod? period;

  /// Creates a [LoadDeckHistory] event.
  const LoadDeckHistory({this.deckId, this.period});
}

/// Event dispatched when user toggles the period filter tab (week, month, year).
class ChangeHistoryPeriod extends DeckHistoryEvent {
  /// Selected period filter.
  final DeckHistoryPeriod period;

  /// Creates a [ChangeHistoryPeriod] event.
  const ChangeHistoryPeriod(this.period);
}

/// Event dispatched to fetch card-by-card question logs for a study session.
class LoadSessionLogs extends DeckHistoryEvent {
  /// Target deck identifier.
  final String deckId;

  /// Target session identifier.
  final String sessionId;

  /// Creates a [LoadSessionLogs] event.
  const LoadSessionLogs({required this.deckId, required this.sessionId});
}
