import 'euy_card.dart';

/// Represents a validated Deck structure parsed from an `.euy` JSON file.
class EuyDeck {
  /// Unique identifier of the deck.
  final String id;

  /// Display title of the deck.
  final String name;

  /// Target language / country code (e.g. 'ja', 'en', 'id').
  final String language;

  /// Difficulty level (`beginner`, `intermediate`, or `expert`).
  final String difficulty;

  /// Role-play prompt or persona used for card generation/dialogs.
  final String rolePlay;

  /// Explanation persona or system context for concepts.
  final String explanationRolePlay;

  /// List of cards contained in this deck.
  final List<EuyCard> listCards;

  const EuyDeck({
    required this.id,
    required this.name,
    required this.language,
    required this.difficulty,
    required this.rolePlay,
    required this.explanationRolePlay,
    required this.listCards,
  });
}
