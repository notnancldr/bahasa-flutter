import '../../domain/entities/quiz_question.dart';
import '../../domain/entities/study_session_result.dart';

/// Feedback overlay status after checking an answer in Quiz.
enum QuizFeedbackStatus {
  /// No answer checked yet for the current question.
  none,

  /// User's answer was correct (`quiz_correct.png`).
  correct,

  /// User's answer was wrong (`quiz_wrong.png`).
  wrong,
}

/// State definitions for [QuizBloc].
sealed class QuizState {
  /// Base constructor for [QuizState].
  const QuizState();
}

/// Loading state while quiz questions are generated and session is initialized.
final class QuizLoading extends QuizState {
  /// Creates a [QuizLoading].
  const QuizLoading();
}

/// Active state while the user is answering a Quiz question.
final class QuizInProgress extends QuizState {
  /// Deck ID being studied.
  final String deckId;

  /// Active SQLite session ID.
  final String sessionId;

  /// Epoch timestamp (ms) when the session started.
  final int sessionStartedAtMs;

  /// Epoch timestamp (ms) when the current question was presented.
  final int questionStartedAtMs;

  /// Generated list of quiz questions for this session.
  final List<QuizQuestion> questions;

  /// Zero-based index of the current question.
  final int currentIndex;

  /// Currently selected multiple-choice option, if any.
  final String? selectedOption;

  /// Ordered indices into `currentQuestion.wordBank` chosen for Jumble Words.
  final List<int> selectedWordIndices;

  /// Current feedback sheet status (`none`, `correct`, or `wrong`).
  final QuizFeedbackStatus feedbackStatus;

  /// Recorded boolean outcomes for questions answered so far.
  final List<bool> outcomes;

  /// Creates a [QuizInProgress] state.
  const QuizInProgress({
    required this.deckId,
    required this.sessionId,
    required this.sessionStartedAtMs,
    required this.questionStartedAtMs,
    required this.questions,
    required this.currentIndex,
    this.selectedOption,
    this.selectedWordIndices = const [],
    this.feedbackStatus = QuizFeedbackStatus.none,
    this.outcomes = const [],
  });

  /// Currently active [QuizQuestion].
  QuizQuestion get currentQuestion => questions[currentIndex];

  /// Total number of questions in this session.
  int get totalQuestions => questions.length;

  /// Whether the user has provided an answer that can be checked.
  bool get canCheckAnswer {
    if (feedbackStatus != QuizFeedbackStatus.none) return false;
    return switch (currentQuestion.type) {
      QuizQuestionType.multipleChoice =>
        selectedOption != null && selectedOption!.trim().isNotEmpty,
      QuizQuestionType.jumbleWords => selectedWordIndices.isNotEmpty,
    };
  }
}

/// Completed state displaying the Quiz star summary screen (`quiz_complete.png`).
final class QuizCompleted extends QuizState {
  /// Final session statistics and per-question outcomes.
  final StudySessionResult result;

  /// Creates a [QuizCompleted].
  const QuizCompleted(this.result);
}

/// Error state when starting or recording a quiz session fails.
final class QuizError extends QuizState {
  /// Error description.
  final String message;

  /// Creates a [QuizError].
  const QuizError(this.message);
}
