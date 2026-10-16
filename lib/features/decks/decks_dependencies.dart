import 'package:bahasa/core/utils/deck_db_loader.dart';
import 'package:bahasa/core/utils/main_db_loader.dart';
import 'package:bahasa/features/settings/data/datasources/profile_local_data_source.dart';
import 'package:bahasa/features/settings/settings_dependencies.dart';

import 'data/datasources/deck_local_data_source.dart';
import 'data/repositories/deck_repository_impl.dart';
import 'deck_details/data/datasources/deck_details_local_data_source.dart';
import 'deck_details/data/repositories/deck_details_repository_impl.dart';
import 'deck_details/domain/repositories/deck_details_repository.dart';
import 'deck_details/domain/usecases/get_deck_details_usecase.dart';
import 'deck_details/domain/usecases/get_deck_progress_usecase.dart';
import 'deck_details/presentation/bloc/deck_details_bloc.dart';
import 'deck_details/presentation/bloc/deck_progress_cubit.dart';
import 'deck_history/data/datasources/deck_history_local_data_source.dart';
import 'deck_history/data/repositories/deck_history_repository_impl.dart';
import 'deck_history/domain/repositories/deck_history_repository.dart';
import 'deck_history/domain/usecases/get_deck_history_usecase.dart';
import 'deck_history/domain/usecases/get_session_card_logs_usecase.dart';
import 'deck_history/presentation/bloc/deck_history_bloc.dart';
import 'domain/repositories/deck_repository.dart';
import 'domain/usecases/delete_decks_usecase.dart';
import 'domain/usecases/get_decks_usecase.dart';
import 'generate_deck/data/repositories/generate_deck_repository_impl.dart';
import 'generate_deck/domain/repositories/generate_deck_repository.dart';
import 'generate_deck/domain/usecases/generate_deck_usecase.dart';
import 'generate_deck/presentation/bloc/generate_deck_bloc.dart';
import 'import_deck/data/datasources/euy_file_data_source.dart';
import 'import_deck/data/repositories/import_deck_repository_impl.dart';
import 'import_deck/domain/repositories/import_deck_repository.dart';
import 'import_deck/domain/usecases/get_euy_file_property_usecase.dart';
import 'import_deck/domain/usecases/import_euy_deck_usecase.dart';
import 'import_deck/domain/usecases/validate_euy_file_usecase.dart';
import 'import_deck/presentation/bloc/import_deck_bloc.dart';
import 'presentation/bloc/deck_bloc.dart';
import 'study/data/datasources/study_local_data_source.dart';
import 'study/data/repositories/study_session_repository_impl.dart';
import 'study/domain/repositories/study_session_repository.dart';
import 'study/domain/usecases/study_session_usecases.dart';
import 'study/presentation/bloc/flashcard_bloc.dart';
import 'study/presentation/bloc/quiz_bloc.dart';

/// Central dependency container and factory for the Decks feature module.
abstract class DecksDependencies {
  static final MainDbLoader _mainDbLoader = const MainDbLoader();
  static final DeckDbLoader _deckDbLoader = const DeckDbLoader();

  /// Creates a [DeckRepository] instance.
  static DeckRepository createDeckRepository({
    DeckLocalDataSource? localDataSource,
    ProfileLocalDataSource? profileDataSource,
  }) {
    return DeckRepositoryImpl(
      localDataSource:
          localDataSource ??
          DeckLocalDataSourceImpl(
            mainDbLoader: _mainDbLoader,
            deckDbLoader: _deckDbLoader,
          ),
      profileDataSource:
          profileDataSource ?? SettingsDependencies.profileDataSource,
    );
  }

  /// Creates a [DeckBloc] instance.
  static DeckBloc createDeckBloc({DeckRepository? repository}) {
    final repo = repository ?? createDeckRepository();
    return DeckBloc(
      getDecksUseCase: GetDecksUseCase(repo),
      deleteDecksUseCase: DeleteDecksUseCase(repo),
    );
  }

