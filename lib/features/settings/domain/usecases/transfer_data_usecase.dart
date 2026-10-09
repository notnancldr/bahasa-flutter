import 'package:bahasa/core/errors/settings_error.dart';
import 'package:bahasa/features/settings/domain/entities/data_transfer_result.dart';
import 'package:bahasa/features/settings/domain/repositories/data_storage_repository.dart';

class TransferDataUseCase {
  final DataStorageRepository _repository;
  const TransferDataUseCase(this._repository);

  Future<DataTransferResult> call(String receiverCode) {
    final trimmed = receiverCode.trim();
    if (trimmed.isEmpty) {
      throw const DataTransferFailure('Receiver code cannot be empty.');
    }
    return _repository.transferData(receiverCode: trimmed);
  }
}

