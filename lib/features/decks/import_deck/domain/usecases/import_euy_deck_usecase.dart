import '../entities/euy_deck.dart';
import '../repositories/import_deck_repository.dart';

/// Use case that commits an [EuyDeck] into the main and deck databases.
class ImportEuyDeckUseCase {
  final ImportDeckRepository _repository;

  const ImportEuyDeckUseCase(this._repository);

  Future<void> call(EuyDeck deck) => _repository.importDeck(deck);
}
