import '../repositories/deck_repository.dart';

/// Use case that validates the user's username and permanently deletes selected decks.
class DeleteDecksUseCase {
  final DeckRepository _repository;

  /// Creates a [DeleteDecksUseCase] backed by [_repository].
  const DeleteDecksUseCase(this._repository);

  /// Executes the deletion of [deckIds] after verifying [verificationUsername].
  Future<void> call({
    required List<String> deckIds,
    required String verificationUsername,
  }) {
    return _repository.deleteDecks(
      deckIds: deckIds,
      verificationUsername: verificationUsername,
    );
  }
}
