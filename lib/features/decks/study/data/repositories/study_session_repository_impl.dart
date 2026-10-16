import 'package:bahasa/features/decks/deck_details/domain/entities/deck_card_item.dart';

import '../../domain/entities/study_session_result.dart';
import '../../domain/repositories/study_session_repository.dart';
import '../datasources/study_local_data_source.dart';

/// Implementation of [StudySessionRepository] backed by [StudyLocalDataSource].
class StudySessionRepositoryImpl implements StudySessionRepository {
  final StudyLocalDataSource _localDataSource;

  /// Creates a [StudySessionRepositoryImpl].
  const StudySessionRepositoryImpl({
    this._localDataSource = const StudyLocalDataSourceImpl(),
  });

  @override
  Future<List<DeckCardItem>> getAllDeckCards(String deckId) {
    return _localDataSource.getAllDeckCards(deckId);
  }

  @override
  Future<List<DeckCardItem>> getSessionCards(String deckId, {int limit = 10}) {
    return _localDataSource.getSessionCards(deckId, limit: limit);
  }

  @override
  Future<String> startSession({
    required String deckId,
    required String gameType,
    required int totalQuestions,
  }) {
    return _localDataSource.startSession(
      deckId: deckId,
      gameType: gameType,
      totalQuestions: totalQuestions,
    );
  }

  @override
  Future<void> recordAnswer({
    required String deckId,
    required String sessionId,
    required String cardId,
    required String questionType,
    required bool isCorrect,
    required int timeSpentMs,
  }) {
    return _localDataSource.recordAnswer(
      deckId: deckId,
      sessionId: sessionId,
      cardId: cardId,
      questionType: questionType,
      isCorrect: isCorrect,
      timeSpentMs: timeSpentMs,
    );
  }

  @override
  Future<StudySessionResult> completeSession({
    required String deckId,
    required String sessionId,
    required String gameType,
    required int startedAtMs,
    required List<bool> outcomes,
  }) {
    return _localDataSource.completeSession(
      deckId: deckId,
      sessionId: sessionId,
      gameType: gameType,
      startedAtMs: startedAtMs,
      outcomes: outcomes,
    );
  }
}
