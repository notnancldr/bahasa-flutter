import 'package:bahasa/features/login/domain/entities/transfer_validation_result.dart';
import 'package:bahasa/features/login/domain/repositories/transfer_repository.dart';

class ValidateTransferredFileUseCase {
  final TransferRepository _repository;

  const ValidateTransferredFileUseCase(this._repository);

  Future<TransferValidationResult> call(String? tempFilePath) =>
      _repository.validateTransferredFile(tempFilePath);
}