  /// Creates a [DeckDetailsRepository] instance.
  static DeckDetailsRepository createDeckDetailsRepository({
    DeckDetailsLocalDataSource? localDataSource,
  }) {
    return DeckDetailsRepositoryImpl(
      localDataSource:
          localDataSource ??
          DeckDetailsLocalDataSourceImpl(
            mainDbLoader: _mainDbLoader,
            deckDbLoader: _deckDbLoader,
          ),
    );
  }

  /// Creates a [DeckDetailsBloc] instance.
  static DeckDetailsBloc createDeckDetailsBloc({
    DeckDetailsRepository? repository,
  }) {
    final repo = repository ?? createDeckDetailsRepository();
    return DeckDetailsBloc(getDeckDetailsUseCase: GetDeckDetailsUseCase(repo));
  }

  /// Creates a [DeckProgressCubit] instance for [deckId].
  static DeckProgressCubit createDeckProgressCubit(
    String deckId, {
    DeckDetailsRepository? repository,
  }) {
    final repo = repository ?? createDeckDetailsRepository();
    return DeckProgressCubit(
      deckId,
      getDeckProgressUseCase: GetDeckProgressUseCase(repo),
    );
  }

  /// Creates a [StudySessionRepository] instance.
  static StudySessionRepository createStudySessionRepository({
    StudyLocalDataSource? localDataSource,
  }) {
    return StudySessionRepositoryImpl(
      localDataSource:
          localDataSource ??
          StudyLocalDataSourceImpl(
            mainDbLoader: _mainDbLoader,
            deckDbLoader: _deckDbLoader,
          ),
    );
  }

  /// Creates a [FlashcardBloc] instance.
  static FlashcardBloc createFlashcardBloc({
    StudySessionRepository? repository,
  }) {
    final repo = repository ?? createStudySessionRepository();
    return FlashcardBloc(
      startSessionUseCase: StartStudySessionUseCase(repo),
      recordAnswerUseCase: RecordStudyAnswerUseCase(repo),
      completeSessionUseCase: CompleteStudySessionUseCase(repo),
    );
  }

  /// Creates a [QuizBloc] instance.
  static QuizBloc createQuizBloc({StudySessionRepository? repository}) {
    final repo = repository ?? createStudySessionRepository();
    return QuizBloc(
      startSessionUseCase: StartStudySessionUseCase(repo),
      recordAnswerUseCase: RecordStudyAnswerUseCase(repo),
      completeSessionUseCase: CompleteStudySessionUseCase(repo),
    );
  }

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
      getFilePropertyUseCase: GetEuyFilePropertyUseCase(repo),
      validateUseCase: ValidateEuyFileUseCase(repo),
      importUseCase: ImportEuyDeckUseCase(repo),
    );
  }

  /// Creates a [GenerateDeckRepository] instance.
  static GenerateDeckRepository createGenerateDeckRepository() {
    return GenerateDeckRepositoryImpl();
  }

  /// Creates a [GenerateDeckBloc] instance.
  static GenerateDeckBloc createGenerateDeckBloc({
    GenerateDeckRepository? repository,
  }) {
    final repo = repository ?? createGenerateDeckRepository();
    return GenerateDeckBloc(generateDeckUseCase: GenerateDeckUseCase(repo));
  }

  /// Creates a [DeckHistoryRepository] instance.
  static DeckHistoryRepository createDeckHistoryRepository({
    DeckHistoryLocalDataSource? localDataSource,
  }) {
    return DeckHistoryRepositoryImpl(
      localDataSource:
          localDataSource ??
          DeckHistoryLocalDataSourceImpl(
            mainDbLoader: _mainDbLoader,
            deckDbLoader: _deckDbLoader,
          ),
    );
  }

  /// Creates a [DeckHistoryBloc] instance.
  static DeckHistoryBloc createDeckHistoryBloc({
    DeckHistoryRepository? repository,
    String? initialDeckId,
  }) {
    final repo = repository ?? createDeckHistoryRepository();
    return DeckHistoryBloc(
      getDeckHistoryUseCase: GetDeckHistoryUseCase(repo),
      getSessionCardLogsUseCase: GetSessionCardLogsUseCase(repo),
      initialDeckId: initialDeckId,
    );
  }
}
