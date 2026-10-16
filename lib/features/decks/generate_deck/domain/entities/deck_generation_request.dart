/// Parameter model containing configuration options collected during the wizard flow.
class DeckGenerationRequest {
  /// User-defined title for the deck.
  final String name;

  /// Target country/language code.
  final String language;

  /// Selected proficiency level: `beginner`, `intermediate`, or `expert`.
  final String difficulty;

  /// Study focus or description prompt for card generation.
  final String description;

  const DeckGenerationRequest({
    required this.name,
    required this.language,
    required this.difficulty,
    required this.description,
  });

  bool get isValid =>
      name.trim().isNotEmpty &&
      language.trim().isNotEmpty &&
      difficulty.trim().isNotEmpty;
}
