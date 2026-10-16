import '../../domain/entities/deck_history_card_log.dart';
import '../../domain/entities/deck_history_item.dart';
import '../../domain/entities/deck_history_period.dart';
import '../../domain/entities/deck_history_summary.dart';

/// Loading status enum for deck history state machine.
enum DeckHistoryStatus {
  /// Initial uninitialized state.
  initial,

  /// Asynchronously loading history and summary metrics.
  loading,

  /// Successfully loaded history and summary metrics.
  loaded,

  /// Failed to load history.
  error,
}

/// Immutable state for [DeckHistoryBloc].
class DeckHistoryState {
  /// Current lifecycle loading status.
  final DeckHistoryStatus status;

  /// Active deck filter, or null if showing global history.
  final String? deckId;

  /// Currently active period filter.
  final DeckHistoryPeriod period;

  /// Aggregated summary metrics for [period].
  final DeckHistorySummary summary;

  /// Completed study sessions within [period].
  final List<DeckHistoryItem> items;

  /// Currently loaded card question logs for bottom sheet inspection.
  final List<DeckHistoryCardLog> sessionLogs;

  /// Identifier of the session whose logs are currently loaded or being fetched.
  final String? selectedSessionId;

  /// Whether question logs are currently being fetched.
  final bool isLoadingLogs;

  /// Optional error message when status is [DeckHistoryStatus.error].
  final String? errorMessage;

  /// Creates a [DeckHistoryState].
  const DeckHistoryState({
    this.status = DeckHistoryStatus.initial,
    this.deckId,
    this.period = DeckHistoryPeriod.week,
    this.summary = DeckHistorySummary.empty,
    this.items = const [],
    this.sessionLogs = const [],
    this.selectedSessionId,
    this.isLoadingLogs = false,
    this.errorMessage,
  });

  /// Produces a copy of this state with specified fields updated.
  DeckHistoryState copyWith({
    DeckHistoryStatus? status,
    String? deckId,
    DeckHistoryPeriod? period,
    DeckHistorySummary? summary,
    List<DeckHistoryItem>? items,
    List<DeckHistoryCardLog>? sessionLogs,
    String? selectedSessionId,
    bool? isLoadingLogs,
    String? errorMessage,
  }) {
    return DeckHistoryState(
      status: status ?? this.status,
      deckId: deckId ?? this.deckId,
      period: period ?? this.period,
      summary: summary ?? this.summary,
      items: items ?? this.items,
      sessionLogs: sessionLogs ?? this.sessionLogs,
      selectedSessionId: selectedSessionId ?? this.selectedSessionId,
      isLoadingLogs: isLoadingLogs ?? this.isLoadingLogs,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
