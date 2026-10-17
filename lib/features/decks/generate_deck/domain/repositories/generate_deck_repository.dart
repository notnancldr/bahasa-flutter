import '../entities/deck_generation_request.dart';
import '../entities/generated_deck_result.dart';

/// Repository interface handling AI deck generation and persistence.
abstract class GenerateDeckRepository {
  /// Generates cards based on [request] and records them into local SQLite databases.
  Future<GeneratedDeckResult> generateDeck(
    DeckGenerationRequest request, {
    void Function(int collected, int total)? onProgress,
  });
}
