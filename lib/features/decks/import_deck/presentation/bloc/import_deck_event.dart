import 'package:flutter/foundation.dart';

import '../../domain/entities/euy_deck.dart';

@immutable
sealed class ImportDeckEvent {
  const ImportDeckEvent();
}

/// Dispatched to pick a file from device storage or sample.
class PickFileRequested extends ImportDeckEvent {
  final String? customFilePath;
  const PickFileRequested({this.customFilePath});
}

/// Dispatched when a selected file should be cleared / replaced.
class ClearSelectedFileRequested extends ImportDeckEvent {
  const ClearSelectedFileRequested();
}

/// Dispatched when the user confirms the selected file and starts import.
class StartImportProcessRequested extends ImportDeckEvent {
  const StartImportProcessRequested();
}

/// Dispatched when the ready deck is confirmed to complete the flow.
class ConfirmImportCompleted extends ImportDeckEvent {
  final EuyDeck deck;
  const ConfirmImportCompleted(this.deck);
}
