import 'package:bahasa/features/settings/domain/repositories/profile_repository.dart';

class PickProfilePhotoUseCase {
  final ProfileRepository _repository;
  const PickProfilePhotoUseCase(this._repository);

  Future<String?> call() => _repository.pickProfilePhoto();
}
