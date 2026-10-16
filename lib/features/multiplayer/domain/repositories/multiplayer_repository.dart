import 'package:bahasa/features/decks/domain/entities/deck_item.dart';

import '../entities/multiplayer_game_state.dart';

/// Contract for the multiplayer quiz repository.
abstract class MultiplayerRepository {
  /// Stream of reactive state updates reflecting the real-time multiplayer session.
  Stream<MultiplayerGameState> get gameStateStream;

  /// Current synchronous state snapshot.
  MultiplayerGameState get currentState;

  /// Current assigned role of the local player, or null if unassigned.
  MultiplayerRole? get currentRole;

  /// Starts the Shelf HTTP server on the host device, binding to local Wi-Fi.
  /// Returns the detected host IP address.
  Future<String> startHosting({required String hostName});

  /// Joins a remote host room at [hostAddress] as the guesser.
  Future<void> joinRoom({
    required String hostAddress,
    required String guesserName,
  });

  /// Fetches available decks from the local SQLite repository for the host to select.
  Future<List<DeckItem>> getAvailableDecks();

  /// Host selects a deck by [deckId], generates 10 quiz questions, and initializes the session.
  Future<void> selectDeck(String deckId);

  /// Host submits their multiple-choice answer for the current question.
  Future<void> submitHostAnswer(String selectedOption);

  /// Guesser submits their multiple-choice guess for the current question.
  Future<void> submitGuesserAnswer(String selectedOption);

  /// Advances to the next question or finalizes the session.
  Future<void> advanceToNextQuestion();

  /// Gracefully leaves the active room and cleans up resources.
  Future<void> leaveRoom();

  /// Shuts down the host server if active.
  Future<void> stopServer();
}
