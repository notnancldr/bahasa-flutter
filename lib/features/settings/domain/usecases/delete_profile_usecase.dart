import 'package:bahasa/features/settings/domain/repositories/profile_repository.dart';

class DeleteProfileUseCase {
  final ProfileRepository _repository;
  const DeleteProfileUseCase(this._repository);

  Future<void> call() => _repository.deleteProfileAndData();
}
