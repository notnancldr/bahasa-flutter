import '../../domain/entities/deck_card_item.dart';
import '../../domain/entities/deck_details_data.dart';

/// State definitions for [DeckDetailsBloc].
sealed class DeckDetailsState {
  /// Base constructor for [DeckDetailsState].
  const DeckDetailsState();
}

/// Initial state before deck details have been requested.
final class DeckDetailsInitial extends DeckDetailsState {
  /// Creates a [DeckDetailsInitial].
  const DeckDetailsInitial();
}

/// State while deck details are being loaded from SQLite.
final class DeckDetailsLoading extends DeckDetailsState {
  /// Creates a [DeckDetailsLoading].
  const DeckDetailsLoading();
}

/// State when deck details and cards are loaded.
final class DeckDetailsLoaded extends DeckDetailsState {
  /// Complete deck details and metrics.
  final DeckDetailsData data;

  /// Current search query filtering the cards list.
  final String searchQuery;

  /// Cards matching [searchQuery].
  final List<DeckCardItem> filteredCards;

  /// Creates a [DeckDetailsLoaded] state.
  const DeckDetailsLoaded({
    required this.data,
    required this.searchQuery,
    required this.filteredCards,
  });

  /// Creates a copy of this state with updated fields.
  DeckDetailsLoaded copyWith({
    DeckDetailsData? data,
    String? searchQuery,
    List<DeckCardItem>? filteredCards,
  }) {
    return DeckDetailsLoaded(
      data: data ?? this.data,
      searchQuery: searchQuery ?? this.searchQuery,
      filteredCards: filteredCards ?? this.filteredCards,
    );
  }
}

/// State emitted when loading deck details fails.
final class DeckDetailsError extends DeckDetailsState {
  /// Human-readable error message.
  final String message;

  /// Creates a [DeckDetailsError].
  const DeckDetailsError(this.message);
}
