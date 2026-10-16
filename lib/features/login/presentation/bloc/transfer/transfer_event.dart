import 'package:flutter/material.dart';

@immutable
sealed class TransferEvent {}

class InitServer extends TransferEvent {}

class RestartServer extends TransferEvent {}

class CancelTransfer extends TransferEvent {}
