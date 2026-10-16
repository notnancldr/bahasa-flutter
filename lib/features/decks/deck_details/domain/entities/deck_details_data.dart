import 'package:bahasa/features/decks/domain/entities/deck_item.dart';

import 'deck_card_item.dart';

/// Aggregated domain entity containing a deck's metadata, its cards,
/// and summary study metrics (streak and accuracy) for the Deck Details page.
class DeckDetailsData {
  /// Metadata of the deck from `basa.sqlite`.
  final DeckItem deck;

  /// List of all cards belonging to this deck from `deck_<id>.sqlite`.
  final List<DeckCardItem> cards;

  /// Consecutive study days streak for this specific deck.
  final int streakCount;

  /// Overall accuracy percentage (0..100) across all practiced cards/sessions in this deck.
  final int accuracyPercent;

  /// Creates a [DeckDetailsData] entity.
  const DeckDetailsData({
    required this.deck,
    required this.cards,
    required this.streakCount,
    required this.accuracyPercent,
  });
}
