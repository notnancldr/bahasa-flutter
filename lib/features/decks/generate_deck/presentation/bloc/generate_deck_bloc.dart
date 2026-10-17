import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/generate_deck_usecase.dart';
import 'generate_deck_event.dart';
import 'generate_deck_state.dart';

/// BLoC orchestrating the 4-step wizard, review summary, and generation lifecycle.
class GenerateDeckBloc extends Bloc<GenerateDeckEvent, GenerateDeckState> {
  final GenerateDeckUseCase generateDeckUseCase;

  GenerateDeckBloc({required this.generateDeckUseCase})
    : super(const GenerateDeckWizardState()) {
    on<DeckNameChanged>(_onNameChanged);
    on<DeckCountryChanged>(_onCountryChanged);
    on<DeckDifficultyChanged>(_onDifficultyChanged);
    on<DeckDescriptionChanged>(_onDescriptionChanged);
    on<NextStepRequested>(_onNextStep);
    on<PreviousStepRequested>(_onPreviousStep);
    on<JumpToStepRequested>(_onJumpToStep);
    on<SubmitGenerationRequested>(_onSubmit);
    on<ConfirmGenerationCompleted>(_onConfirmCompleted);
  }

  void _onNameChanged(DeckNameChanged event, Emitter<GenerateDeckState> emit) {
    if (state is GenerateDeckWizardState) {
      emit((state as GenerateDeckWizardState).copyWith(name: event.name));
    }
  }

  void _onCountryChanged(
    DeckCountryChanged event,
    Emitter<GenerateDeckState> emit,
  ) {
    if (state is GenerateDeckWizardState) {
      emit(
        (state as GenerateDeckWizardState).copyWith(
          language: event.languageCode,
        ),
      );
    }
  }

  void _onDifficultyChanged(
    DeckDifficultyChanged event,
    Emitter<GenerateDeckState> emit,
  ) {
    if (state is GenerateDeckWizardState) {
      emit(
        (state as GenerateDeckWizardState).copyWith(
          difficulty: event.difficulty,
        ),
      );
    }
  }

  void _onDescriptionChanged(
    DeckDescriptionChanged event,
    Emitter<GenerateDeckState> emit,
  ) {
    if (state is GenerateDeckWizardState) {
      emit(
        (state as GenerateDeckWizardState).copyWith(
          description: event.description,
        ),
      );
    }
  }

  void _onNextStep(NextStepRequested event, Emitter<GenerateDeckState> emit) {
    if (state is GenerateDeckWizardState) {
      final current = state as GenerateDeckWizardState;
      if (current.step < 4) {
        emit(current.copyWith(step: current.step + 1));
      }
    }
  }

  void _onPreviousStep(
    PreviousStepRequested event,
    Emitter<GenerateDeckState> emit,
  ) {
    if (state is GenerateDeckWizardState) {
      final current = state as GenerateDeckWizardState;
      if (current.step > 0) {
        emit(current.copyWith(step: current.step - 1));
      }
    }
  }

  void _onJumpToStep(
    JumpToStepRequested event,
    Emitter<GenerateDeckState> emit,
  ) {
    if (state is GenerateDeckWizardState) {
      emit((state as GenerateDeckWizardState).copyWith(step: event.stepIndex));
    }
  }

  Future<void> _onSubmit(
    SubmitGenerationRequested event,
    Emitter<GenerateDeckState> emit,
  ) async {
    if (state is! GenerateDeckWizardState) return;
    final wizard = state as GenerateDeckWizardState;

    final request = wizard.toRequest();
    emit(
      GenerateDeckInProgressState(
        deckName: wizard.name,
        language: wizard.language,
      ),
    );

    try {
      final result = await generateDeckUseCase(
        request,
        onProgress: (collected, total) {
          if (!emit.isDone) {
            emit(
              GenerateDeckInProgressState(
                deckName: wizard.name,
                language: wizard.language,
                collectedCards: collected,
                totalCards: total,
                isLocalAi: true,
              ),
            );
          }
        },
      );
      if (result.isSuccess) {
        emit(GenerateDeckSuccessState(result));
      } else {
        emit(
          GenerateDeckErrorState(
            result.errorMessage ?? 'Deck generation failed.',
          ),
        );
      }
    } catch (e) {
      emit(GenerateDeckErrorState(e.toString()));
    }
  }

  void _onConfirmCompleted(
    ConfirmGenerationCompleted event,
    Emitter<GenerateDeckState> emit,
  ) {
    // Return to initial or allow router to navigate
    emit(const GenerateDeckWizardState());
  }
}
