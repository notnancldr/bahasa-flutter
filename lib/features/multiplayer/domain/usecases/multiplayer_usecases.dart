import 'package:bahasa/features/decks/domain/entities/deck_item.dart';

import '../repositories/multiplayer_repository.dart';

/// Starts host server and enters hosting mode.
class StartMultiplayerHostUseCase {
  final MultiplayerRepository _repository;
  const StartMultiplayerHostUseCase(this._repository);

  Future<String> call({required String hostName}) =>
      _repository.startHosting(hostName: hostName);
}

/// Joins a remote room at host address.
class JoinMultiplayerRoomUseCase {
  final MultiplayerRepository _repository;
  const JoinMultiplayerRoomUseCase(this._repository);

  Future<void> call({
    required String hostAddress,
    required String guesserName,
  }) =>
      _repository.joinRoom(hostAddress: hostAddress, guesserName: guesserName);
}

/// Retrieves decks for host to choose from.
class GetMultiplayerDecksUseCase {
  final MultiplayerRepository _repository;
  const GetMultiplayerDecksUseCase(this._repository);

  Future<List<DeckItem>> call() => _repository.getAvailableDecks();
}

/// Selects a deck and triggers question generation.
class SelectMultiplayerDeckUseCase {
  final MultiplayerRepository _repository;
  const SelectMultiplayerDeckUseCase(this._repository);

  Future<void> call(String deckId) => _repository.selectDeck(deckId);
}

/// Submits host answer for current question.
class SubmitHostAnswerUseCase {
  final MultiplayerRepository _repository;
  const SubmitHostAnswerUseCase(this._repository);

  Future<void> call(String option) => _repository.submitHostAnswer(option);
}

/// Submits guesser answer for current question.
class SubmitGuesserAnswerUseCase {
  final MultiplayerRepository _repository;
  const SubmitGuesserAnswerUseCase(this._repository);

  Future<void> call(String option) => _repository.submitGuesserAnswer(option);
}

/// Advances to the next question.
class AdvanceMultiplayerQuestionUseCase {
  final MultiplayerRepository _repository;
  const AdvanceMultiplayerQuestionUseCase(this._repository);

  Future<void> call() => _repository.advanceToNextQuestion();
}

/// Leaves the multiplayer room and disconnects.
class LeaveMultiplayerRoomUseCase {
  final MultiplayerRepository _repository;
  const LeaveMultiplayerRoomUseCase(this._repository);

  Future<void> call() => _repository.leaveRoom();
}
