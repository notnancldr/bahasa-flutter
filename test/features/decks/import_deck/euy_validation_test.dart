import 'dart:convert';
import 'dart:io';

import 'package:bahasa/features/decks/import_deck/data/datasources/euy_file_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory tempDir;
  late EuyFileDataSource dataSource;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('euy_test_');
    dataSource = const EuyFileDataSourceImpl();
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test(
    'correctly parses valid .euy file conforming to euy_schema.json',
    () async {
      final file = File('${tempDir.path}/valid.euy');
      final validJson = {
        'id': 'd100',
        'name': 'Bahasa Spanyol',
        'language': 'es',
        'difficulty': 'beginner',
        'rolePlay': 'Amigo en Madrid',
        'explanationRolePlay': 'Explicación sencilla',
        'listCards': [
          {
            'idCard': 'c1',
            'defaultLanguage': 'Halo',
            'translation': 'Hola',
            'phoneticLang': 'o-la',
            'additionalContext': 'Salam ramah',
            'reps': 1,
            'correctAnswer': 1,
            'finalScore': 100,
          },
        ],
      };
      await file.writeAsString(jsonEncode(validJson));

      final deck = await dataSource.readEuyFile(file.path);
      expect(deck.id, equals('d100'));
      expect(deck.name, equals('Bahasa Spanyol'));
      expect(deck.difficulty, equals('beginner'));
      expect(deck.listCards.length, equals(1));
      expect(deck.listCards.first.translation, equals('Hola'));
    },
  );

  test(
    'throws FormatException when required deck fields are missing',
    () async {
      final file = File('${tempDir.path}/missing_fields.euy');
      final invalidJson = {
        'id': 'd100',
        'name': 'Bahasa Spanyol',
        // missing language, difficulty, etc.
      };
      await file.writeAsString(jsonEncode(invalidJson));

      expect(
        () => dataSource.readEuyFile(file.path),
        throwsA(isA<FormatException>()),
      );
    },
  );

  test('throws FormatException when difficulty enum is invalid', () async {
    final file = File('${tempDir.path}/invalid_diff.euy');
    final invalidJson = {
      'id': 'd100',
      'name': 'Deck',
      'language': 'en',
      'difficulty': 'god_mode', // invalid enum
      'rolePlay': 'Role',
      'explanationRolePlay': 'Exp',
      'listCards': [],
    };
    await file.writeAsString(jsonEncode(invalidJson));

    expect(
      () => dataSource.readEuyFile(file.path),
      throwsA(isA<FormatException>()),
    );
  });
}
