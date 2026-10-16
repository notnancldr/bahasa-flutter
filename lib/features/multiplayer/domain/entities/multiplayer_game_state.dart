import 'multiplayer_player.dart';
import 'multiplayer_quiz_question.dart';

/// Phase of the multiplayer session lifecycle.
enum MultiplayerPhase {
  initial,
  hosting,
  joining,
  lobby,
  deckSelection,
  hostAnswering,
  hostWrongFeedback,
  guesserTurn,
  scoreFeedback,
  completed,
  disconnected,
}

/// Role of the local device in the multiplayer game.
enum MultiplayerRole { host, guesser }

/// Immutable state snapshot of the active multiplayer game session.
class MultiplayerGameState {
  /// Current game lifecycle phase.
  final MultiplayerPhase phase;

  /// Room host details.
  final MultiplayerPlayer? hostPlayer;

  /// Connected guesser details.
  final MultiplayerPlayer? guesserPlayer;

  /// ID of the deck currently selected for study.
  final String? deckId;

  /// Title of the selected deck.
  final String? deckTitle;

  /// List of 10 questions for this session.
  final List<MultiplayerQuizQuestion> questions;

  /// Current 0-based question index (0 to 9).
  final int currentQuestionIndex;

  /// Synchronized total team score shared by both players.
  final int totalScore;

  /// List of question outcomes: true if guesser correct (+1), false if guesser wrong (-1), null if host skipped (+0).
  final List<bool?> outcomes;

  /// Score delta of the most recent evaluation (+1, -1, or 0).
  final int lastScoreDelta;

  /// Last option selected by the host.
  final String? hostSelectedOption;

  /// Last option selected by the guesser.
  final String? guesserSelectedOption;

  /// Timestamp when the session began in milliseconds.
  final int startedAtMs;

  /// Total duration in milliseconds upon completion.
  final int durationMs;

  /// Error message if something failed.
  final String? errorMessage;

  /// Creates a [MultiplayerGameState].
  const MultiplayerGameState({
    this.phase = MultiplayerPhase.initial,
    this.hostPlayer,
    this.guesserPlayer,
    this.deckId,
    this.deckTitle,
    this.questions = const [],
    this.currentQuestionIndex = 0,
    this.totalScore = 0,
    this.outcomes = const [],
    this.lastScoreDelta = 0,
    this.hostSelectedOption,
    this.guesserSelectedOption,
    this.startedAtMs = 0,
    this.durationMs = 0,
    this.errorMessage,
  });

  /// The current active question, or null if outside a question phase.
  MultiplayerQuizQuestion? get currentQuestion =>
      (currentQuestionIndex >= 0 && currentQuestionIndex < questions.length)
      ? questions[currentQuestionIndex]
      : null;

  /// Number of correct guesser answers.
  int get correctCount => outcomes.where((o) => o == true).length;

  /// Total number of questions configured (defaults to 10).
  int get totalQuestions => questions.isEmpty ? 10 : questions.length;

  /// Copies state with optional updated fields.
  MultiplayerGameState copyWith({
    MultiplayerPhase? phase,
    MultiplayerPlayer? hostPlayer,
    MultiplayerPlayer? guesserPlayer,
    String? deckId,
    String? deckTitle,
    List<MultiplayerQuizQuestion>? questions,
    int? currentQuestionIndex,
    int? totalScore,
    List<bool?>? outcomes,
    int? lastScoreDelta,
    String? hostSelectedOption,
    String? guesserSelectedOption,
    int? startedAtMs,
    int? durationMs,
    String? errorMessage,
  }) {
    return MultiplayerGameState(
      phase: phase ?? this.phase,
      hostPlayer: hostPlayer ?? this.hostPlayer,
      guesserPlayer: guesserPlayer ?? this.guesserPlayer,
      deckId: deckId ?? this.deckId,
      deckTitle: deckTitle ?? this.deckTitle,
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      totalScore: totalScore ?? this.totalScore,
      outcomes: outcomes ?? this.outcomes,
      lastScoreDelta: lastScoreDelta ?? this.lastScoreDelta,
      hostSelectedOption: hostSelectedOption ?? this.hostSelectedOption,
      guesserSelectedOption:
          guesserSelectedOption ?? this.guesserSelectedOption,
      startedAtMs: startedAtMs ?? this.startedAtMs,
      durationMs: durationMs ?? this.durationMs,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Serializes state to JSON map for network synchronization via SSE.
  Map<String, dynamic> toJson() => {
    'phase': phase.name,
    'hostPlayer': hostPlayer?.toJson(),
    'guesserPlayer': guesserPlayer?.toJson(),
    'deckId': deckId,
    'deckTitle': deckTitle,
    'questions': questions.map((q) => q.toJson()).toList(),
    'currentQuestionIndex': currentQuestionIndex,
    'totalScore': totalScore,
    'outcomes': outcomes,
    'lastScoreDelta': lastScoreDelta,
    'hostSelectedOption': hostSelectedOption,
    'guesserSelectedOption': guesserSelectedOption,
    'startedAtMs': startedAtMs,
    'durationMs': durationMs,
    'errorMessage': errorMessage,
  };

  /// Deserializes state from JSON map.
  factory MultiplayerGameState.fromJson(Map<String, dynamic> json) {
    return MultiplayerGameState(
      phase: MultiplayerPhase.values.firstWhere(
        (e) => e.name == json['phase'],
        orElse: () => MultiplayerPhase.initial,
      ),
      hostPlayer: json['hostPlayer'] != null
          ? MultiplayerPlayer.fromJson(
              json['hostPlayer'] as Map<String, dynamic>,
            )
          : null,
      guesserPlayer: json['guesserPlayer'] != null
          ? MultiplayerPlayer.fromJson(
              json['guesserPlayer'] as Map<String, dynamic>,
            )
          : null,
      deckId: json['deckId'] as String?,
      deckTitle: json['deckTitle'] as String?,
      questions: (json['questions'] as List<dynamic>? ?? [])
          .map(
            (e) => MultiplayerQuizQuestion.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      currentQuestionIndex: json['currentQuestionIndex'] as int? ?? 0,
      totalScore: json['totalScore'] as int? ?? 0,
      outcomes: (json['outcomes'] as List<dynamic>? ?? [])
          .map((e) => e as bool?)
          .toList(),
      lastScoreDelta: json['lastScoreDelta'] as int? ?? 0,
      hostSelectedOption: json['hostSelectedOption'] as String?,
      guesserSelectedOption: json['guesserSelectedOption'] as String?,
      startedAtMs: json['startedAtMs'] as int? ?? 0,
      durationMs: json['durationMs'] as int? ?? 0,
      errorMessage: json['errorMessage'] as String?,
    );
  }
}
