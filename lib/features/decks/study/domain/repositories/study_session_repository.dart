import 'package:bahasa/features/decks/deck_details/domain/entities/deck_card_item.dart';

import '../entities/study_session_result.dart';

/// Repository contract for managing Flashcard and Quiz study sessions
/// and persisting logs and daily statistics to SQLite.
abstract class StudySessionRepository {
  /// Returns up to [limit] shuffled cards from [deckId] for a new study session.
  Future<List<DeckCardItem>> getSessionCards(String deckId, {int limit = 10});

  /// Returns all cards in [deckId] (used for generating quiz distractors).
  Future<List<DeckCardItem>> getAllDeckCards(String deckId);

  /// Creates a new row in the deck's `sessions` table and returns its `idSession`.
  Future<String> startSession({
    required String deckId,
    required String gameType,
    required int totalQuestions,
  });

  /// Records a single question answer in `logs` and updates the card's mastery in `cards`.
  Future<void> recordAnswer({
    required String deckId,
    required String sessionId,
    required String cardId,
    required String questionType,
    required bool isCorrect,
    required int timeSpentMs,
  });

  /// Finalizes the session in `sessions`, updates `daily_deck_stats`,
  /// and updates `decks` and `global_daily_activity` in `basa.sqlite`.
  Future<StudySessionResult> completeSession({
    required String deckId,
    required String sessionId,
    required String gameType,
    required int startedAtMs,
    required List<bool> outcomes,
  });
}
