import '../entities/deck_progress_data.dart';
import '../repositories/deck_details_repository.dart';

/// Use case for retrieving a deck's streak, accuracy, and period progress statistics.
class GetDeckProgressUseCase {
  final DeckDetailsRepository _repository;

  /// Creates a [GetDeckProgressUseCase].
  const GetDeckProgressUseCase(this._repository);

  /// Loads progress statistics for [deckId] relative to [referenceDate].
  Future<DeckProgressData> call(String deckId, {DateTime? referenceDate}) {
    return _repository.getDeckProgress(deckId, referenceDate: referenceDate);
  }

  /// Loads the top 3 weakest cards for [deckId] within `[startEpochMs, endEpochMs]`.
  Future<List<WeakCardSummary>> getWeakestCardsForRange(
    String deckId, {
    required int startEpochMs,
    required int endEpochMs,
  }) {
    return _repository.getWeakestCardsForRange(
      deckId,
      startEpochMs: startEpochMs,
      endEpochMs: endEpochMs,
    );
  }
}
