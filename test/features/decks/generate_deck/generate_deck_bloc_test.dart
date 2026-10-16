import 'package:bahasa/features/decks/generate_deck/domain/entities/deck_generation_request.dart';
import 'package:bahasa/features/decks/generate_deck/domain/entities/generated_deck_result.dart';
import 'package:bahasa/features/decks/generate_deck/domain/repositories/generate_deck_repository.dart';
import 'package:bahasa/features/decks/generate_deck/domain/usecases/generate_deck_usecase.dart';
import 'package:bahasa/features/decks/generate_deck/presentation/bloc/generate_deck_bloc.dart';
import 'package:bahasa/features/decks/generate_deck/presentation/bloc/generate_deck_event.dart';
import 'package:bahasa/features/decks/generate_deck/presentation/bloc/generate_deck_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeGenerateDeckRepository implements GenerateDeckRepository {
  final bool shouldFail;

  _FakeGenerateDeckRepository({this.shouldFail = false});

  @override
  Future<GeneratedDeckResult> generateDeck(
    DeckGenerationRequest request,
  ) async {
    if (shouldFail) {
      return GeneratedDeckResult.failure('Failed to generate deck');
    }
    return GeneratedDeckResult(
      deckId: 'test-gen-id',
      name: request.name,
      cardCount: 5,
      isSuccess: true,
    );
  }
}

void main() {
  group('GenerateDeckBloc', () {
    test('initial state has step 0 and defaults', () {
      final bloc = GenerateDeckBloc(
        generateDeckUseCase: GenerateDeckUseCase(_FakeGenerateDeckRepository()),
      );
      expect(bloc.state, isA<GenerateDeckWizardState>());
      final wizard = bloc.state as GenerateDeckWizardState;
      expect(wizard.step, equals(0));
      expect(wizard.language, equals(''));
      expect(wizard.difficulty, equals('intermediate'));
    });

    test('step progression, country validation, and jump back', () async {
      final bloc = GenerateDeckBloc(
        generateDeckUseCase: GenerateDeckUseCase(_FakeGenerateDeckRepository()),
      );

      bloc.add(const DeckNameChanged('Japanese Vocabulary'));
      await Future<void>.delayed(Duration.zero);
      expect(
        (bloc.state as GenerateDeckWizardState).name,
        equals('Japanese Vocabulary'),
      );

      bloc.add(const NextStepRequested());
      await Future<void>.delayed(Duration.zero);
      final step1State = bloc.state as GenerateDeckWizardState;
      expect(step1State.step, equals(1));
      expect(step1State.canProceedToNext, isFalse);

      bloc.add(const DeckCountryChanged('ja'));
      await Future<void>.delayed(Duration.zero);
      expect((bloc.state as GenerateDeckWizardState).canProceedToNext, isTrue);

      bloc.add(const JumpToStepRequested(0));
      await Future<void>.delayed(Duration.zero);
      expect((bloc.state as GenerateDeckWizardState).step, equals(0));
    });

    test('submit generation emits in progress then success', () async {
      final bloc = GenerateDeckBloc(
        generateDeckUseCase: GenerateDeckUseCase(_FakeGenerateDeckRepository()),
      );

      bloc.add(const DeckNameChanged('Spanish 101'));
      await Future<void>.delayed(Duration.zero);

      bloc.add(const SubmitGenerationRequested());
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state, isA<GenerateDeckSuccessState>());
      final success = bloc.state as GenerateDeckSuccessState;
      expect(success.result.name, equals('Spanish 101'));
      expect(success.result.cardCount, equals(5));
    });

    test('submit generation emits error state when repository fails', () async {
      final bloc = GenerateDeckBloc(
        generateDeckUseCase: GenerateDeckUseCase(
          _FakeGenerateDeckRepository(shouldFail: true),
        ),
      );

      bloc.add(const DeckNameChanged('Spanish 101'));
      await Future<void>.delayed(Duration.zero);

      bloc.add(const SubmitGenerationRequested());
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state, isA<GenerateDeckErrorState>());
      final errorState = bloc.state as GenerateDeckErrorState;
      expect(errorState.errorMessage, contains('Failed to generate deck'));
    });
  });
}
