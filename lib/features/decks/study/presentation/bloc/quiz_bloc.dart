import 'dart:math';

import 'package:bahasa/features/decks/deck_details/domain/entities/deck_card_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/quiz_question.dart';
import '../../domain/usecases/study_session_usecases.dart';
import 'quiz_event.dart';
import 'quiz_state.dart';

/// BLoC orchestrating a 10-question Quiz session with Multiple Choice (`translating`),
/// Context Guess (`context`), and Jumble Words (`writing`) questions, immediate SQLite answer logging,
/// feedback overlays, and completion summary computation.
class QuizBloc extends Bloc<QuizEvent, QuizState> {
  /// Use case to start a study session.
  final StartStudySessionUseCase startSessionUseCase;

  /// Use case to record a single question attempt.
  final RecordStudyAnswerUseCase recordAnswerUseCase;

  /// Use case to complete the study session and aggregate statistics.
  final CompleteStudySessionUseCase completeSessionUseCase;
  final Random _random;

  /// Creates a [QuizBloc].
  QuizBloc({
    required this.startSessionUseCase,
    required this.recordAnswerUseCase,
    required this.completeSessionUseCase,
    Random? random,
  }) : _random = random ?? Random(),
       super(const QuizLoading()) {
    on<StartQuizSessionEvent>(_onStartSession);
    on<SelectQuizOptionEvent>(_onSelectOption);
    on<ToggleQuizJumbleWordEvent>(_onToggleJumbleWord);
    on<CheckQuizAnswerEvent>(_onCheckAnswer);
    on<NextQuizQuestionEvent>(_onNextQuestion);
  }

  static const List<String> _fallbackDistractorPhrases = [
    'Halo Selamat Siang',
    'Terima kasih banyak',
    'Selamat tinggal',
    'Sampai jumpa besok',
  ];

  static const List<String> _fallbackDistractorWords = [
    'selamat',
    'tinggal',
    'datang',
    'pagi',
    'malam',
  ];

  static const List<String> _fallbackDistractorTranslations = [
    'Konnichiwa',
    'Arigatou',
    'Sayounara',
    'Sumimasen',
    'Ogenki desu ka',
    'Gomen nasai',
  ];

  Future<void> _onStartSession(
    StartQuizSessionEvent event,
    Emitter<QuizState> emit,
  ) async {
    emit(const QuizLoading());
    try {
      final initialized = await startSessionUseCase(
        deckId: event.deckId,
        gameType: 'quiz',
      );

      if (initialized.sessionCards.isEmpty) {
        emit(const QuizError('No cards available in this deck.'));
        return;
      }

      final questions = _buildQuizQuestions(
        initialized.sessionCards,
        initialized.allDeckCards,
      );

      emit(
        QuizInProgress(
          deckId: event.deckId,
          sessionId: initialized.sessionId,
          sessionStartedAtMs: initialized.startedAtMs,
          questionStartedAtMs: DateTime.now().millisecondsSinceEpoch,
          questions: questions,
          currentIndex: 0,
        ),
      );
    } catch (e) {
      emit(QuizError(e.toString()));
    }
  }

  void _onSelectOption(SelectQuizOptionEvent event, Emitter<QuizState> emit) {
    final current = state;
    if (current is! QuizInProgress) return;
    if (current.feedbackStatus != QuizFeedbackStatus.none) return;

    emit(
      QuizInProgress(
        deckId: current.deckId,
        sessionId: current.sessionId,
        sessionStartedAtMs: current.sessionStartedAtMs,
        questionStartedAtMs: current.questionStartedAtMs,
        questions: current.questions,
        currentIndex: current.currentIndex,
        selectedOption: event.option,
        selectedWordIndices: current.selectedWordIndices,
        feedbackStatus: current.feedbackStatus,
        outcomes: current.outcomes,
      ),
    );
  }

