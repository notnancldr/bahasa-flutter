import '../entities/deck_item.dart';
import '../repositories/deck_repository.dart';

/// Use case that retrieves all saved flashcard decks for the Deck Compilation page.
class GetDecksUseCase {
  final DeckRepository _repository;

  /// Creates a [GetDecksUseCase] backed by [_repository].
  const GetDecksUseCase(this._repository);

  /// Executes the use case and returns the list of saved [DeckItem]s.
  Future<List<DeckItem>> call() {
    return _repository.getDecks();
  }
}
