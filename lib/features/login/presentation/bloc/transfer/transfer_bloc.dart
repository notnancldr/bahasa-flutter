import 'dart:async';

import 'package:bahasa/core/errors/transfer_error.dart';
import 'package:bahasa/core/server/transfer_server.dart';
import 'package:bahasa/features/login/presentation/bloc/transfer/transfer_event.dart';
import 'package:bahasa/features/login/presentation/bloc/transfer/transfer_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class TransferBloc extends Bloc<TransferEvent, TransferState> {
  final TransferServer _transferServer;
  StreamSubscription<TransferServerEvent>? _subscription;
  int repeat = 0;
  String? tempPath;

  TransferBloc({TransferServer? transferServer})
      : _transferServer = transferServer ?? TransferServer(),
        super(StartHostState()) {
    on<InitServer>(_startServer);
    on<CancelTransfer>(_cancelTransfer);
    on<RestartServer>((event, emit) => _startServer(event, emit));
  }

  Future<void> _startServer(TransferEvent event, Emitter<TransferState> emit) async {
    emit(StartHostState());

    await _subscription?.cancel();
    _subscription = _transferServer.events.listen((e) => _handleServerEvent(e, emit));

    try {
      await _transferServer.start();
    } catch (_) {
      // already emitted as TransferServerError above
    }
  }

  Future<void> _cancelTransfer(CancelTransfer event, Emitter<TransferState> emit) async {
    emit(CancelHostState());
    await _transferServer.cancel();
  }

  void _handleServerEvent(TransferServerEvent event, Emitter<TransferState> emit) {
    switch (event) {
      case TransferServerListening(:final ipHost):
        emit(ListeningState(ipHost: ipHost, repeat: repeat++));

      case TransferServerReceiving(:final ipOrigin, :final fileName, :final fileSize, :final progress):
        final current = state;
        if (current is ListeningState) {
          emit(ReceiveState(
            ipOrigin: ipOrigin,
            ipHost: current.ipHost,
            fileName: fileName,
            fileSize: fileSize,
            progress: progress,
            isComplete: false,
          ));
        } else if (current is ReceiveState) {
          emit(current.copyWith(
            ipOrigin: ipOrigin,
            fileName: fileName,
            fileSize: fileSize,
            progress: progress,
          ));
        }

      case TransferServerComplete(:final filePath):
        tempPath = filePath;
        final current = state;
        if (current is ReceiveState) emit(current.copyWith(isComplete: true));

      case TransferServerError(:final error):
        emit(TransferErrorState(error: error));

      case TransferServerCancelled():
        tempPath = null;
        emit(TransferErrorState(error: TransferAborted()));
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    await _transferServer.dispose();
    return super.close();
  }
}