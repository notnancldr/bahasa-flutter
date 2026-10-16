import 'package:bahasa/features/settings/domain/entities/user_profile.dart';

abstract class ProfileRepository {
  /// Retrieves the current user profile.
  Future<UserProfile> getProfile();

  /// Saves or creates a full user profile.
  Future<UserProfile> saveProfile(UserProfile profile);

  /// Updates the username.
  Future<UserProfile> updateUsername(String newUsername);

  /// Updates defaultLanguage.
  Future<UserProfile> updateDefaultLanguage(String newDefaultLanguage);

  /// Updates the profile photo path.
  Future<UserProfile> updateProfilePhoto(String photoPath);

  /// Launches local file access to pick an image from phone and returns its path.
  Future<String?> pickProfilePhoto();

  /// Checks if a valid user profile already exists.
  Future<bool> hasProfile();

  /// Deletes profile record and all app data.
  Future<void> deleteProfileAndData();
}
