import 'package:bahasa/core/errors/login_error.dart';
import 'package:bahasa/features/settings/domain/entities/user_profile.dart';
import 'package:bahasa/features/settings/domain/repositories/profile_repository.dart';

class ValidateLoginInputUseCase {
  const ValidateLoginInputUseCase();

  bool validateUsername(
    String? username, {
    int minLength = 3,
    int maxLength = 20,
  }) {
    if (username == null) return false;

    final trimmed = username.trim();
    if (trimmed.length < minLength || trimmed.length > maxLength) {
      return false;
    }

    final usernameRegExp = RegExp(
      r'^[a-zA-Z0-9](?!.*[.]{2})[a-zA-Z0-9.]*[a-zA-Z0-9]$',
    );
    return usernameRegExp.hasMatch(trimmed);
  }

  bool validateLanguage(String? language) {
    return RegExp(r'^\w{2}$').hasMatch(language ?? '');
  }
}

class SaveLoginProfileUseCase {
  final ProfileRepository? _profileRepository;

  const SaveLoginProfileUseCase([this._profileRepository]);

  Future<UserProfile?> call({
    required String? username,
    required String? language,
    required bool isUsernameValid,
    required bool isLanguageValid,
  }) async {
    if (!isUsernameValid ||
        !isLanguageValid ||
        username == null ||
        language == null) {
      throw LoginNotValid();
    }

    if (_profileRepository != null) {
      final newProfile = UserProfile(
        username: username.trim(),
        defaultLanguage: language,
        updatedAt: DateTime.now(),
      );
      return _profileRepository.saveProfile(newProfile);
    }
    return null;
  }
}
