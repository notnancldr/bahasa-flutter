import '../../domain/entities/euy_card.dart';

/// Data model representing a card item with JSON serialization.
class EuyCardModel extends EuyCard {
  const EuyCardModel({
    required super.idCard,
    required super.defaultLanguage,
    required super.translation,
    required super.phoneticLang,
    required super.additionalContext,
    required super.reps,
    required super.correctAnswer,
    required super.finalScore,
  });

  /// Factory creating an [EuyCardModel] from JSON with strict validation.
  factory EuyCardModel.fromJson(Map<String, dynamic> json) {
    final requiredKeys = [
      'idCard',
      'defaultLanguage',
      'translation',
      'phoneticLang',
      'additionalContext',
      'reps',
      'correctAnswer',
      'finalScore',
    ];

    for (final key in requiredKeys) {
      if (!json.containsKey(key)) {
        throw FormatException('Missing required card property: $key');
      }
    }

    return EuyCardModel(
      idCard: json['idCard'] as String,
      defaultLanguage: json['defaultLanguage'] as String,
      translation: json['translation'] as String,
      phoneticLang: json['phoneticLang'] as String,
      additionalContext: json['additionalContext'] as String,
      reps: (json['reps'] as num).toInt(),
      correctAnswer: (json['correctAnswer'] as num).toInt(),
      finalScore: (json['finalScore'] as num).toInt(),
    );
  }

  /// Converts this card into a map representation for database insertion.
  Map<String, dynamic> toDbMap({required int nowEpochMs}) {
    return {
      'idCard': idCard,
      'defaultLanguage': defaultLanguage,
      'translation': translation,
      'phoneticLang': phoneticLang,
      'audioPath': null,
      'additionalContext': additionalContext,
      'reps': reps,
      'correctAnswer': correctAnswer,
      'finalScore': finalScore,
      'createdAt': nowEpochMs,
      'updatedAt': nowEpochMs,
    };
  }
}
