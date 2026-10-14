import 'package:bahasa/features/decks/import_deck/domain/entities/euy_card.dart';
import 'package:bahasa/features/decks/import_deck/domain/entities/euy_deck.dart';
import 'package:bahasa/features/decks/import_deck/domain/entities/euy_file_property.dart';
import 'package:bahasa/features/decks/import_deck/domain/entities/euy_validation_result.dart';
import 'package:bahasa/features/decks/import_deck/domain/repositories/import_deck_repository.dart';
import 'package:bahasa/features/decks/import_deck/domain/usecases/get_euy_file_property_usecase.dart';
import 'package:bahasa/features/decks/import_deck/domain/usecases/import_euy_deck_usecase.dart';
import 'package:bahasa/features/decks/import_deck/domain/usecases/validate_euy_file_usecase.dart';
import 'package:bahasa/features/decks/import_deck/presentation/bloc/import_deck_bloc.dart';
import 'package:bahasa/features/decks/import_deck/presentation/bloc/import_deck_event.dart';
import 'package:bahasa/features/decks/import_deck/presentation/bloc/import_deck_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _MockImportDeckRepository implements ImportDeckRepository {
  String? mockPickedPath;
  EuyFileProperty? mockFileProperty;
  EuyValidationResult? mockValidationResult;
  bool validateFileCalled = false;
  bool importDeckCalled = false;
  EuyDeck? importedDeck;

  @override
  Future<String?> pickEuyFile() async => mockPickedPath;

  @override
  Future<EuyFileProperty> getFileProperty(String filePath) async {
    return mockFileProperty ??
        EuyFileProperty(
          path: filePath,
          name: filePath.split('/').last,
          sizeFormatted: '3.2 KB',
        );
  }

  @override
  Future<EuyValidationResult> validateFile(String filePath) async {
    validateFileCalled = true;
    return mockValidationResult ??
        EuyValidationResult.invalid(errorMessage: 'Invalid format');
  }

  @override
  Future<void> importDeck(EuyDeck deck) async {
    importDeckCalled = true;
    importedDeck = deck;
  }
}

void main() {
  late _MockImportDeckRepository repository;
  late ImportDeckBloc bloc;

  setUp(() {
    repository = _MockImportDeckRepository();
    bloc = ImportDeckBloc(
      repository: repository,
      getFilePropertyUseCase: GetEuyFilePropertyUseCase(repository),
      validateUseCase: ValidateEuyFileUseCase(repository),
      importUseCase: ImportEuyDeckUseCase(repository),
      stepDelay: Duration.zero,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state is ImportPickerState with no file', () {
    expect(bloc.state, isA<ImportPickerState>());
    expect((bloc.state as ImportPickerState).hasFile, isFalse);
  });

  test(
    'PickFileRequested queries only file property and DOES NOT validate file',
    () async {
      repository.mockPickedPath = '/storage/test_deck.euy';
      repository.mockFileProperty = const EuyFileProperty(
        path: '/storage/test_deck.euy',
        name: 'test_deck.euy',
        sizeFormatted: '4.5 KB',
      );

      bloc.add(const PickFileRequested());
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state, isA<ImportPickerState>());
      final pickerState = bloc.state as ImportPickerState;
      expect(pickerState.filePath, equals('/storage/test_deck.euy'));
      expect(pickerState.fileName, equals('test_deck.euy'));
      expect(pickerState.fileSizeFormatted, equals('4.5 KB'));

      // Verification: validateFile must NOT be called on file pick
      expect(repository.validateFileCalled, isFalse);
    },
  );

  test('StartImportProcessRequested runs validateFile and emits ImportErrorState on invalid file', () async {
    repository.mockPickedPath = '/storage/corrupt.euy';
    repository.mockFileProperty = const EuyFileProperty(
      path: '/storage/corrupt.euy',
      name: 'corrupt.euy',
      sizeFormatted: '1.0 KB',
    );
    repository.mockValidationResult = EuyValidationResult.invalid(
      errorMessage: 'Corrupted JSON syntax',
    );

    // 1. Pick the file
    bloc.add(const PickFileRequested());
    await Future<void>.delayed(Duration.zero);

    // 2. Start import
    bloc.add(const StartImportProcessRequested());
    await Future<void>.delayed(Duration.zero);

    // Verification: validateFile was called during verification
    expect(repository.validateFileCalled, isTrue);
    expect(repository.importDeckCalled, isFalse);
    expect(bloc.state, isA<ImportErrorState>());
    expect(
      (bloc.state as ImportErrorState).errorMessage,
      equals('Corrupted JSON syntax'),
    );
  });

  test('StartImportProcessRequested transitions through verifying, importing, to review on valid file', () async {
    const validDeck = EuyDeck(
      id: 'deck-123',
      name: 'Spanish 101',
      language: 'es',
      difficulty: 'beginner',
      rolePlay: 'Role',
      explanationRolePlay: 'Explanation',
      listCards: [
        EuyCard(
          idCard: 'c-1',
          defaultLanguage: 'Halo',
          translation: 'Hola',
          phoneticLang: 'o-la',
          additionalContext: 'Context',
          reps: 0,
          correctAnswer: 0,
          finalScore: 0,
        ),
      ],
    );

    repository.mockPickedPath = '/storage/valid.euy';
    repository.mockFileProperty = const EuyFileProperty(
      path: '/storage/valid.euy',
      name: 'valid.euy',
      sizeFormatted: '2.5 KB',
    );
    repository.mockValidationResult = EuyValidationResult.valid(
      deck: validDeck,
      fileSizeFormatted: '2.5 KB',
    );

    // 1. Pick file
    bloc.add(const PickFileRequested());
    await Future<void>.delayed(Duration.zero);

    // 2. Start import
    bloc.add(const StartImportProcessRequested());
    await Future<void>.delayed(Duration.zero);

    expect(repository.validateFileCalled, isTrue);
    expect(repository.importDeckCalled, isTrue);
    expect(repository.importedDeck?.id, equals('deck-123'));
    expect(bloc.state, isA<ImportSuccessReviewState>());
    final review = bloc.state as ImportSuccessReviewState;
    expect(review.deck.id, equals('deck-123'));
    expect(review.fileSizeFormatted, equals('2.5 KB'));
  });

  test(
    'ClearSelectedFileRequested resets state to empty ImportPickerState',
    () async {
      repository.mockPickedPath = '/path/file.euy';
      bloc.add(const PickFileRequested());
      await Future<void>.delayed(Duration.zero);
      expect((bloc.state as ImportPickerState).hasFile, isTrue);

      bloc.add(const ClearSelectedFileRequested());
      await Future<void>.delayed(Duration.zero);
      expect((bloc.state as ImportPickerState).hasFile, isFalse);
    },
  );

  test('ConfirmImportCompleted emits ImportDoneState', () async {
    const deck = EuyDeck(
      id: 'd1',
      name: 'Test',
      language: 'en',
      difficulty: 'easy',
      rolePlay: 'rp',
      explanationRolePlay: 'exp',
      listCards: [],
    );

    bloc.add(const ConfirmImportCompleted(deck));
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state, isA<ImportDoneState>());
    expect((bloc.state as ImportDoneState).deck.id, equals('d1'));
  });
}
