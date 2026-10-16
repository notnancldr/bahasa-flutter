import 'package:flutter/foundation.dart';

@immutable
sealed class HomeEvent {
  const HomeEvent();
}

/// Dispatched to load the home dashboard data from database.
class LoadHomeDashboardEvent extends HomeEvent {
  const LoadHomeDashboardEvent();
}

/// Dispatched to refresh the home dashboard data.
class RefreshHomeDashboardEvent extends HomeEvent {
  const RefreshHomeDashboardEvent();
}
