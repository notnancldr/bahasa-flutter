import 'package:bahasa/features/settings/data/datasources/data_storage_local_data_source.dart';
import 'package:bahasa/features/settings/data/datasources/profile_local_data_source.dart';
import 'package:bahasa/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:bahasa/features/settings/data/repositories/data_storage_repository_impl.dart';
import 'package:bahasa/features/settings/data/repositories/profile_repository_impl.dart';
import 'package:bahasa/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:bahasa/features/settings/domain/repositories/data_storage_repository.dart';
import 'package:bahasa/features/settings/domain/repositories/profile_repository.dart';
import 'package:bahasa/features/settings/domain/repositories/settings_repository.dart';
import 'package:bahasa/features/settings/domain/usecases/delete_app_data_usecase.dart';
import 'package:bahasa/features/settings/domain/usecases/delete_profile_usecase.dart';
import 'package:bahasa/features/settings/domain/usecases/get_notification_settings_usecase.dart';
import 'package:bahasa/features/settings/domain/usecases/get_profile_usecase.dart';
import 'package:bahasa/features/settings/domain/usecases/get_theme_mode_usecase.dart';
import 'package:bahasa/features/settings/domain/usecases/pick_profile_photo_usecase.dart';
import 'package:bahasa/features/settings/domain/usecases/set_notification_settings_usecase.dart';
import 'package:bahasa/features/settings/domain/usecases/set_theme_mode_usecase.dart';
import 'package:bahasa/features/settings/domain/usecases/transfer_data_usecase.dart';
import 'package:bahasa/features/settings/domain/usecases/update_profile_photo_usecase.dart';
import 'package:bahasa/features/settings/domain/usecases/update_username_usecase.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_bloc.dart';
import 'package:bahasa/features/settings/presentation/bloc/data_storage/data_storage_bloc.dart';
import 'package:bahasa/features/settings/presentation/bloc/notification/notification_bloc.dart';
import 'package:bahasa/features/settings/presentation/bloc/theme/theme_bloc.dart';

/// Lightweight dependency factory for the Settings feature.
class SettingsDependencies {
  static ProfileLocalDataSource? _profileDataSource;
  static SettingsLocalDataSource? _settingsDataSource;
  static DataStorageLocalDataSource? _dataStorageDataSource;

  static ProfileLocalDataSource get profileDataSource =>
      _profileDataSource ??= ProfileLocalDataSourceImpl();

  static SettingsLocalDataSource get settingsDataSource =>
      _settingsDataSource ??= SettingsLocalDataSourceImpl();

  static DataStorageLocalDataSource get dataStorageDataSource =>
      _dataStorageDataSource ??= DataStorageLocalDataSourceImpl();

  static ProfileRepository createProfileRepository() {
    return ProfileRepositoryImpl(
      profileDataSource: profileDataSource,
      dataStorageDataSource: dataStorageDataSource,
    );
  }

  static SettingsRepository createSettingsRepository() {
    return SettingsRepositoryImpl(
      settingsDataSource: settingsDataSource,
    );
  }

  static DataStorageRepository createDataStorageRepository() {
    return DataStorageRepositoryImpl(
      dataStorageDataSource: dataStorageDataSource,
      profileDataSource: profileDataSource,
    );
  }

  static AccountBloc createAccountBloc({ProfileRepository? repository}) {
    final repo = repository ?? createProfileRepository();
    return AccountBloc(
      getProfileUseCase: GetProfileUseCase(repo),
      updateUsernameUseCase: UpdateUsernameUseCase(repo),
      updateProfilePhotoUseCase: UpdateProfilePhotoUseCase(repo),
      pickProfilePhotoUseCase: PickProfilePhotoUseCase(repo),
      deleteProfileUseCase: DeleteProfileUseCase(repo),
    );
  }

  static ThemeBloc createThemeBloc({SettingsRepository? repository}) {
    final repo = repository ?? createSettingsRepository();
    return ThemeBloc(
      getThemeModeUseCase: GetThemeModeUseCase(repo),
      setThemeModeUseCase: SetThemeModeUseCase(repo),
    );
  }

  static NotificationBloc createNotificationBloc({SettingsRepository? repository}) {
    final repo = repository ?? createSettingsRepository();
    return NotificationBloc(
      getNotificationSettingsUseCase: GetNotificationSettingsUseCase(repo),
      setNotificationSettingsUseCase: SetNotificationSettingsUseCase(repo),
    );
  }

  static DataStorageBloc createDataStorageBloc({DataStorageRepository? repository}) {
    final repo = repository ?? createDataStorageRepository();
    return DataStorageBloc(
      transferDataUseCase: TransferDataUseCase(repo),
      deleteAppDataUseCase: DeleteAppDataUseCase(repo),
    );
  }
}

