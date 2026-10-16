/// Domain entity representing a saved flashcard deck in the application.
class DeckItem {
  /// Unique identifier of the deck.
  final String id;

  /// User-facing name of the deck (e.g., "Kosakata Bahasa Jepang").
  final String name;

  /// Target language ISO 639-1 code of the deck (e.g., "ja", "en", "id").
  final String language;

  /// Difficulty level of the deck (e.g., "beginner", "intermediate", "expert").
  final String difficulty;

  /// Optional study focus description of the deck.
  final String? description;

  /// Total active study time in milliseconds.
  final int activeTime;

  /// Epoch timestamp (ms) when the deck was last studied, if ever.
  final int? lastStudiedAt;

  /// Epoch timestamp (ms) when the deck was created.
  final int createdAt;

  /// Epoch timestamp (ms) when the deck was last modified.
  final int updatedAt;

  /// Creates a [DeckItem] entity.
  const DeckItem({
    required this.id,
    required this.name,
    required this.language,
    required this.difficulty,
    this.description,
    required this.activeTime,
    this.lastStudiedAt,
    required this.createdAt,
    required this.updatedAt,
  });
}
