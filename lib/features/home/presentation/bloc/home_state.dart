import 'package:flutter/foundation.dart';

import 'home_dashboard_state.dart';

@immutable
sealed class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final HomeDashboardState dashboard;

  const HomeLoaded(this.dashboard);
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);
}
