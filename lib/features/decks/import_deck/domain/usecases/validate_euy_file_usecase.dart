import '../entities/euy_validation_result.dart';
import '../repositories/import_deck_repository.dart';

/// Use case that validates an `.euy` file against the schema requirements.
class ValidateEuyFileUseCase {
  final ImportDeckRepository _repository;

  const ValidateEuyFileUseCase(this._repository);

  Future<EuyValidationResult> call(String filePath) =>
      _repository.validateFile(filePath);
}
