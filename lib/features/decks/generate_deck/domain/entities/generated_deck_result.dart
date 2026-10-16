/// Represents the outcome of the deck generation operation.
class GeneratedDeckResult {
  /// Unique identifier of the created deck.
  final String deckId;

  /// Deck title.
  final String name;

  /// Total count of cards generated.
  final int cardCount;

  /// Whether creation succeeded.
  final bool isSuccess;

  /// Error message if generation failed.
  final String? errorMessage;

  const GeneratedDeckResult({
    required this.deckId,
    required this.name,
    required this.cardCount,
    this.isSuccess = true,
    this.errorMessage,
  });

  factory GeneratedDeckResult.failure(String message) {
    return GeneratedDeckResult(
      deckId: '',
      name: '',
      cardCount: 0,
      isSuccess: false,
      errorMessage: message,
    );
  }
}
