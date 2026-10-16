/// Events dispatched to [QuizBloc].
sealed class QuizEvent {
  /// Base constructor for [QuizEvent].
  const QuizEvent();
}

/// Starts a new 10-question Quiz session for [deckId].
final class StartQuizSessionEvent extends QuizEvent {
  /// Target deck identifier.
  final String deckId;

  /// Creates a [StartQuizSessionEvent].
  const StartQuizSessionEvent(this.deckId);
}

/// Selects a multiple-choice [option] for the current question.
final class SelectQuizOptionEvent extends QuizEvent {
  /// Selected answer option text.
  final String option;

  /// Creates a [SelectQuizOptionEvent].
  const SelectQuizOptionEvent(this.option);
}

/// Toggles a word token at [wordBankIndex] in/out of the Jumble Words answer box.
final class ToggleQuizJumbleWordEvent extends QuizEvent {
  /// Index in the current question's `wordBank`.
  final int wordBankIndex;

  /// Creates a [ToggleQuizJumbleWordEvent].
  const ToggleQuizJumbleWordEvent(this.wordBankIndex);
}

/// Evaluates the currently selected answer, records the log in SQLite,
/// and shows the Correct/Wrong feedback sheet.
final class CheckQuizAnswerEvent extends QuizEvent {
  /// Creates a [CheckQuizAnswerEvent].
  const CheckQuizAnswerEvent();
}

/// Proceeds from the feedback sheet to the next question or completes the session.
final class NextQuizQuestionEvent extends QuizEvent {
  /// Creates a [NextQuizQuestionEvent].
  const NextQuizQuestionEvent();
}
