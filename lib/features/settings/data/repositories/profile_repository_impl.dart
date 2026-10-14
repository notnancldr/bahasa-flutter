import 'package:bahasa/core/errors/settings_error.dart';
import 'package:bahasa/features/settings/data/datasources/data_storage_local_data_source.dart';
import 'package:bahasa/features/settings/data/datasources/profile_local_data_source.dart';
import 'package:bahasa/features/settings/data/models/user_profile_model.dart';
import 'package:bahasa/features/settings/domain/entities/user_profile.dart';
import 'package:bahasa/features/settings/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource _profileDataSource;
  final DataStorageLocalDataSource _dataStorageDataSource;

  ProfileRepositoryImpl({
    required this._profileDataSource,
    required this._dataStorageDataSource,
  });

  @override
  Future<UserProfile> getProfile() async {
    return _profileDataSource.getProfile();
  }

  @override
  Future<UserProfile> saveProfile(UserProfile profile) async {
    final model = UserProfileModel.fromEntity(profile);
    return _profileDataSource.saveProfile(model);
  }

  @override
  Future<UserProfile> updateUsername(String newUsername) async {
    final current = await _profileDataSource.getProfile();
    final updated = UserProfileModel(
      username: newUsername,
      defaultLanguage: current.defaultLanguage,
      photoPath: current.photoPath,
      updatedAt: DateTime.now(),
    );
    return _profileDataSource.saveProfile(updated);
  }

  @override
  Future<UserProfile> updateDefaultLanguage(String newDefaultLanguage) async {
    final current = await _profileDataSource.getProfile();
    final updated = UserProfileModel(
      username: current.username,
      defaultLanguage: newDefaultLanguage,
      photoPath: current.photoPath,
      updatedAt: DateTime.now(),
    );
    return _profileDataSource.saveProfile(updated);
  }

  @override
  Future<UserProfile> updateProfilePhoto(String photoPath) async {
    final current = await _profileDataSource.getProfile();
    final updated = UserProfileModel(
      username: current.username,
      defaultLanguage: current.defaultLanguage,
      photoPath: photoPath,
      updatedAt: DateTime.now(),
    );
    return _profileDataSource.saveProfile(updated);
  }

  @override
  Future<String?> pickProfilePhoto() async {
    final path = await _profileDataSource.pickProfilePhoto();
    if (path == null) {
      throw const FileNotFoundFailure('No photo was selected.');
    }
    return path;
  }

  @override
  Future<void> deleteProfileAndData() async {
    // ACC-06: Delete profile and entire application data
    await _profileDataSource.clearProfile();
    await _dataStorageDataSource.deleteAllApplicationData();
  }
}
