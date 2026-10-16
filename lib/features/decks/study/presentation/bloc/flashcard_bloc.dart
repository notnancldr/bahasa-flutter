import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/study_session_usecases.dart';
import 'flashcard_event.dart';
import 'flashcard_state.dart';

/// BLoC orchestrating a 10-card Flashcard session, card flipping,
/// self-assessment recording, and session summary computation.
class FlashcardBloc extends Bloc<FlashcardEvent, FlashcardState> {
  /// Use case to start a study session.
  final StartStudySessionUseCase startSessionUseCase;

  /// Use case to record a single card assessment.
  final RecordStudyAnswerUseCase recordAnswerUseCase;

  /// Use case to complete the study session and aggregate statistics.
  final CompleteStudySessionUseCase completeSessionUseCase;

  /// Creates a [FlashcardBloc].
  FlashcardBloc({
    required this.startSessionUseCase,
    required this.recordAnswerUseCase,
    required this.completeSessionUseCase,
  }) : super(const FlashcardLoading()) {
    on<StartFlashcardSessionEvent>(_onStartSession);
    on<FlipFlashcardEvent>(_onFlipCard);
    on<AnswerFlashcardEvent>(_onAnswerCard);
  }

  Future<void> _onStartSession(
    StartFlashcardSessionEvent event,
    Emitter<FlashcardState> emit,
  ) async {
    emit(const FlashcardLoading());
    try {
      final initialized = await startSessionUseCase(
        deckId: event.deckId,
        gameType: 'flashcard',
      );

      if (initialized.sessionCards.isEmpty) {
        emit(const FlashcardError('No cards available in this deck.'));
        return;
      }

      emit(
        FlashcardInProgress(
          deckId: event.deckId,
          sessionId: initialized.sessionId,
          sessionStartedAtMs: initialized.startedAtMs,
          cardStartedAtMs: DateTime.now().millisecondsSinceEpoch,
          cards: initialized.sessionCards,
          currentIndex: 0,
          isFlipped: false,
          outcomes: const [],
        ),
      );
    } catch (e) {
      emit(FlashcardError(e.toString()));
    }
  }

  void _onFlipCard(FlipFlashcardEvent event, Emitter<FlashcardState> emit) {
    final current = state;
    if (current is! FlashcardInProgress) return;
    emit(
      FlashcardInProgress(
        deckId: current.deckId,
        sessionId: current.sessionId,
        sessionStartedAtMs: current.sessionStartedAtMs,
        cardStartedAtMs: current.cardStartedAtMs,
        cards: current.cards,
        currentIndex: current.currentIndex,
        isFlipped: !current.isFlipped,
        outcomes: current.outcomes,
      ),
    );
  }

  Future<void> _onAnswerCard(
    AnswerFlashcardEvent event,
    Emitter<FlashcardState> emit,
  ) async {
    final current = state;
    if (current is! FlashcardInProgress) return;

    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final timeSpentMs = (nowMs - current.cardStartedAtMs).clamp(100, 3600000);

    try {
      await recordAnswerUseCase(
        deckId: current.deckId,
        sessionId: current.sessionId,
        cardId: current.currentCard.idCard,
        questionType: 'flashcard',
        isCorrect: event.isMemorized,
        timeSpentMs: timeSpentMs,
      );

      final updatedOutcomes = <bool>[...current.outcomes, event.isMemorized];
      final nextIndex = current.currentIndex + 1;

      if (nextIndex < current.cards.length) {
        emit(
          FlashcardInProgress(
            deckId: current.deckId,
            sessionId: current.sessionId,
            sessionStartedAtMs: current.sessionStartedAtMs,
            cardStartedAtMs: DateTime.now().millisecondsSinceEpoch,
            cards: current.cards,
            currentIndex: nextIndex,
            isFlipped: false,
            outcomes: updatedOutcomes,
          ),
        );
      } else {
        final result = await completeSessionUseCase(
          deckId: current.deckId,
          sessionId: current.sessionId,
          gameType: 'flashcard',
          startedAtMs: current.sessionStartedAtMs,
          outcomes: updatedOutcomes,
        );
        emit(FlashcardCompleted(result));
      }
    } catch (e) {
      emit(FlashcardError(e.toString()));
    }
  }
}
