import 'euy_deck.dart';

/// Encapsulates the outcome of validating and parsing an `.euy` deck file.
class EuyValidationResult {
  /// Whether the file conforms to the `.euy` specification and schema.
  final bool isValid;

  /// Parsed deck entity if valid, otherwise `null`.
  final EuyDeck? deck;

  /// Error message explaining validation failure if [isValid] is `false`.
  final String? errorMessage;

  /// Approximate file size formatted for display (e.g. '4.1 MB').
  final String fileSizeFormatted;

  const EuyValidationResult({
    required this.isValid,
    this.deck,
    this.errorMessage,
    required this.fileSizeFormatted,
  });

  factory EuyValidationResult.valid({
    required EuyDeck deck,
    required String fileSizeFormatted,
  }) {
    return EuyValidationResult(
      isValid: true,
      deck: deck,
      fileSizeFormatted: fileSizeFormatted,
    );
  }

  factory EuyValidationResult.invalid({
    required String errorMessage,
    String fileSizeFormatted = '0 B',
  }) {
    return EuyValidationResult(
      isValid: false,
      errorMessage: errorMessage,
      fileSizeFormatted: fileSizeFormatted,
    );
  }
}
