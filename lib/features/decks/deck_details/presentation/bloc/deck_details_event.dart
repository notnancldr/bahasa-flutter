/// Events dispatched to [DeckDetailsBloc].
sealed class DeckDetailsEvent {
  /// Base constructor for [DeckDetailsEvent].
  const DeckDetailsEvent();
}

/// Requests loading or refreshing the deck details and cards for [deckId].
final class LoadDeckDetailsEvent extends DeckDetailsEvent {
  /// Target deck identifier.
  final String deckId;

  /// Creates a [LoadDeckDetailsEvent].
  const LoadDeckDetailsEvent(this.deckId);
}

/// Updates the card search query to filter the deck's cards list.
final class SearchDeckCardsChangedEvent extends DeckDetailsEvent {
  /// User-entered search text.
  final String query;

  /// Creates a [SearchDeckCardsChangedEvent].
  const SearchDeckCardsChangedEvent(this.query);
}
