import 'package:flutter/material.dart';

@immutable
sealed class TransferEvent {}

class InitServer extends TransferEvent {}

class RestartServer extends TransferEvent {}

class ReceiveData extends TransferEvent {
  final String ipOrigin;
  final String fileName;
  final int fileSize;

  ReceiveData({
    required this.ipOrigin,
    required this.fileName,
    required this.fileSize,
  });
}

class CancelTransfer extends TransferEvent {}