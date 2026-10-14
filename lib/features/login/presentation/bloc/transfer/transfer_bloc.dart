import 'dart:async';
import 'dart:developer' as developer;

import 'package:bahasa/core/errors/transfer_error.dart';
import 'package:bahasa/core/server/transfer_server.dart';
import 'package:bahasa/features/login/domain/repositories/transfer_repository.dart';
import 'package:bahasa/features/login/domain/usecases/cancel_transfer_usecase.dart';
import 'package:bahasa/features/login/domain/usecases/start_transfer_server_usecase.dart';
import 'package:bahasa/features/login/domain/usecases/validate_transferred_file_usecase.dart';
import 'package:bahasa/features/login/presentation/bloc/transfer/transfer_event.dart';
import 'package:bahasa/features/login/presentation/bloc/transfer/transfer_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransferBloc extends Bloc<TransferEvent, TransferState> {
  final TransferRepository _repository;
  final StartTransferServerUseCase _startTransferServerUseCase;
  final CancelTransferUseCase _cancelTransferUseCase;
  final ValidateTransferredFileUseCase _validateTransferredFileUseCase;

  StreamSubscription<TransferServerEvent>? _subscription;
  int repeat = 0;
  String? tempPath;

  TransferBloc({
    required this._repository,
    required this._startTransferServerUseCase,
    required this._cancelTransferUseCase,
    required this._validateTransferredFileUseCase,
  }) : super(StartHostState()) {
    on<InitServer>(_startServer);
    on<CancelTransfer>(_cancelTransfer);
    on<RestartServer>((event, emit) => _startServer(event, emit));
  }

  Future<void> _startServer(
    TransferEvent event,
    Emitter<TransferState> emit,
  ) async {
    emit(StartHostState());

    await _subscription?.cancel();

    final done = emit.onEach<TransferServerEvent>(
      _repository.events,
      onData: (e) => _handleServerEvent(e, emit),
      onError: (error, _) {
        if (error is TransferError) {
          emit(
            TransferErrorState(
              error: error,
              message: error.toString(),
              isInvalidData: error is TransferNotValid,
            ),
          );
        }
      },
    );

    try {
      await _startTransferServerUseCase();
    } catch (e) {
      if (e is Exception) {
        emit(
          TransferErrorState(
            error: e,
            message: e.toString(),
            isInvalidData: e is TransferNotValid,
          ),
        );
      }
    }

    await done;
  }

  Future<void> _cancelTransfer(
    CancelTransfer event,
    Emitter<TransferState> emit,
  ) async {
    emit(CancelHostState());
    await _cancelTransferUseCase(tempPath);
    tempPath = null;
  }

  Future<void> _handleServerEvent(
    TransferServerEvent event,
    Emitter<TransferState> emit,
  ) async {
    switch (event) {
      case TransferServerListening(:final ipHost):
        emit(ListeningState(ipHost: ipHost, repeat: repeat++));

      case TransferServerReceiving(
        :final ipOrigin,
        :final fileName,
        :final fileSize,
        :final progress,
      ):
        final current = state;
        developer.log(
          '[ReceiveState] progress: $progress/$fileSize, origin: $ipOrigin, fileName: `$fileName`',
          name: 'transfer.receive.progress',
        );
        if (current is ListeningState) {
          emit(
            ReceiveState(
              ipOrigin: ipOrigin,
              ipHost: current.ipHost,
              fileName: fileName,
              fileSize: fileSize,
              progress: progress,
            ),
          );
        } else if (current is ReceiveState) {
          emit(
            current.copyWith(
              ipOrigin: ipOrigin,
              fileName: fileName,
              fileSize: fileSize,
              progress: progress,
            ),
          );
        }

      case TransferServerComplete(:final filePath):
        tempPath = filePath;
        final current = state;
        developer.log(
          '[TransferServerComplete] filePath: $filePath',
          name: 'transfer.receive.progress',
        );
        if (current is ReceiveState) {
          emit(current);
          await _validateFile(emit, current);
        }

      case TransferServerError(:final error):
        developer.log(
          '[TransferServerError] error: $error',
          name: 'transfer.receive.progress',
        );
        await _repository.cleanupTempFiles(tempPath);
        tempPath = null;
        emit(
          TransferErrorState(
            error: error,
            message: error.toString(),
            isInvalidData: error is TransferNotValid,
          ),
        );

      case TransferServerCancelled():
        await _repository.cleanupTempFiles(tempPath);
        tempPath = null;
        developer.log(
          '[TransferServerCancelled]',
          name: 'transfer.receive.progress',
        );
        emit(
          TransferErrorState(
            error: TransferAborted(),
            message: 'Transfer was cancelled.',
            isInvalidData: false,
          ),
        );
    }
  }

  Future<void> _validateFile(
    Emitter<TransferState> emit,
    ReceiveState prev,
  ) async {
    final currentTempPath = tempPath;

    emit(CheckValidState(fileName: prev.fileName, progress: 0, target: 1));

    final result = await _validateTransferredFileUseCase(currentTempPath);

    if (result.isValid) {
      emit(
        TransferCompleteState(
          username: result.username ?? 'user',
          defultLanguage: result.defaultLanguage ?? 'id',
        ),
      );
    } else {
      await _repository.cleanupTempFiles(currentTempPath);
      tempPath = null;
      emit(
        TransferErrorState(
          error: TransferNotValid(),
          message: result.errorMessage,
          isInvalidData: true,
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    if (state is ReceiveState) {
      await _cancelTransferUseCase(tempPath);
    }
    await _repository.dispose();
    return super.close();
  }
}
