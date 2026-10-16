import 'package:bahasa/features/settings/domain/usecases/delete_app_data_usecase.dart';
import 'package:bahasa/features/settings/domain/usecases/transfer_data_usecase.dart';
import 'package:bahasa/features/settings/presentation/bloc/data_storage/data_storage_event.dart';
import 'package:bahasa/features/settings/presentation/bloc/data_storage/data_storage_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DataStorageBloc extends Bloc<DataStorageEvent, DataStorageState> {
  final TransferDataUseCase _transferDataUseCase;
  final DeleteAppDataUseCase _deleteAppDataUseCase;

  String? _lastReceiverCode;

  DataStorageBloc({
    required this._transferDataUseCase,
    required this._deleteAppDataUseCase,
  }) : super(const DataStorageInitial()) {
    on<StartDataTransferEvent>(_onStartDataTransfer);
    on<RetryDataTransferEvent>(_onRetryDataTransfer);
    on<CancelDataTransferEvent>(_onCancelDataTransfer);
    on<RequestDeleteDataConfirmationEvent>(_onRequestDeleteConfirmation);
    on<ConfirmDeleteDataFirstStepEvent>(_onConfirmDeleteFirstStep);
    on<VerifyAndExecuteDeleteDataEvent>(_onVerifyAndExecuteDeleteData);
    on<CancelDeleteDataEvent>(_onCancelDeleteData);
    on<ResetDataStorageStateEvent>(_onResetState);
  }

  Future<void> _onStartDataTransfer(
    StartDataTransferEvent event,
    Emitter<DataStorageState> emit,
  ) async {
    _lastReceiverCode = event.receiverIp;
    emit(DataTransferring(event.receiverIp));

    try {
      final result = await _transferDataUseCase(event.receiverIp);
      emit(DataTransferSuccess(result));
    } catch (e) {
      emit(
        DataTransferFailureState(
          message: e.toString(),
          lastReceiverCode: event.receiverIp,
        ),
      );
    }
  }

  Future<void> _onRetryDataTransfer(
    RetryDataTransferEvent event,
    Emitter<DataStorageState> emit,
  ) async {
    final code = _lastReceiverCode;
    if (code == null || code.isEmpty) {
      emit(const DataStorageInitial());
      return;
    }
    add(StartDataTransferEvent(code));
  }

  void _onCancelDataTransfer(
    CancelDataTransferEvent event,
    Emitter<DataStorageState> emit,
  ) {
    // Return to initial state (Do Nothing)
    emit(const DataStorageInitial());
  }

  void _onRequestDeleteConfirmation(
    RequestDeleteDataConfirmationEvent event,
    Emitter<DataStorageState> emit,
  ) {
    // DAT-04: Double confirmation step 1
    emit(const DeleteDataFirstConfirmationPrompt());
  }

  void _onConfirmDeleteFirstStep(
    ConfirmDeleteDataFirstStepEvent event,
    Emitter<DataStorageState> emit,
  ) {
    // DAT-05: Double confirmation step 2 (Username verification)
    emit(const DeleteDataUsernameVerificationPrompt());
  }

  Future<void> _onVerifyAndExecuteDeleteData(
    VerifyAndExecuteDeleteDataEvent event,
    Emitter<DataStorageState> emit,
  ) async {
    emit(const DeletingDataInProgress());
    try {
      await _deleteAppDataUseCase(event.verificationUsername);
      emit(const DeleteDataSuccess());
    } catch (e) {
      emit(DeleteDataFailureState(e.toString()));
    }
  }

  void _onCancelDeleteData(
    CancelDeleteDataEvent event,
    Emitter<DataStorageState> emit,
  ) {
    // DAT-07: Cancel at any step -> Do Nothing
    emit(const DataStorageInitial());
  }

  void _onResetState(
    ResetDataStorageStateEvent event,
    Emitter<DataStorageState> emit,
  ) {
    emit(const DataStorageInitial());
  }
}
