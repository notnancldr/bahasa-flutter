import 'package:bahasa/features/login/domain/repositories/transfer_repository.dart';

class StartTransferServerUseCase {
  final TransferRepository _repository;

  const StartTransferServerUseCase(this._repository);

  Future<void> call() => _repository.startServer();
}
