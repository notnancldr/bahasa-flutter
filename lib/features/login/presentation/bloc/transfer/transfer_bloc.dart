import 'dart:async';

import 'package:bahasa/core/errors/transfer_error.dart';
import 'package:bahasa/core/server/base.dart';
import 'package:bahasa/core/server/simulated_server.dart';
import 'package:bahasa/core/server/transfer_server.dart';
import 'package:bahasa/features/login/presentation/bloc/transfer/transfer_event.dart';
import 'package:bahasa/features/login/presentation/bloc/transfer/transfer_state.dart';

import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';

class TransferBloc extends Bloc<TransferEvent, TransferState> {
  final TransferServerBase _transferServer;
  StreamSubscription<TransferServerEvent>? _subscription;
  int repeat = 0;
  String? tempPath;

  TransferBloc({TransferServer? transferServer})
      // TODO: Remove `SimulatedTransferServer` call
      : _transferServer = transferServer ?? SimulatedTransferServer(),
      // : _transferServer = transferServer ?? TransferServer(),
        super(StartHostState()) {
    on<InitServer>(_startServer);
    on<CancelTransfer>(_cancelTransfer);
    on<RestartServer>((event, emit) => _startServer(event, emit));
  }

  Future<void> _startServer(TransferEvent event, Emitter<TransferState> emit) async {
    emit(StartHostState());

    // TODO: Remove state test
    // emit(CheckValidState(fileName: "person.myprofile", progress: 10, target: 8500));
    // emit(ReceiveState(fileName: "person.myprofile", progress: 5000, fileSize: 8500, ipHost: "192.168.1.10", ipOrigin: "192.168.1.11"));
    // return;

    await _subscription?.cancel();

    final done = emit.onEach<TransferServerEvent>(
      _transferServer.events,
      onData: (e) => _handleServerEvent(e, emit),
      onError: (error, _) {
        if (error is TransferError) {
          emit(TransferErrorState(error: error));
        }
      },
    );

    (() async {
      await Future.delayed(const Duration(seconds: 5));
      if (_transferServer is SimulatedTransferServer) {
        await _transferServer.simulateIncoming();
      }
    })(); // TODO: Remove simulated test

    try {
      await _transferServer.start();
    } catch (_) {
      // already emitted as TransferServerError above
    }

    await done;
  }

  Future<void> _cancelTransfer(CancelTransfer event, Emitter<TransferState> emit) async {
    emit(CancelHostState());
    await _transferServer.cancel();
  }

  Future<void> _handleServerEvent(TransferServerEvent event, Emitter<TransferState> emit) async {
    switch (event) {
      case TransferServerListening(:final ipHost):
        emit(ListeningState(ipHost: ipHost, repeat: repeat++));

      case TransferServerReceiving(:final ipOrigin, :final fileName, :final fileSize, :final progress):
        final current = state;
        developer.log("[ReceiveState] progress: $progress/$fileSize, origin: $ipOrigin, fileName: `$fileName`", name: "transfer.receive.progress");
        if (current is ListeningState) {
          emit(ReceiveState(
            ipOrigin: ipOrigin,
            ipHost: current.ipHost,
            fileName: fileName,
            fileSize: fileSize,
            progress: progress,
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
        developer.log("[TransferServerComplete]", name: "transfer.receive.progress");
        if (current is ReceiveState) {
          emit(current);
          _validateFile(emit, current);
        }

      case TransferServerError(:final error):
        developer.log("[TransferServerError] error: $error", name: "transfer.receive.progress");
        emit(TransferErrorState(error: error));

      case TransferServerCancelled():
        tempPath = null;
        developer.log("[TransferServerCancelled]", name: "transfer.receive.progress");
        emit(TransferErrorState(error: TransferAborted()));
    }
  }

  Future<void> _validateFile(Emitter<TransferState> emit, ReceiveState prev) async {
    final currentTempPath = tempPath;
    if (currentTempPath == null) return;

    emit(CheckValidState(
      fileName: prev.fileName,
      progress: 0,
      target: 1,
    ));

    await Future.delayed(const Duration(milliseconds: 5000));

    emit(TransferCompleteState(username: "dummy", defultLanguage: "id"));
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    if (state is ReceiveState) {
      await _transferServer.cancel();
    }
    await _transferServer.dispose();
    return super.close();
  }
}