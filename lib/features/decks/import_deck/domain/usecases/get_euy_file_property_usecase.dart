import '../entities/euy_file_property.dart';
import '../repositories/import_deck_repository.dart';

/// Use case that retrieves basic file metadata (name and formatted size)
/// without executing heavy JSON and schema validation.
class GetEuyFilePropertyUseCase {
  final ImportDeckRepository _repository;

  const GetEuyFilePropertyUseCase(this._repository);

  Future<EuyFileProperty> call(String filePath) =>
      _repository.getFileProperty(filePath);
}
