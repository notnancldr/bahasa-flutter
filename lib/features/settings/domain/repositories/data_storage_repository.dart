import 'package:bahasa/features/settings/domain/entities/data_transfer_result.dart';

abstract class DataStorageRepository {
  /// Executes atomic data transfer using a temporary directory.
  /// Cleans up temporary directory on completion or failure.
  Future<DataTransferResult> transferData({required String receiverCode});

  /// Deletes app data from application directory after verifying username.
  Future<void> deleteAppData({required String verificationUsername});
}

