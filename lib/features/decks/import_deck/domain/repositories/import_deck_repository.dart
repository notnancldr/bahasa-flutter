import '../entities/euy_deck.dart';
import '../entities/euy_file_property.dart';
import '../entities/euy_validation_result.dart';

/// Repository interface managing `.euy` deck file selection, validation,
/// and persistence into local SQLite databases.
abstract class ImportDeckRepository {
  /// Prompts the user to pick an `.euy` file or returns a sample path.
  Future<String?> pickEuyFile();

  /// Retrieves metadata properties (name, size) for the file at [filePath]
  /// without parsing the full JSON contents.
  Future<EuyFileProperty> getFileProperty(String filePath);

  /// Validates the file at [filePath] against `euy_schema.json`.
  Future<EuyValidationResult> validateFile(String filePath);

  /// Saves the validated [deck] and its cards into `basa.sqlite` and `deck_<uuid>.sqlite`.
  Future<void> importDeck(EuyDeck deck);
}
