import 'package:flutter/material.dart';

@immutable
sealed class TransferState {}

class StartHostState extends TransferState {}

class CancelHostState extends TransferState {}

class ListeningState extends TransferState {
  final String ipHost;
  final int repeat;

  ListeningState({
    required this.ipHost,
    required this.repeat,
  });
}

class ReceiveState extends TransferState {
  final String ipHost;
  final String? ipOrigin;
  final String fileName;
  final int? fileSize;
  final int progress;

  ReceiveState({
    required this.ipHost,
    required this.ipOrigin,
    required this.fileName,
    required this.fileSize,
    required this.progress,
  });

  ReceiveState copyWith({
    String? ipHost,
    String? ipOrigin,
    String? fileName,
    int? fileSize,
    int? progress,
    bool? isComplete,
  }) {
    return ReceiveState(
      ipHost: ipHost ?? this.ipHost,
      ipOrigin: ipOrigin ?? this.ipOrigin,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      progress: progress ?? this.progress,
    );
  }
}

class CheckValidState extends TransferState {
  final String fileName;
  final int progress;
  final int target;

  CheckValidState({
    required this.fileName,
    required this.progress,
    required this.target,
  });

  CheckValidState copyWith({
    String? fileName,
    int? progress,
    int? target,
    bool? isComplete,
    bool? isValid,
  }) {
    return CheckValidState(
      fileName: fileName ?? this.fileName,
      progress: progress ?? this.progress,
      target: target ?? this.target,
    );
  }
}

class TransferCompleteState extends TransferState {
  final String username;
  final String defultLanguage;

  TransferCompleteState({
    required this.username,
    required this.defultLanguage,
  });
}

class TransferErrorState extends TransferState {
  final Exception error;

  TransferErrorState({
    required this.error,
  });
}