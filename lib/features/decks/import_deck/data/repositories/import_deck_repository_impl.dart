import 'dart:io';

import 'package:bahasa/core/utils/deck_db_loader.dart';
import 'package:bahasa/core/utils/main_db_loader.dart';

import '../../domain/entities/euy_deck.dart';
import '../../domain/entities/euy_file_property.dart';
import '../../domain/entities/euy_validation_result.dart';
import '../../domain/repositories/import_deck_repository.dart';
import '../datasources/euy_file_data_source.dart';

/// Implementation of [ImportDeckRepository] integrating file reading and SQLite storage.
class ImportDeckRepositoryImpl implements ImportDeckRepository {
  final EuyFileDataSource _fileDataSource;
  final MainDbLoader _mainDbLoader;
  final DeckDbLoader _deckDbLoader;
  final Directory? _overrideStorageDirectory;

  const ImportDeckRepositoryImpl({
    EuyFileDataSource? fileDataSource,
    MainDbLoader? mainDbLoader,
    DeckDbLoader? deckDbLoader,
    this._overrideStorageDirectory,
  }) : _fileDataSource = fileDataSource ?? const EuyFileDataSourceImpl(),
       _mainDbLoader = mainDbLoader ?? const MainDbLoader(),
       _deckDbLoader = deckDbLoader ?? const DeckDbLoader();

  @override
  Future<String?> pickEuyFile() async {
    return _fileDataSource.pickEuyFile();
  }

  @override
  Future<EuyFileProperty> getFileProperty(String filePath) async {
    final name = filePath.split(Platform.pathSeparator).last;
    final size = await _fileDataSource.getFileSizeFormatted(filePath);
    return EuyFileProperty(path: filePath, name: name, sizeFormatted: size);
  }

  @override
  Future<EuyValidationResult> validateFile(String filePath) async {
    try {
      final deckModel = await _fileDataSource.readEuyFile(filePath);
      final size = await _fileDataSource.getFileSizeFormatted(filePath);
      return EuyValidationResult.valid(
        deck: deckModel,
        fileSizeFormatted: size,
      );
    } catch (e) {
      return EuyValidationResult.invalid(errorMessage: e.toString());
    }
  }

  @override
  Future<void> importDeck(EuyDeck deck) async {
    final nowMs = DateTime.now().millisecondsSinceEpoch;

    // 1. Insert or update deck in basa.sqlite
    final mainDb = await _mainDbLoader.openDatabase(
      overrideDirectory: _overrideStorageDirectory,
    );
    try {
      final stmt = mainDb.prepare('''
        INSERT OR REPLACE INTO decks (
          id, name, language, difficulty, description, rolePlay,
          explanationRolePlay, activeTime, lastStudiedAt, createdAt, updatedAt
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
      ''');
      stmt.execute([
        deck.id,
        deck.name,
        deck.language,
        deck.difficulty,
        deck.explanationRolePlay,
        deck.rolePlay,
        deck.explanationRolePlay,
        0,
        null,
        nowMs,
        nowMs,
      ]);
      stmt.close();
    } finally {
      mainDb.close();
    }

    // 2. Insert or update cards in deck_<uuid>.sqlite
    final deckDb = await _deckDbLoader.openDeckDatabase(
      deck.id,
      overrideDirectory: _overrideStorageDirectory,
    );
    try {
      final stmt = deckDb.prepare('''
        INSERT OR REPLACE INTO cards (
          idCard, defaultLanguage, translation, phoneticLang, audioPath,
          additionalContext, reps, correctAnswer, finalScore, createdAt, updatedAt
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
      ''');

      for (final card in deck.listCards) {
        stmt.execute([
          card.idCard,
          card.defaultLanguage,
          card.translation,
          card.phoneticLang,
          null,
          card.additionalContext,
          card.reps,
          card.correctAnswer,
          card.finalScore,
          nowMs,
          nowMs,
        ]);
      }
      stmt.close();
    } finally {
      deckDb.close();
    }
  }
}
