import 'package:bahasa/features/settings/domain/entities/user_profile.dart';
import 'package:bahasa/features/settings/domain/repositories/profile_repository.dart';

class SetDefaultLanguageUsecase {
  final ProfileRepository _repository;
  const SetDefaultLanguageUsecase(this._repository);

  Future<UserProfile> call(String newLanguage) =>
      _repository.updateDefaultLanguage(newLanguage);
}
