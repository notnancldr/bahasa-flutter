import 'package:flutter/material.dart';

@immutable
sealed class ImportEvent {}

class InitServer extends ImportEvent {}

class RestartServer extends ImportEvent {}

class ReceiveData extends ImportEvent {
  final String ipOrigin;
  final String fileName;
  final int fileSize;

  ReceiveData({
    required this.ipOrigin,
    required this.fileName,
    required this.fileSize,
  });
}

class CancelImport extends ImportEvent {}