import 'package:bahasa/features/decks/domain/entities/deck_item.dart';

import '../../domain/entities/multiplayer_game_state.dart';

/// State representation for [MultiplayerBloc].
class MultiplayerState {
  /// Core synchronized game state.
  final MultiplayerGameState game;

  /// Assigned role on this local device.
  final MultiplayerRole? role;

  /// Local host IP address when in hosting mode.
  final String? hostIp;

  /// List of decks available to host for selection.
  final List<DeckItem> decks;

  /// Current search query in deck selection.
  final String searchQuery;

  /// Loading indicator for async operations (connection, etc.).
  final bool isLoading;

  /// User-facing error message.
  final String? errorMessage;

  const MultiplayerState({
    this.game = const MultiplayerGameState(),
    this.role,
    this.hostIp,
    this.decks = const [],
    this.searchQuery = '',
    this.isLoading = false,
    this.errorMessage,
  });

  /// Convenience helper checking if local player is host.
  bool get isHost => role == MultiplayerRole.host;

  /// Current phase of the session.
  MultiplayerPhase get phase => game.phase;

  /// Filtered list of decks based on [searchQuery].
  List<DeckItem> get filteredDecks {
    final q = searchQuery.trim().toLowerCase();
    if (q.isEmpty) return decks;
    return decks.where((d) => d.name.toLowerCase().contains(q)).toList();
  }

  /// Copies state with optional updated fields.
  MultiplayerState copyWith({
    MultiplayerGameState? game,
    MultiplayerRole? role,
    String? hostIp,
    List<DeckItem>? decks,
    String? searchQuery,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MultiplayerState(
      game: game ?? this.game,
      role: role ?? this.role,
      hostIp: hostIp ?? this.hostIp,
      decks: decks ?? this.decks,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
