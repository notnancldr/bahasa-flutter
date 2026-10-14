import '../../presentation/bloc/home_dashboard_state.dart';

/// Repository interface supplying dashboard analytics and learning metrics for the Home screen.
abstract class HomeRepository {
  /// Fetches the aggregated dashboard state from local SQLite databases.
  Future<HomeDashboardState> getDashboardData();
}
