/// Base class for all events processed by [DeckBloc].
sealed class DeckEvent {
  /// Creates a [DeckEvent].
  const DeckEvent();
}

/// Requests loading or refreshing the list of saved decks from local storage.
class LoadDecksEvent extends DeckEvent {
  /// Creates a [LoadDecksEvent].
  const LoadDecksEvent();
}

/// Updates the search query used to filter visible decks by name.
class SearchDecksChangedEvent extends DeckEvent {
  /// The current search input text.
  final String query;

  /// Creates a [SearchDecksChangedEvent] with [query].
  const SearchDecksChangedEvent(this.query);
}

/// Enters multi-select mode and selects [initialDeckId].
class EnterDeckSelectionModeEvent extends DeckEvent {
  /// The ID of the deck that triggered selection mode (e.g., via long press).
  final String initialDeckId;

  /// Creates an [EnterDeckSelectionModeEvent] for [initialDeckId].
  const EnterDeckSelectionModeEvent(this.initialDeckId);
}

/// Toggles the selection state of [deckId] while in selection mode.
class ToggleDeckSelectionEvent extends DeckEvent {
  /// The ID of the deck to toggle.
  final String deckId;

  /// Creates a [ToggleDeckSelectionEvent] for [deckId].
  const ToggleDeckSelectionEvent(this.deckId);
}

/// Selects all currently visible (filtered) decks.
class SelectAllDecksEvent extends DeckEvent {
  /// Creates a [SelectAllDecksEvent].
  const SelectAllDecksEvent();
}

/// Deselects all currently selected decks while staying in selection mode.
class DeselectAllDecksEvent extends DeckEvent {
  /// Creates a [DeselectAllDecksEvent].
  const DeselectAllDecksEvent();
}

/// Exits selection mode and clears all deck selections.
class CancelDeckSelectionModeEvent extends DeckEvent {
  /// Creates a [CancelDeckSelectionModeEvent].
  const CancelDeckSelectionModeEvent();
}

/// Permanently deletes all currently selected decks after verifying [verificationUsername].
class ConfirmDeleteSelectedDecksEvent extends DeckEvent {
  /// The username entered by the user to confirm deletion.
  final String verificationUsername;

  /// Creates a [ConfirmDeleteSelectedDecksEvent] with [verificationUsername].
  const ConfirmDeleteSelectedDecksEvent({required this.verificationUsername});
}
