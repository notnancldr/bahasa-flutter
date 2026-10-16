import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_home_dashboard_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

/// BLoC orchestrating dashboard metrics and learning activity feeds for Home.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeDashboardUseCase getHomeDashboardUseCase;

  HomeBloc({required this.getHomeDashboardUseCase})
    : super(const HomeInitial()) {
    on<LoadHomeDashboardEvent>(_onLoadDashboard);
    on<RefreshHomeDashboardEvent>(_onRefreshDashboard);
  }

  Future<void> _onLoadDashboard(
    LoadHomeDashboardEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());
    try {
      final dashboard = await getHomeDashboardUseCase();
      emit(HomeLoaded(dashboard));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onRefreshDashboard(
    RefreshHomeDashboardEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final dashboard = await getHomeDashboardUseCase();
      emit(HomeLoaded(dashboard));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
