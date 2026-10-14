import '../entities/deck_generation_request.dart';
import '../entities/generated_deck_result.dart';
import '../repositories/generate_deck_repository.dart';

/// Use case that orchestrates deck generation.
class GenerateDeckUseCase {
  final GenerateDeckRepository _repository;

  const GenerateDeckUseCase(this._repository);

  Future<GeneratedDeckResult> call(DeckGenerationRequest request) =>
      _repository.generateDeck(request);
}
