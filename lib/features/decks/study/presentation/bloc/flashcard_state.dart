import 'package:bahasa/features/decks/deck_details/domain/entities/deck_card_item.dart';

import '../../domain/entities/study_session_result.dart';

/// State definitions for [FlashcardBloc].
sealed class FlashcardState {
  /// Base constructor for [FlashcardState].
  const FlashcardState();
}

/// Loading state while cards are shuffled and the session is created.
final class FlashcardLoading extends FlashcardState {
  /// Creates a [FlashcardLoading].
  const FlashcardLoading();
}

/// Active state while the user is reviewing a flashcard.
final class FlashcardInProgress extends FlashcardState {
  /// Deck ID being studied.
  final String deckId;

  /// Active SQLite session ID.
  final String sessionId;

  /// Epoch timestamp (ms) when the session started.
  final int sessionStartedAtMs;

  /// Epoch timestamp (ms) when the current card was first shown.
  final int cardStartedAtMs;

  /// Ordered list of cards in this session.
  final List<DeckCardItem> cards;

  /// Zero-based index of the current card.
  final int currentIndex;

  /// Whether the current card is flipped to show the answer.
  final bool isFlipped;

  /// Recorded outcomes for completed cards so far.
  final List<bool> outcomes;

  /// Creates a [FlashcardInProgress] state.
  const FlashcardInProgress({
    required this.deckId,
    required this.sessionId,
    required this.sessionStartedAtMs,
    required this.cardStartedAtMs,
    required this.cards,
    required this.currentIndex,
    required this.isFlipped,
    required this.outcomes,
  });

  /// Currently displayed flashcard.
  DeckCardItem get currentCard => cards[currentIndex];

  /// Total number of cards in this session.
  int get totalCards => cards.length;
}

/// Completed state displaying the Flashcard session summary (`Latihan Selesai`).
final class FlashcardCompleted extends FlashcardState {
  /// Completed session statistics and per-card outcomes.
  final StudySessionResult result;

  /// Creates a [FlashcardCompleted].
  const FlashcardCompleted(this.result);
}

/// Error state when starting or recording a flashcard session fails.
final class FlashcardError extends FlashcardState {
  /// Error description.
  final String message;

  /// Creates a [FlashcardError].
  const FlashcardError(this.message);
}
