import '../../domain/entities/deck_details_data.dart';
import '../../domain/entities/deck_progress_data.dart';
import '../../domain/repositories/deck_details_repository.dart';
import '../datasources/deck_details_local_data_source.dart';

/// Implementation of [DeckDetailsRepository] backed by [DeckDetailsLocalDataSource].
class DeckDetailsRepositoryImpl implements DeckDetailsRepository {
  final DeckDetailsLocalDataSource _localDataSource;

  /// Creates a [DeckDetailsRepositoryImpl].
  const DeckDetailsRepositoryImpl({
    this._localDataSource = const DeckDetailsLocalDataSourceImpl(),
  });

  @override
  Future<DeckDetailsData> getDeckDetails(String deckId) {
    return _localDataSource.getDeckDetails(deckId);
  }

  @override
  Future<DeckProgressData> getDeckProgress(
    String deckId, {
    DateTime? referenceDate,
  }) {
    return _localDataSource.getDeckProgress(
      deckId,
      referenceDate: referenceDate,
    );
  }

  @override
  Future<List<WeakCardSummary>> getWeakestCardsForRange(
    String deckId, {
    required int startEpochMs,
    required int endEpochMs,
  }) {
    return _localDataSource.getWeakestCardsForRange(
      deckId,
      startEpochMs: startEpochMs,
      endEpochMs: endEpochMs,
    );
  }
}
