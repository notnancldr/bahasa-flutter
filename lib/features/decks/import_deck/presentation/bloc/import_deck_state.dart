import 'package:flutter/foundation.dart';

import '../../domain/entities/euy_deck.dart';

@immutable
sealed class ImportDeckState {
  const ImportDeckState();
}

/// State when user is selecting a file (either none selected or a file is chosen).
class ImportPickerState extends ImportDeckState {
  final String? filePath;
  final String? fileName;
  final String? fileSizeFormatted;

  const ImportPickerState({
    this.filePath,
    this.fileName,
    this.fileSizeFormatted,
  });

  bool get hasFile => filePath != null && filePath!.isNotEmpty;

  ImportPickerState copyWith({
    String? filePath,
    String? fileName,
    String? fileSizeFormatted,
  }) {
    return ImportPickerState(
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
      fileSizeFormatted: fileSizeFormatted ?? this.fileSizeFormatted,
    );
  }
}

/// State when the file is being verified (progress ~70%).
class ImportVerifyingState extends ImportDeckState {
  final String fileName;
  final double progress;

  const ImportVerifyingState({required this.fileName, this.progress = 0.70});
}

/// State when the database records are being written (progress ~85%).
class ImportImportingState extends ImportDeckState {
  final String fileName;
  final double progress;

  const ImportImportingState({required this.fileName, this.progress = 0.85});
}

/// State when import succeeded and deck summary is shown before finalizing.
class ImportSuccessReviewState extends ImportDeckState {
  final EuyDeck deck;
  final String fileName;
  final String fileSizeFormatted;

  const ImportSuccessReviewState({
    required this.deck,
    required this.fileName,
    required this.fileSizeFormatted,
  });
}

/// State when the file is invalid or corrupted.
class ImportErrorState extends ImportDeckState {
  final String errorMessage;

  const ImportErrorState(this.errorMessage);
}

/// Final state after user confirms completion.
class ImportDoneState extends ImportDeckState {
  final EuyDeck deck;

  const ImportDoneState(this.deck);
}
