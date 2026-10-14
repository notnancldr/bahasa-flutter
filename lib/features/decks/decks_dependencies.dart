import 'package:bahasa/core/utils/deck_db_loader.dart';
import 'package:bahasa/core/utils/main_db_loader.dart';

import 'generate_deck/data/repositories/generate_deck_repository_impl.dart';
import 'generate_deck/domain/repositories/generate_deck_repository.dart';
import 'generate_deck/domain/usecases/generate_deck_usecase.dart';
import 'generate_deck/presentation/bloc/generate_deck_bloc.dart';
import 'import_deck/data/datasources/euy_file_data_source.dart';
import 'import_deck/data/repositories/import_deck_repository_impl.dart';
import 'import_deck/domain/repositories/import_deck_repository.dart';
import 'import_deck/domain/usecases/import_euy_deck_usecase.dart';
import 'import_deck/domain/usecases/validate_euy_file_usecase.dart';
import 'import_deck/presentation/bloc/import_deck_bloc.dart';

/// Central dependency container and factory for the Decks feature module.
abstract class DecksDependencies {
  static final MainDbLoader _mainDbLoader = const MainDbLoader();
  static final DeckDbLoader _deckDbLoader = const DeckDbLoader();

  /// Creates an [ImportDeckRepository] instance.
  static ImportDeckRepository createImportDeckRepository({
    EuyFileDataSource? fileDataSource,
  }) {
    return ImportDeckRepositoryImpl(
      fileDataSource: fileDataSource ?? const EuyFileDataSourceImpl(),
      mainDbLoader: _mainDbLoader,
      deckDbLoader: _deckDbLoader,
    );
  }

  /// Creates an [ImportDeckBloc] instance.
  static ImportDeckBloc createImportDeckBloc({
    ImportDeckRepository? repository,
  }) {
    final repo = repository ?? createImportDeckRepository();
    return ImportDeckBloc(
      repository: repo,
      validateUseCase: ValidateEuyFileUseCase(repo),
      importUseCase: ImportEuyDeckUseCase(repo),
    );
  }

  /// Creates a [GenerateDeckRepository] instance.
  static GenerateDeckRepository createGenerateDeckRepository() {
    return const GenerateDeckRepositoryImpl();
  }

  /// Creates a [GenerateDeckBloc] instance.
  static GenerateDeckBloc createGenerateDeckBloc({
    GenerateDeckRepository? repository,
  }) {
    final repo = repository ?? createGenerateDeckRepository();
    return GenerateDeckBloc(generateDeckUseCase: GenerateDeckUseCase(repo));
  }
}
