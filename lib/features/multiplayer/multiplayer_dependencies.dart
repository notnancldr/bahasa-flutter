import 'data/datasources/multiplayer_client.dart';
import 'data/datasources/multiplayer_local_data_source.dart';
import 'data/datasources/multiplayer_server.dart';
import 'data/repositories/multiplayer_repository_impl.dart';
import 'domain/repositories/multiplayer_repository.dart';
import 'presentation/bloc/multiplayer_bloc.dart';

/// Service locator and dependency provider for the multiplayer feature.
class MultiplayerDependencies {
  static MultiplayerRepository? _repository;

  /// Returns singleton instance of [MultiplayerRepository].
  static MultiplayerRepository getRepository({
    MultiplayerServer? server,
    MultiplayerClient? client,
    MultiplayerLocalDataSource? localDataSource,
  }) {
    return _repository ??= MultiplayerRepositoryImpl(
      server: server,
      client: client,
      localDataSource: localDataSource,
    );
  }

  /// Factory creating a new [MultiplayerBloc] wired to the repository.
  static MultiplayerBloc createMultiplayerBloc({
    MultiplayerRepository? repository,
  }) {
    return MultiplayerBloc(repository: repository ?? getRepository());
  }

  /// Resets cached repository for testing.
  static void reset() {
    _repository?.stopServer();
    _repository = null;
  }
}
