import 'package:bahasa/features/settings/domain/entities/user_profile.dart';
import 'package:bahasa/features/settings/domain/repositories/profile_repository.dart';

class UpdateProfilePhotoUseCase {
  final ProfileRepository _repository;
  const UpdateProfilePhotoUseCase(this._repository);

  Future<UserProfile> call(String photoPath) =>
      _repository.updateProfilePhoto(photoPath);
}

