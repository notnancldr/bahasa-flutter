import '../entities/deck_history_card_log.dart';
import '../repositories/deck_history_repository.dart';

/// Use case that fetches the card-by-card question logs for a study session.
class GetSessionCardLogsUseCase {
  final DeckHistoryRepository _repository;

  /// Creates a [GetSessionCardLogsUseCase].
  const GetSessionCardLogsUseCase(this._repository);

  /// Executes the card logs retrieval for [sessionId] in [deckId].
  Future<List<DeckHistoryCardLog>> call({
    required String deckId,
    required String sessionId,
  }) {
    return _repository.getSessionCardLogs(deckId: deckId, sessionId: sessionId);
  }
}
