import '../../domain/entities/euy_deck.dart';
import 'euy_card_model.dart';

/// Data model representing a deck loaded from an `.euy` JSON file.
class EuyDeckModel extends EuyDeck {
  const EuyDeckModel({
    required super.id,
    required super.name,
    required super.language,
    required super.difficulty,
    required super.rolePlay,
    required super.explanationRolePlay,
    required super.listCards,
  });

  /// Factory creating an [EuyDeckModel] from JSON with schema validation.
  factory EuyDeckModel.fromJson(Map<String, dynamic> json) {
    final requiredKeys = [
      'id',
      'name',
      'language',
      'difficulty',
      'rolePlay',
      'explanationRolePlay',
      'listCards',
    ];

    for (final key in requiredKeys) {
      if (!json.containsKey(key)) {
        throw FormatException('Missing required deck property: $key');
      }
    }

    final diff = json['difficulty'] as String;
    if (diff != 'beginner' && diff != 'intermediate' && diff != 'expert') {
      throw FormatException(
        'Invalid difficulty "$diff". Must be beginner, intermediate, or expert.',
      );
    }

    final rawCards = json['listCards'];
    if (rawCards is! List) {
      throw const FormatException('listCards must be a JSON array.');
    }

    final cards = <EuyCardModel>[];
    for (final c in rawCards) {
      if (c is! Map<String, dynamic>) {
        throw const FormatException('Card item must be a JSON object.');
      }
      cards.add(EuyCardModel.fromJson(c));
    }

    return EuyDeckModel(
      id: json['id'] as String,
      name: json['name'] as String,
      language: json['language'] as String,
      difficulty: diff,
      rolePlay: json['rolePlay'] as String,
      explanationRolePlay: json['explanationRolePlay'] as String,
      listCards: cards,
    );
  }

  /// Converts this deck into a map for insertion into the `decks` table in `basa.sqlite`.
  Map<String, dynamic> toMainDbMap({required int nowEpochMs}) {
    return {
      'id': id,
      'name': name,
      'language': language,
      'difficulty': difficulty,
      'description': explanationRolePlay,
      'rolePlay': rolePlay,
      'explanationRolePlay': explanationRolePlay,
      'activeTime': 0,
      'lastStudiedAt': null,
      'createdAt': nowEpochMs,
      'updatedAt': nowEpochMs,
    };
  }
}
