import 'package:bahasa/features/settings/domain/entities/data_transfer_result.dart';

sealed class DataStorageState {
  const DataStorageState();
}

class DataStorageInitial extends DataStorageState {
  const DataStorageInitial();
}

// --- Data Transfer States ---
class DataTransferring extends DataStorageState {
  final String receiverCode;
  const DataTransferring(this.receiverCode);
}

class DataTransferSuccess extends DataStorageState {
  final DataTransferResult result;
  const DataTransferSuccess(this.result);
}

class DataTransferFailureState extends DataStorageState {
  final String message;
  final String lastReceiverCode;
  const DataTransferFailureState({
    required this.message,
    required this.lastReceiverCode,
  });
}

// --- Delete Data States ---
/// DAT-04: First confirmation prompt ("Are you sure to delete data?")
class DeleteDataFirstConfirmationPrompt extends DataStorageState {
  const DeleteDataFirstConfirmationPrompt();
}

/// DAT-05: Double confirmation prompt where user must type username as final verification
class DeleteDataUsernameVerificationPrompt extends DataStorageState {
  const DeleteDataUsernameVerificationPrompt();
}

class DeletingDataInProgress extends DataStorageState {
  const DeletingDataInProgress();
}

/// DAT-06: Data deleted, show finish alert and navigate to Home
class DeleteDataSuccess extends DataStorageState {
  const DeleteDataSuccess();
}

class DeleteDataFailureState extends DataStorageState {
  final String message;
  const DeleteDataFailureState(this.message);
}

