import 'dart:async';

import 'package:bahasa/core/errors/import_error.dart';
import 'package:bahasa/features/login/presentation/bloc/import/import_event.dart';
import 'package:bahasa/features/login/presentation/bloc/import/import_server.dart';
import 'package:bahasa/features/login/presentation/bloc/import/import_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ImportBloc extends Bloc<ImportEvent, ImportState> {
  final ImportServer _importServer;
  StreamSubscription<ImportServerEvent>? _subscription;
  int repeat = 0;
  String? tempPath;

  ImportBloc({ImportServer? importServer})
      : _importServer = importServer ?? ImportServer(),
        super(StartHostState()) {
    on<InitServer>(_startServer);
    on<CancelImport>(_cancelImport);
    on<RestartServer>((event, emit) => _startServer(event, emit));
  }

  Future<void> _startServer(ImportEvent event, Emitter<ImportState> emit) async {
    emit(StartHostState());

    await _subscription?.cancel();
    _subscription = _importServer.events.listen((e) => _handleServerEvent(e, emit));

    try {
      await _importServer.start();
    } catch (_) {
      // already emitted as ImportServerError above
    }
  }

  Future<void> _cancelImport(CancelImport event, Emitter<ImportState> emit) async {
    emit(CancelHostState());
    await _importServer.cancel();
  }

  void _handleServerEvent(ImportServerEvent event, Emitter<ImportState> emit) {
    switch (event) {
      case ImportServerListening(:final ipHost):
        emit(ListeningState(ipHost: ipHost, repeat: repeat++));

      case ImportServerReceiving(:final ipOrigin, :final fileName, :final fileSize, :final progress):
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

      case ImportServerComplete(:final filePath):
        tempPath = filePath;
        final current = state;
        if (current is ReceiveState) emit(current.copyWith(isComplete: true));

      case ImportServerError(:final error):
        emit(ImportErrorState(error: error));

      case ImportServerCancelled():
        tempPath = null;
        emit(ImportErrorState(error: ImportAborted()));
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    await _importServer.dispose();
    return super.close();
  }
}