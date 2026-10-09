sealed class DataStorageEvent {
  const DataStorageEvent();
}

// --- Data Transfer Events ---
class StartDataTransferEvent extends DataStorageEvent {
  final String receiverCode;
  const StartDataTransferEvent(this.receiverCode);
}

class RetryDataTransferEvent extends DataStorageEvent {
  const RetryDataTransferEvent();
}

class CancelDataTransferEvent extends DataStorageEvent {
  const CancelDataTransferEvent();
}

// --- Delete Data Events ---
class RequestDeleteDataConfirmationEvent extends DataStorageEvent {
  const RequestDeleteDataConfirmationEvent();
}

class ConfirmDeleteDataFirstStepEvent extends DataStorageEvent {
  const ConfirmDeleteDataFirstStepEvent();
}

class VerifyAndExecuteDeleteDataEvent extends DataStorageEvent {
  final String verificationUsername;
  const VerifyAndExecuteDeleteDataEvent(this.verificationUsername);
}

class CancelDeleteDataEvent extends DataStorageEvent {
  const CancelDeleteDataEvent();
}

class ResetDataStorageStateEvent extends DataStorageEvent {
  const ResetDataStorageStateEvent();
}

