import 'package:bahasa/core/errors/settings_error.dart';
import 'package:bahasa/features/settings/data/datasources/data_storage_local_data_source.dart';
import 'package:bahasa/features/settings/data/datasources/profile_local_data_source.dart';
import 'package:bahasa/features/settings/data/models/user_profile_model.dart';
import 'package:bahasa/features/settings/domain/entities/user_profile.dart';
import 'package:bahasa/features/settings/domain/repositories/profile_repository.dart';
import 'package:bahasa/features/settings/settings_dependencies.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource _profileDataSource;
  final DataStorageLocalDataSource _dataStorageDataSource;

  ProfileRepositoryImpl({
    ProfileLocalDataSource? profileDataSource,
    DataStorageLocalDataSource? dataStorageDataSource,
  }) : _profileDataSource =
           profileDataSource ?? ProfileLocalDataSourceImpl(),
       _dataStorageDataSource =
           dataStorageDataSource ?? DataStorageLocalDataSourceImpl();

  @override
  Future<UserProfile> getProfile() async {
    final profile = await _profileDataSource.getProfile();
    return profile;
  }

  @override
  Future<UserProfile> saveProfile(UserProfile profile) async {
    final model = UserProfileModel.fromEntity(profile);
    return _profileDataSource.saveProfile(model);
  }

  @override
  Future<UserProfile> updateUsername(String newUsername) async {
    final current = await getProfile();
    final updated = current.copyWith(username: newUsername);
    return saveProfile(updated);
  }

  @override
  Future<UserProfile> updateDefaultLanguage(String newDefaultLanguage) async {
    final current = await getProfile();
    final updated = current.copyWith(defaultLanguage: newDefaultLanguage);
    return saveProfile(updated);
  }

  @override
  Future<UserProfile> updateProfilePhoto(String photoPath) async {
    final current = await getProfile();
    final updated = current.copyWith(photoPath: photoPath);
    return saveProfile(updated);
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
  Future<bool> hasProfile() async {
    return _profileDataSource.hasProfile();
  }

  @override
  Future<void> deleteProfileAndData() async {
    // ACC-06: Delete profile and entire application data
    await _profileDataSource.clearProfile();
    await _dataStorageDataSource.deleteAllApplicationData();
    await SettingsDependencies.settingsDataSource.saveOnboardingCompleted(
      false,
    );
    await SettingsDependencies.settingsDataSource.resetOnlineDeckGeneration();
  }
}
