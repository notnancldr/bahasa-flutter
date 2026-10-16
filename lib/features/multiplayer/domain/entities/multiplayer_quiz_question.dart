/// Domain entity representing a single 4-option question in a multiplayer quiz session.
class MultiplayerQuizQuestion {
  /// Associated card id in the deck.
  final String cardId;

  /// Prompt text shown to the host (e.g., phrase/meaning to test).
  final String prompt;

  /// Target word/term that the host must elaborate/explain to the guesser.
  final String targetWord;

  /// 4 multiple choice options.
  final List<String> options;

  /// Expected canonical answer matching one of [options].
  final String correctAnswer;

  /// Creates a [MultiplayerQuizQuestion].
  const MultiplayerQuizQuestion({
    required this.cardId,
    required this.prompt,
    required this.targetWord,
    required this.options,
    required this.correctAnswer,
  });

  /// Serializes question to JSON map for synchronization across devices.
  Map<String, dynamic> toJson() => {
    'cardId': cardId,
    'prompt': prompt,
    'targetWord': targetWord,
    'options': options,
    'correctAnswer': correctAnswer,
  };

  /// Deserializes question from JSON map.
  factory MultiplayerQuizQuestion.fromJson(Map<String, dynamic> json) {
    return MultiplayerQuizQuestion(
      cardId: json['cardId'] as String? ?? '',
      prompt: json['prompt'] as String? ?? '',
      targetWord: json['targetWord'] as String? ?? '',
      options: (json['options'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      correctAnswer: json['correctAnswer'] as String? ?? '',
    );
  }
}
