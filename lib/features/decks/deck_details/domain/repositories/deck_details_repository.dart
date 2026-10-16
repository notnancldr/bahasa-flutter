import '../entities/deck_details_data.dart';
import '../entities/deck_progress_data.dart';

/// Repository contract for querying deck details, cards, and per-deck study progress.
abstract class DeckDetailsRepository {
  /// Loads the deck metadata, all cards, consecutive streak, and overall accuracy for [deckId].
  Future<DeckDetailsData> getDeckDetails(String deckId);

  /// Loads the progress breakdown (streaks, monthly/daily stats, weakest cards) for [deckId].
  Future<DeckProgressData> getDeckProgress(
    String deckId, {
    DateTime? referenceDate,
  });

  /// Queries the top 3 weakest cards for [deckId] within the epoch millisecond range
  /// `[startEpochMs, endEpochMs]`, falling back to overall card stats if no logs exist in range.
  Future<List<WeakCardSummary>> getWeakestCardsForRange(
    String deckId, {
    required int startEpochMs,
    required int endEpochMs,
  });
}
