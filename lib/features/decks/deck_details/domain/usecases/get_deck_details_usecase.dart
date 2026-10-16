import '../entities/deck_details_data.dart';
import '../repositories/deck_details_repository.dart';

/// Use case for retrieving a deck's details, cards list, and summary metrics.
class GetDeckDetailsUseCase {
  final DeckDetailsRepository _repository;

  /// Creates a [GetDeckDetailsUseCase].
  const GetDeckDetailsUseCase(this._repository);

  /// Executes the query for [deckId].
  Future<DeckDetailsData> call(String deckId) {
    return _repository.getDeckDetails(deckId);
  }
}
