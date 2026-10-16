import 'package:bahasa/core/errors/settings_error.dart';
import 'package:bahasa/features/settings/domain/repositories/data_storage_repository.dart';

class DeleteAppDataUseCase {
  final DataStorageRepository _repository;
  const DeleteAppDataUseCase(this._repository);

  Future<void> call(String verificationUsername) {
    final trimmed = verificationUsername.trim();
    if (trimmed.isEmpty) {
      throw const UsernameMismatchFailure(
        'Verification username cannot be empty.',
      );
    }
    return _repository.deleteAppData(verificationUsername: trimmed);
  }
}