  void _onToggleJumbleWord(
    ToggleQuizJumbleWordEvent event,
    Emitter<QuizState> emit,
  ) {
    final current = state;
    if (current is! QuizInProgress) return;
    if (current.feedbackStatus != QuizFeedbackStatus.none) return;

    final updated = List<int>.from(current.selectedWordIndices);
    if (updated.contains(event.wordBankIndex)) {
      updated.remove(event.wordBankIndex);
    } else {
      updated.add(event.wordBankIndex);
    }

    emit(
      QuizInProgress(
        deckId: current.deckId,
        sessionId: current.sessionId,
        sessionStartedAtMs: current.sessionStartedAtMs,
        questionStartedAtMs: current.questionStartedAtMs,
        questions: current.questions,
        currentIndex: current.currentIndex,
        selectedOption: current.selectedOption,
        selectedWordIndices: updated,
        feedbackStatus: current.feedbackStatus,
        outcomes: current.outcomes,
      ),
    );
  }

  Future<void> _onCheckAnswer(
    CheckQuizAnswerEvent event,
    Emitter<QuizState> emit,
  ) async {
    final current = state;
    if (current is! QuizInProgress || !current.canCheckAnswer) return;

    final question = current.currentQuestion;
    final isCorrect = _evaluateAnswer(current, question);
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final timeSpentMs = (nowMs - current.questionStartedAtMs).clamp(
      100,
      3600000,
    );

    try {
      await recordAnswerUseCase(
        deckId: current.deckId,
        sessionId: current.sessionId,
        cardId: question.card.idCard,
        questionType: question.dbQuestionType,
        isCorrect: isCorrect,
        timeSpentMs: timeSpentMs,
      );

      emit(
        QuizInProgress(
          deckId: current.deckId,
          sessionId: current.sessionId,
          sessionStartedAtMs: current.sessionStartedAtMs,
          questionStartedAtMs: current.questionStartedAtMs,
          questions: current.questions,
          currentIndex: current.currentIndex,
          selectedOption: current.selectedOption,
          selectedWordIndices: current.selectedWordIndices,
          feedbackStatus: isCorrect
              ? QuizFeedbackStatus.correct
              : QuizFeedbackStatus.wrong,
          outcomes: <bool>[...current.outcomes, isCorrect],
        ),
      );
    } catch (e) {
      emit(QuizError(e.toString()));
    }
  }

  Future<void> _onNextQuestion(
    NextQuizQuestionEvent event,
    Emitter<QuizState> emit,
  ) async {
    final current = state;
    if (current is! QuizInProgress) return;

    final nextIndex = current.currentIndex + 1;
    if (nextIndex < current.questions.length) {
      emit(
        QuizInProgress(
          deckId: current.deckId,
          sessionId: current.sessionId,
          sessionStartedAtMs: current.sessionStartedAtMs,
          questionStartedAtMs: DateTime.now().millisecondsSinceEpoch,
          questions: current.questions,
          currentIndex: nextIndex,
          outcomes: current.outcomes,
        ),
      );
    } else {
      try {
        final result = await completeSessionUseCase(
          deckId: current.deckId,
          sessionId: current.sessionId,
          gameType: 'quiz',
          startedAtMs: current.sessionStartedAtMs,
          outcomes: current.outcomes,
        );
        emit(QuizCompleted(result));
      } catch (e) {
        emit(QuizError(e.toString()));
      }
    }
  }

  bool _evaluateAnswer(QuizInProgress current, QuizQuestion question) {
    if (question.type == QuizQuestionType.multipleChoice ||
        question.type == QuizQuestionType.contextGuess) {
      return _normalize(current.selectedOption ?? '') ==
          _normalize(question.correctAnswer);
    }

    final assembled = current.selectedWordIndices
        .map((i) => question.wordBank[i])
        .join(' ');
    return _normalize(assembled) == _normalize(question.targetWords.join(' '));
  }

