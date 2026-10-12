import 'package:bahasa/features/login/domain/repositories/transfer_repository.dart';

class CancelTransferUseCase {
  final TransferRepository _repository;

  const CancelTransferUseCase(this._repository);

  Future<void> call([String? tempFilePath]) async {
    await _repository.cancelServer();
    await _repository.cleanupTempFiles(tempFilePath);
  }
}

