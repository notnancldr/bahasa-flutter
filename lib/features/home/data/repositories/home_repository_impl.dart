import '../datasources/home_local_data_source.dart';
import '../../domain/repositories/home_repository.dart';
import '../../presentation/bloc/home_dashboard_state.dart';

/// Implementation of [HomeRepository] delegating to [HomeLocalDataSource].
class HomeRepositoryImpl implements HomeRepository {
  final HomeLocalDataSource dataSource;

  const HomeRepositoryImpl({required this.dataSource});

  @override
  Future<HomeDashboardState> getDashboardData() =>
      dataSource.getDashboardData();
}
