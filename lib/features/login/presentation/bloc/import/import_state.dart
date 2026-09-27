import 'package:flutter/material.dart';

@immutable
sealed class ImportState {}

class StartHostState extends ImportState {}

class CancelHostState extends ImportState {}

class ListeningState extends ImportState {
  final String ipHost;
  final int repeat;

  ListeningState({
    required this.ipHost,
    required this.repeat,
  });
}

class ReceiveState extends ImportState {
  final String ipHost;
  final String? ipOrigin;
  final String fileName;
  final int? fileSize;
  final int progress;
  final bool isComplete;

  ReceiveState({
    required this.ipHost,
    required this.ipOrigin,
    required this.fileName,
    required this.fileSize,
    required this.progress,
    required this.isComplete,
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
      isComplete: isComplete ?? this.isComplete,
    );
  }
}

class CheckValidState extends ImportState {
  final String fileName;
  final int progress;
  final int target;
  final bool isComplete;
  final bool isValid;

  CheckValidState({
    required this.fileName,
    required this.progress,
    required this.target,
    required this.isComplete,
    required this.isValid,
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
      isComplete: isComplete ?? this.isComplete,
      isValid: isValid ?? this.isValid,
    );
  }
}

class ImportCompleteState extends ImportState {
  final String username;
  final String defultLanguage;

  ImportCompleteState({
    required this.username,
    required this.defultLanguage,
  });
}

class ImportErrorState extends ImportState {
  final Exception error;

  ImportErrorState({
    required this.error,
  });
}