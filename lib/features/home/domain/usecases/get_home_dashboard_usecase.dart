import '../../presentation/bloc/home_dashboard_state.dart';
import '../repositories/home_repository.dart';

/// Use case that orchestrates retrieval of the Home dashboard state.
class GetHomeDashboardUseCase {
  final HomeRepository repository;

  const GetHomeDashboardUseCase(this.repository);

  Future<HomeDashboardState> call() => repository.getDashboardData();
}
