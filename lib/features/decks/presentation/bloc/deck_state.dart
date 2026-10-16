import '../../domain/entities/deck_item.dart';

/// Base class for all states emitted by [DeckBloc].
sealed class DeckState {
  /// Creates a [DeckState].
  const DeckState();
}

/// Initial state before decks have been requested.
class DeckInitial extends DeckState {
  /// Creates a [DeckInitial] state.
  const DeckInitial();
}

/// State emitted while querying decks from local SQLite storage.
class DeckLoading extends DeckState {
  /// Creates a [DeckLoading] state.
  const DeckLoading();
}

/// State emitted when decks are loaded and ready for display, search, or selection.
class DeckLoaded extends DeckState {
  /// All decks stored in the database.
  final List<DeckItem> allDecks;

  /// Decks matching the active [searchQuery].
  final List<DeckItem> filteredDecks;

  /// Current search filter text.
  final String searchQuery;

  /// Whether the page is currently in multi-selection mode.
  final bool isSelectionMode;

  /// Set of deck IDs currently selected in selection mode.
  final Set<String> selectedDeckIds;

  /// Optional transient error message (e.g., if deletion failed).
  final String? errorMessage;

  /// Creates a [DeckLoaded] state.
  const DeckLoaded({
    required this.allDecks,
    required this.filteredDecks,
    this.searchQuery = '',
    this.isSelectionMode = false,
    this.selectedDeckIds = const <String>{},
    this.errorMessage,
  });

  /// Returns `true` when there are visible decks and every visible deck is selected.
  bool get isAllSelected =>
      filteredDecks.isNotEmpty &&
      filteredDecks.every((deck) => selectedDeckIds.contains(deck.id));

  /// Number of currently selected decks.
  int get selectedCount => selectedDeckIds.length;

  /// Creates a copy of this [DeckLoaded] state with updated fields.
  DeckLoaded copyWith({
    List<DeckItem>? allDecks,
    List<DeckItem>? filteredDecks,
    String? searchQuery,
    bool? isSelectionMode,
    Set<String>? selectedDeckIds,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DeckLoaded(
      allDecks: allDecks ?? this.allDecks,
      filteredDecks: filteredDecks ?? this.filteredDecks,
      searchQuery: searchQuery ?? this.searchQuery,
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      selectedDeckIds: selectedDeckIds ?? this.selectedDeckIds,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// State emitted when loading decks fails with an unrecoverable error.
class DeckError extends DeckState {
  /// Description of the error that occurred.
  final String message;

  /// Creates a [DeckError] state with [message].
  const DeckError(this.message);
}
