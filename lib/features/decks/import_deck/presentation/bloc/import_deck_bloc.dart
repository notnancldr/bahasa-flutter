import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/import_deck_repository.dart';
import '../../domain/usecases/import_euy_deck_usecase.dart';
import '../../domain/usecases/validate_euy_file_usecase.dart';
import 'import_deck_event.dart';
import 'import_deck_state.dart';

/// BLoC orchestrating the deck import workflow.
class ImportDeckBloc extends Bloc<ImportDeckEvent, ImportDeckState> {
  final ImportDeckRepository repository;
  final ValidateEuyFileUseCase validateUseCase;
  final ImportEuyDeckUseCase importUseCase;

  ImportDeckBloc({
    required this.repository,
    required this.validateUseCase,
    required this.importUseCase,
  }) : super(const ImportPickerState()) {
    on<PickFileRequested>(_onPickFile);
    on<ClearSelectedFileRequested>(_onClearFile);
    on<StartImportProcessRequested>(_onStartImport);
    on<ConfirmImportCompleted>(_onConfirmCompleted);
  }

  Future<void> _onPickFile(
    PickFileRequested event,
    Emitter<ImportDeckState> emit,
  ) async {
    try {
      final path = event.customFilePath ?? await repository.pickEuyFile();
      if (path == null) return;

      final fileName = path.split('/').last;
      final validation = await validateUseCase(path);

      emit(
        ImportPickerState(
          filePath: path,
          fileName: fileName,
          fileSizeFormatted: validation.fileSizeFormatted,
        ),
      );
    } catch (e) {
      emit(ImportErrorState('File picker error: $e'));
    }
  }

  void _onClearFile(
    ClearSelectedFileRequested event,
    Emitter<ImportDeckState> emit,
  ) {
    emit(const ImportPickerState());
  }

  Future<void> _onStartImport(
    StartImportProcessRequested event,
    Emitter<ImportDeckState> emit,
  ) async {
    final current = state;
    if (current is! ImportPickerState || !current.hasFile) return;

    final path = current.filePath!;
    final name = current.fileName!;

    // 1. Verifying phase (~70%)
    emit(ImportVerifyingState(fileName: name, progress: 0.70));
    await Future.delayed(const Duration(milliseconds: 600));

    final validation = await validateUseCase(path);
    if (!validation.isValid || validation.deck == null) {
      emit(
        ImportErrorState(validation.errorMessage ?? 'File format not valid.'),
      );
      return;
    }

    final deck = validation.deck!;

    // 2. Importing phase (~85%)
    emit(ImportImportingState(fileName: name, progress: 0.85));
    await Future.delayed(const Duration(milliseconds: 600));

    try {
      await importUseCase(deck);
      emit(
        ImportSuccessReviewState(
          deck: deck,
          fileName: name,
          fileSizeFormatted: validation.fileSizeFormatted,
        ),
      );
    } catch (e) {
      emit(ImportErrorState('Database write failure: $e'));
    }
  }

  void _onConfirmCompleted(
    ConfirmImportCompleted event,
    Emitter<ImportDeckState> emit,
  ) {
    emit(ImportDoneState(event.deck));
  }
}
