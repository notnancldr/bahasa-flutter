import 'package:bahasa/core/errors/settings_error.dart';
import 'package:bahasa/features/settings/domain/entities/user_profile.dart';
import 'package:bahasa/features/settings/domain/repositories/profile_repository.dart';

class UpdateUsernameUseCase {
  final ProfileRepository _repository;
  const UpdateUsernameUseCase(this._repository);

  Future<UserProfile> call(String newUsername) {
    final trimmed = newUsername.trim();
    if (trimmed.length < 3 || trimmed.length > 20) {
      throw const InvalidUsernameFailure(
        'Username must be between 3 and 20 characters.',
      );
    }
    return _repository.updateUsername(trimmed);
  }
}
