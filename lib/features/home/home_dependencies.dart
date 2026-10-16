import 'package:bahasa/core/utils/deck_db_loader.dart';
import 'package:bahasa/core/utils/main_db_loader.dart';

import 'data/datasources/home_local_data_source.dart';
import 'data/repositories/home_repository_impl.dart';
import 'domain/repositories/home_repository.dart';
import 'domain/usecases/get_home_dashboard_usecase.dart';
import 'presentation/bloc/home_bloc.dart';

/// Central dependency container and factory for the Home feature module.
abstract class HomeDependencies {
  static final MainDbLoader _mainDbLoader = const MainDbLoader();
  static final DeckDbLoader _deckDbLoader = const DeckDbLoader();

  /// Creates a [HomeLocalDataSource] instance.
  static HomeLocalDataSource createHomeLocalDataSource() {
    return HomeLocalDataSourceImpl(
      mainDbLoader: _mainDbLoader,
      deckDbLoader: _deckDbLoader,
    );
  }

  /// Creates a [HomeRepository] instance.
  static HomeRepository createHomeRepository({
    HomeLocalDataSource? dataSource,
  }) {
    return HomeRepositoryImpl(
      dataSource: dataSource ?? createHomeLocalDataSource(),
    );
  }

  /// Creates a [HomeBloc] instance.
  static HomeBloc createHomeBloc({HomeRepository? repository}) {
    final repo = repository ?? createHomeRepository();
    return HomeBloc(getHomeDashboardUseCase: GetHomeDashboardUseCase(repo));
  }
}
