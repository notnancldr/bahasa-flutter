import 'package:bahasa/core/errors/settings_error.dart';
import 'package:bahasa/features/settings/data/datasources/data_storage_local_data_source.dart';
import 'package:bahasa/features/settings/data/datasources/profile_local_data_source.dart';
import 'package:bahasa/features/settings/domain/entities/data_transfer_result.dart';
import 'package:bahasa/features/settings/domain/repositories/data_storage_repository.dart';

class DataStorageRepositoryImpl implements DataStorageRepository {
  final DataStorageLocalDataSource _dataStorageDataSource;
  final ProfileLocalDataSource _profileDataSource;

  DataStorageRepositoryImpl({
    required this._dataStorageDataSource,
    required this._profileDataSource,
  });

  @override
  Future<DataTransferResult> transferData({
    required String receiverCode,
  }) async {
    return _dataStorageDataSource.transferData(receiverCode: receiverCode);
  }

  @override
  Future<void> deleteAppData({required String verificationUsername}) async {
    final profile = await _profileDataSource.getProfile();
    // DAT-05: User must type their username as final verification
    if (profile.username.trim() != verificationUsername.trim()) {
      throw const UsernameMismatchFailure(
        'The entered username does not match your current username.',
      );
    }

    // DAT-06: Data deleted from application directory
    await _dataStorageDataSource.deleteAppData();
  }
}
