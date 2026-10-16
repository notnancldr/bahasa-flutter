import 'package:bahasa/features/decks/deck_details/domain/entities/deck_card_item.dart';
import 'package:bahasa/features/decks/study/domain/entities/study_session_result.dart';
import 'package:bahasa/features/decks/study/domain/repositories/study_session_repository.dart';
import 'package:bahasa/features/decks/study/domain/usecases/study_session_usecases.dart';
import 'package:bahasa/features/decks/study/presentation/bloc/flashcard_bloc.dart';
import 'package:bahasa/features/decks/study/presentation/bloc/flashcard_event.dart';
import 'package:bahasa/features/decks/study/presentation/bloc/flashcard_state.dart';
import 'package:bahasa/features/decks/study/presentation/bloc/quiz_bloc.dart';
import 'package:bahasa/features/decks/study/presentation/bloc/quiz_event.dart';
import 'package:bahasa/features/decks/study/presentation/bloc/quiz_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeStudySessionRepository implements StudySessionRepository {
  final List<DeckCardItem> cards = const [
    DeckCardItem(
      idCard: 'c1',
      defaultLanguage: 'Halo',
      translation: 'Konnichiwa',
      phoneticLang: '/kon/',
      additionalContext: 'Sapaan siang',
      reps: 0,
      correctAnswer: 0,
      finalScore: 0,
    ),
    DeckCardItem(
      idCard: 'c2',
      defaultLanguage: 'Selamat tinggal',
      translation: 'Sayounara',
      phoneticLang: '/sa/',
      additionalContext: 'Salam perpisahan',
      reps: 0,
      correctAnswer: 0,
      finalScore: 0,
    ),
  ];

  @override
  Future<List<DeckCardItem>> getAllDeckCards(String deckId) async => cards;

  @override
  Future<List<DeckCardItem>> getSessionCards(
    String deckId, {
    int limit = 10,
  }) async => cards.take(limit).toList();

  @override
  Future<String> startSession({
    required String deckId,
    required String gameType,
    required int totalQuestions,
  }) async => 'ses_test_1';

  @override
  Future<void> recordAnswer({
    required String deckId,
    required String sessionId,
    required String cardId,
    required String questionType,
    required bool isCorrect,
    required int timeSpentMs,
  }) async {}

  @override
  Future<StudySessionResult> completeSession({
    required String deckId,
    required String sessionId,
    required String gameType,
    required int startedAtMs,
    required List<bool> outcomes,
  }) async {
    final correct = outcomes.where((v) => v).length;
    return StudySessionResult(
      sessionId: sessionId,
      deckId: deckId,
      gameType: gameType,
      totalQuestions: outcomes.length,
      correctCount: correct,
      wrongCount: outcomes.length - correct,
      durationMs: 12000,
      outcomes: outcomes,
    );
  }
}

void main() {
  group('FlashcardBloc', () {
    test('flips card, records answers, and completes session', () async {
      final repo = _FakeStudySessionRepository();
      final bloc = FlashcardBloc(
        startSessionUseCase: StartStudySessionUseCase(repo),
        recordAnswerUseCase: RecordStudyAnswerUseCase(repo),
        completeSessionUseCase: CompleteStudySessionUseCase(repo),
      );

      bloc.add(const StartFlashcardSessionEvent('d1'));
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state, isA<FlashcardInProgress>());
      var inProgress = bloc.state as FlashcardInProgress;
      expect(inProgress.currentIndex, equals(0));
      expect(inProgress.isFlipped, isFalse);

      bloc.add(const FlipFlashcardEvent());
      await Future<void>.delayed(Duration.zero);
      inProgress = bloc.state as FlashcardInProgress;
      expect(inProgress.isFlipped, isTrue);

      bloc.add(const AnswerFlashcardEvent(isMemorized: true));
      await Future<void>.delayed(Duration.zero);
      inProgress = bloc.state as FlashcardInProgress;
      expect(inProgress.currentIndex, equals(1));
      expect(inProgress.isFlipped, isFalse);

      bloc.add(const AnswerFlashcardEvent(isMemorized: false));
      await Future<void>.delayed(Duration.zero);
      expect(bloc.state, isA<FlashcardCompleted>());
      final completed = bloc.state as FlashcardCompleted;
      expect(completed.result.correctCount, equals(1));
      expect(completed.result.wrongCount, equals(1));

      await bloc.close();
    });
  });

  group('QuizBloc', () {
    test('evaluates multiple choice and jumble words, shows feedback, and completes session', () async {
      final repo = _FakeStudySessionRepository();
      final bloc = QuizBloc(
        startSessionUseCase: StartStudySessionUseCase(repo),
        recordAnswerUseCase: RecordStudyAnswerUseCase(repo),
        completeSessionUseCase: CompleteStudySessionUseCase(repo),
      );

      bloc.add(const StartQuizSessionEvent('d1'));
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state, isA<QuizInProgress>());
      var inProgress = bloc.state as QuizInProgress;
      expect(inProgress.currentIndex, equals(0));

      // Question 0: Multiple Choice -> select the correct option
      final q0 = inProgress.currentQuestion;
      bloc.add(SelectQuizOptionEvent(q0.correctAnswer));
      await Future<void>.delayed(Duration.zero);

      bloc.add(const CheckQuizAnswerEvent());
      await Future<void>.delayed(Duration.zero);
      inProgress = bloc.state as QuizInProgress;
      expect(inProgress.feedbackStatus, equals(QuizFeedbackStatus.correct));

      bloc.add(const NextQuizQuestionEvent());
      await Future<void>.delayed(Duration.zero);
      inProgress = bloc.state as QuizInProgress;
      expect(inProgress.currentIndex, equals(1));

      // Question 1: Jumble Words -> pick first word index (incomplete/wrong)
      bloc.add(const ToggleQuizJumbleWordEvent(0));
      await Future<void>.delayed(Duration.zero);

      bloc.add(const CheckQuizAnswerEvent());
      await Future<void>.delayed(Duration.zero);
      inProgress = bloc.state as QuizInProgress;
      expect(inProgress.feedbackStatus, equals(QuizFeedbackStatus.wrong));

      bloc.add(const NextQuizQuestionEvent());
      await Future<void>.delayed(Duration.zero);
      expect(bloc.state, isA<QuizCompleted>());
      final completed = bloc.state as QuizCompleted;
      expect(completed.result.correctCount, equals(1));
      expect(completed.result.totalQuestions, equals(2));

      await bloc.close();
    });
  });
}
