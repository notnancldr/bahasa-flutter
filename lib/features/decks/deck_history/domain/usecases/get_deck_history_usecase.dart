import '../entities/deck_history_item.dart';
import '../entities/deck_history_period.dart';
import '../entities/deck_history_summary.dart';
import '../repositories/deck_history_repository.dart';

/// Output model combining study sessions and summary metrics for a period.
class GetDeckHistoryResult {
  /// Aggregated summary metrics for the selected period.
  final DeckHistorySummary summary;

  /// Ordered list of completed study session items (newest first).
  final List<DeckHistoryItem> items;

  /// Creates a [GetDeckHistoryResult].
  const GetDeckHistoryResult({required this.summary, required this.items});
}

/// Use case that fetches both the summary metrics and session list for a given [period].
class GetDeckHistoryUseCase {
  final DeckHistoryRepository _repository;

  /// Creates a [GetDeckHistoryUseCase].
  const GetDeckHistoryUseCase(this._repository);

  /// Executes the history retrieval for the given [deckId] and [period].
  Future<GetDeckHistoryResult> call({
    String? deckId,
    required DeckHistoryPeriod period,
    DateTime? referenceDate,
  }) async {
    final items = await _repository.getHistoryItems(
      deckId: deckId,
      period: period,
      referenceDate: referenceDate,
    );

    final summary = await _repository.getHistorySummary(
      deckId: deckId,
      period: period,
      referenceDate: referenceDate,
    );

    return GetDeckHistoryResult(summary: summary, items: items);
  }
}
