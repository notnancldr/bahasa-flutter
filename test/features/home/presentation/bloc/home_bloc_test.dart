import 'package:bahasa/features/home/domain/repositories/home_repository.dart';
import 'package:bahasa/features/home/domain/usecases/get_home_dashboard_usecase.dart';
import 'package:bahasa/features/home/presentation/bloc/home_bloc.dart';
import 'package:bahasa/features/home/presentation/bloc/home_dashboard_state.dart';
import 'package:bahasa/features/home/presentation/bloc/home_event.dart';
import 'package:bahasa/features/home/presentation/bloc/home_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeHomeRepository implements HomeRepository {
  final bool shouldFail;
  final HomeDashboardState? result;

  _FakeHomeRepository({this.shouldFail = false, this.result});

  @override
  Future<HomeDashboardState> getDashboardData() async {
    if (shouldFail) {
      throw Exception('Database query error');
    }
    return result ??
        const HomeDashboardState(
          streakCount: 3,
          hasDecks: true,
          recommendation: null,
          recentActivities: [],
        );
  }
}

void main() {
  group('HomeBloc', () {
    test('initial state is HomeInitial', () {
      final bloc = HomeBloc(
        getHomeDashboardUseCase: GetHomeDashboardUseCase(_FakeHomeRepository()),
      );
      expect(bloc.state, isA<HomeInitial>());
    });

    test(
      'LoadHomeDashboardEvent emits HomeLoading then HomeLoaded on success',
      () async {
        final bloc = HomeBloc(
          getHomeDashboardUseCase: GetHomeDashboardUseCase(
            _FakeHomeRepository(
              result: const HomeDashboardState(
                streakCount: 5,
                hasDecks: true,
                recommendation: null,
                recentActivities: [],
              ),
            ),
          ),
        );

        bloc.add(const LoadHomeDashboardEvent());
        await Future<void>.delayed(Duration.zero);

        expect(bloc.state, isA<HomeLoaded>());
        final loaded = bloc.state as HomeLoaded;
        expect(loaded.dashboard.streakCount, equals(5));
        expect(loaded.dashboard.hasDecks, isTrue);
      },
    );

    test(
      'LoadHomeDashboardEvent emits HomeLoading then HomeError on failure',
      () async {
        final bloc = HomeBloc(
          getHomeDashboardUseCase: GetHomeDashboardUseCase(
            _FakeHomeRepository(shouldFail: true),
          ),
        );

        bloc.add(const LoadHomeDashboardEvent());
        await Future<void>.delayed(Duration.zero);

        expect(bloc.state, isA<HomeError>());
        final error = bloc.state as HomeError;
        expect(error.message, contains('Database query error'));
      },
    );
  });
}
