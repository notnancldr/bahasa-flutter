import 'package:bahasa/features/decks/deck_details/domain/entities/deck_card_item.dart';

import '../entities/study_session_result.dart';
import '../repositories/study_session_repository.dart';

/// Bundle of cards and initialized session metadata returned when starting a session.
class InitializedStudySession {
  /// Generated session ID in SQLite.
  final String sessionId;

  /// Selected and shuffled session cards (up to 10).
  final List<DeckCardItem> sessionCards;

  /// All cards in the deck (for building quiz distractors).
  final List<DeckCardItem> allDeckCards;

  /// Epoch timestamp (ms) when the session started.
  final int startedAtMs;

  /// Creates an [InitializedStudySession].
  const InitializedStudySession({
    required this.sessionId,
    required this.sessionCards,
    required this.allDeckCards,
    required this.startedAtMs,
  });
}

/// Use case that selects up to 10 shuffled cards and initializes a session record in SQLite.
class StartStudySessionUseCase {
  final StudySessionRepository _repository;

  /// Creates a [StartStudySessionUseCase].
  const StartStudySessionUseCase(this._repository);

  /// Starts a `'flashcard'` or `'quiz'` session for [deckId].
  Future<InitializedStudySession> call({
    required String deckId,
    required String gameType,
    int limit = 10,
  }) async {
    final allCards = await _repository.getAllDeckCards(deckId);
    final sessionCards = await _repository.getSessionCards(
      deckId,
      limit: limit,
    );
    final startedAtMs = DateTime.now().millisecondsSinceEpoch;
    final sessionId = await _repository.startSession(
      deckId: deckId,
      gameType: gameType,
      totalQuestions: sessionCards.length,
    );

    return InitializedStudySession(
      sessionId: sessionId,
      sessionCards: sessionCards,
      allDeckCards: allCards,
      startedAtMs: startedAtMs,
    );
  }
}

/// Use case that records an individual question outcome into `logs` and updates `cards`.
class RecordStudyAnswerUseCase {
  final StudySessionRepository _repository;

  /// Creates a [RecordStudyAnswerUseCase].
  const RecordStudyAnswerUseCase(this._repository);

  /// Persists the answer for [cardId] in [sessionId].
  Future<void> call({
    required String deckId,
    required String sessionId,
    required String cardId,
    required String questionType,
    required bool isCorrect,
    required int timeSpentMs,
  }) {
    return _repository.recordAnswer(
      deckId: deckId,
      sessionId: sessionId,
      cardId: cardId,
      questionType: questionType,
      isCorrect: isCorrect,
      timeSpentMs: timeSpentMs,
    );
  }
}

/// Use case that finalizes a study session and updates deck and global daily stats.
class CompleteStudySessionUseCase {
  final StudySessionRepository _repository;

  /// Creates a [CompleteStudySessionUseCase].
  const CompleteStudySessionUseCase(this._repository);

  /// Finalizes [sessionId] and returns the computed [StudySessionResult].
  Future<StudySessionResult> call({
    required String deckId,
    required String sessionId,
    required String gameType,
    required int startedAtMs,
    required List<bool> outcomes,
  }) {
    return _repository.completeSession(
      deckId: deckId,
      sessionId: sessionId,
      gameType: gameType,
      startedAtMs: startedAtMs,
      outcomes: outcomes,
    );
  }
}