  String _normalize(String input) {
    return input
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  List<QuizQuestion> _buildQuizQuestions(
    List<DeckCardItem> sessionCards,
    List<DeckCardItem> allCards,
  ) {
    final questions = <QuizQuestion>[];
    for (var i = 0; i < sessionCards.length; i++) {
      final card = sessionCards[i];
      final modeIndex = i % 3;
      var type = switch (modeIndex) {
        0 => QuizQuestionType.multipleChoice,
        1 => QuizQuestionType.contextGuess,
        _ => QuizQuestionType.jumbleWords,
      };

      if (type == QuizQuestionType.contextGuess &&
          card.additionalContext.trim().isEmpty) {
        type = QuizQuestionType.multipleChoice;
      }

      if (type == QuizQuestionType.multipleChoice) {
        final options = _buildMultipleChoiceOptions(card, allCards);
        questions.add(
          QuizQuestion(
            card: card,
            type: QuizQuestionType.multipleChoice,
            options: options,
            targetWords: const [],
            wordBank: const [],
            correctAnswer: card.defaultLanguage,
          ),
        );
      } else if (type == QuizQuestionType.contextGuess) {
        final options = _buildContextGuessOptions(card, allCards);
        questions.add(
          QuizQuestion(
            card: card,
            type: QuizQuestionType.contextGuess,
            options: options,
            targetWords: const [],
            wordBank: const [],
            correctAnswer: card.translation,
          ),
        );
      } else {
        final targetWords = _tokenizeWords(card.defaultLanguage);
        final wordBank = _buildWordBank(targetWords, allCards);
        questions.add(
          QuizQuestion(
            card: card,
            type: QuizQuestionType.jumbleWords,
            options: const [],
            targetWords: targetWords,
            wordBank: wordBank,
            correctAnswer: card.defaultLanguage,
          ),
        );
      }
    }
    return questions;
  }

  List<String> _buildMultipleChoiceOptions(
    DeckCardItem targetCard,
    List<DeckCardItem> allCards,
  ) {
    final targetNormalized = _normalize(targetCard.defaultLanguage);
    final candidatePool = <String>[];

    for (final c in allCards) {
      final val = c.defaultLanguage.trim();
      if (val.isNotEmpty &&
          _normalize(val) != targetNormalized &&
          !candidatePool.any(
            (existing) => _normalize(existing) == _normalize(val),
          )) {
        candidatePool.add(val);
      }
    }

    for (final fallback in _fallbackDistractorPhrases) {
      if (_normalize(fallback) != targetNormalized &&
          !candidatePool.any(
            (existing) => _normalize(existing) == _normalize(fallback),
          )) {
        candidatePool.add(fallback);
      }
    }

    candidatePool.shuffle(_random);
    final options = <String>[
      targetCard.defaultLanguage,
      ...candidatePool.take(3),
    ]..shuffle(_random);

    return options;
  }

  List<String> _buildContextGuessOptions(
    DeckCardItem targetCard,
    List<DeckCardItem> allCards,
  ) {
    final targetNormalized = _normalize(targetCard.translation);
    final candidatePool = <String>[];

    for (final c in allCards) {
      final val = c.translation.trim();
      if (val.isNotEmpty &&
          _normalize(val) != targetNormalized &&
          !candidatePool.any(
            (existing) => _normalize(existing) == _normalize(val),
          )) {
        candidatePool.add(val);
      }
    }

    for (final fallback in _fallbackDistractorTranslations) {
      if (_normalize(fallback) != targetNormalized &&
          !candidatePool.any(
            (existing) => _normalize(existing) == _normalize(fallback),
          )) {
        candidatePool.add(fallback);
      }
    }

    candidatePool.shuffle(_random);
    final options = <String>[
      targetCard.translation,
      ...candidatePool.take(3),
    ]..shuffle(_random);

    return options;
  }

  List<String> _tokenizeWords(String text) {
    final tokens = text
        .trim()
        .split(RegExp(r'\s+'))
        .map((w) => w.replaceAll(RegExp(r'^[/•\-]+|[/•\-]+$'), '').trim())
        .where((w) => w.isNotEmpty)
        .map((w) => w.toLowerCase())
        .toList();
    return tokens.isEmpty ? [text.trim().toLowerCase()] : tokens;
  }

  List<String> _buildWordBank(
    List<String> targetWords,
    List<DeckCardItem> allCards,
  ) {
    final distractorTokens = <String>[];
    for (final c in allCards) {
      for (final token in _tokenizeWords(c.defaultLanguage)) {
        if (!targetWords.contains(token) && !distractorTokens.contains(token)) {
          distractorTokens.add(token);
        }
      }
    }
    for (final fallback in _fallbackDistractorWords) {
      if (!targetWords.contains(fallback) &&
          !distractorTokens.contains(fallback)) {
        distractorTokens.add(fallback);
      }
    }

    distractorTokens.shuffle(_random);
    final neededDistractors = (5 - targetWords.length).clamp(2, 4);
    final bank = <String>[
      ...targetWords,
      ...distractorTokens.take(neededDistractors),
    ]..shuffle(_random);
    return bank;
  }
}
