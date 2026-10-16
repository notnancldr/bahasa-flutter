import '../entities/deck_item.dart';

/// Repository contract for querying and managing user flashcard decks.
abstract class DeckRepository {
  /// Retrieves all saved decks ordered by most recently studied or updated.
  Future<List<DeckItem>> getDecks();

  /// Permanently deletes the decks matching [deckIds] after verifying [verificationUsername].
  ///
  /// Throws a failure if [verificationUsername] does not match the active user profile.
  Future<void> deleteDecks({
    required List<String> deckIds,
    required String verificationUsername,
  });
}
