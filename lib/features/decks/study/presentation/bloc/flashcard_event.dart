/// Events dispatched to [FlashcardBloc].
sealed class FlashcardEvent {
  /// Base constructor for [FlashcardEvent].
  const FlashcardEvent();
}

/// Initializes a new 10-card Flashcard session for [deckId].
final class StartFlashcardSessionEvent extends FlashcardEvent {
  /// Target deck identifier.
  final String deckId;

  /// Creates a [StartFlashcardSessionEvent].
  const StartFlashcardSessionEvent(this.deckId);
}

/// Flips the current flashcard between Question (`Pertanyaan`) and Answer (`Jawaban`).
final class FlipFlashcardEvent extends FlashcardEvent {
  /// Creates a [FlipFlashcardEvent].
  const FlipFlashcardEvent();
}

/// Submits the user's self-assessment (`isMemorized = true` for "Sudah hafal",
/// `false` for "Belum hafal") and advances to the next card or completes the session.
final class AnswerFlashcardEvent extends FlashcardEvent {
  /// Whether the user marked the card as memorized (`true`) or not (`false`).
  final bool isMemorized;

  /// Creates an [AnswerFlashcardEvent].
  const AnswerFlashcardEvent({required this.isMemorized});
}
