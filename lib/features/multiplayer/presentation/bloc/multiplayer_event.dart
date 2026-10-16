import '../../domain/entities/multiplayer_game_state.dart';

/// Base event for [MultiplayerBloc].
sealed class MultiplayerEvent {
  const MultiplayerEvent();
}

/// Triggers host server creation.
class StartHostRoomEvent extends MultiplayerEvent {
  final String hostName;
  const StartHostRoomEvent({required this.hostName});
}

/// Triggers guesser join room.
class JoinRoomEvent extends MultiplayerEvent {
  final String hostAddress;
  final String guesserName;
  const JoinRoomEvent({required this.hostAddress, required this.guesserName});
}

/// Loads decks for host deck selection screen.
class LoadMultiplayerDecksEvent extends MultiplayerEvent {
  const LoadMultiplayerDecksEvent();
}

/// Filters decks list in deck selection screen.
class FilterMultiplayerDecksEvent extends MultiplayerEvent {
  final String query;
  const FilterMultiplayerDecksEvent(this.query);
}

/// Host selects a deck.
class SelectMultiplayerDeckEvent extends MultiplayerEvent {
  final String deckId;
  const SelectMultiplayerDeckEvent(this.deckId);
}

/// Host submits multiple-choice option.
class SubmitHostAnswerEvent extends MultiplayerEvent {
  final String option;
  const SubmitHostAnswerEvent(this.option);
}

/// Guesser submits multiple-choice option.
class SubmitGuesserAnswerEvent extends MultiplayerEvent {
  final String option;
  const SubmitGuesserAnswerEvent(this.option);
}

/// Host taps "Lanjutkan Soal" to proceed to next question.
class ContinueToNextQuestionEvent extends MultiplayerEvent {
  const ContinueToNextQuestionEvent();
}

/// Player leaves room or host stops server.
class LeaveMultiplayerEvent extends MultiplayerEvent {
  const LeaveMultiplayerEvent();
}

/// Internal stream event bridging repository updates to BLoC.
class InternalGameStateUpdatedEvent extends MultiplayerEvent {
  final MultiplayerGameState gameState;
  const InternalGameStateUpdatedEvent(this.gameState);
}
