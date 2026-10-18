import 'package:bahasa/core/router/app_router.dart';
import 'package:bahasa/core/router/app_routes.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/basa_app_logo.dart';
import 'package:bahasa/features/decks/presentation/widgets/add_deck_method_modal.dart';
import 'package:bahasa/features/home/home_dependencies.dart';
import 'package:bahasa/features/home/presentation/bloc/home_bloc.dart';
import 'package:bahasa/features/home/presentation/bloc/home_dashboard_state.dart';
import 'package:bahasa/features/home/presentation/bloc/home_event.dart';
import 'package:bahasa/features/home/presentation/bloc/home_state.dart';
import 'package:bahasa/features/home/presentation/widgets/home_empty_state.dart';
import 'package:bahasa/features/home/presentation/widgets/recent_activity_tile.dart';
import 'package:bahasa/features/home/presentation/widgets/review_recommendation_card.dart';
import 'package:bahasa/features/home/presentation/widgets/streak_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// The primary landing screen of the Bahasa app displaying live database metrics.
class HomePage extends StatelessWidget {
  /// Optional dashboard state override (e.g. for testing or previews).
  final HomeDashboardState? state;

  /// Optional bloc override for testing.
  final HomeBloc? bloc;

  const HomePage({super.key, this.state, this.bloc});

  @override
  Widget build(BuildContext context) {
    if (state != null) {
      return Scaffold(
        body: SafeArea(child: _HomeDashboardView(dashboard: state!)),
      );
    }

    return BlocProvider(
      create: (_) =>
          (bloc ?? HomeDependencies.createHomeBloc())
            ..add(const LoadHomeDashboardEvent()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> with RouteAware {
  int? _lastBranchIndex;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      AppRouter.routeObserver.subscribe(this, route);
    }

    final shell = StatefulNavigationShell.maybeOf(context);
    if (shell != null) {
      final currentBranch = shell.currentIndex;
      if (_lastBranchIndex != null &&
          _lastBranchIndex != currentBranch &&
          currentBranch == 0) {
        context.read<HomeBloc?>()?.add(const RefreshHomeDashboardEvent());
      }
      _lastBranchIndex = currentBranch;
    }
  }

  @override
  void dispose() {
    AppRouter.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    context.read<HomeBloc?>()?.add(const RefreshHomeDashboardEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return switch (state) {
              HomeInitial() ||
              HomeLoading() => const Center(child: CircularProgressIndicator()),
              HomeLoaded(:final dashboard) => RefreshIndicator(
                onRefresh: () async {
                  context.read<HomeBloc>().add(
                    const RefreshHomeDashboardEvent(),
                  );
                },
                child: _HomeDashboardView(dashboard: dashboard),
              ),
              HomeError(:final message) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(message, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () => context.read<HomeBloc>().add(
                          const LoadHomeDashboardEvent(),
                        ),
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              ),
            };
          },
        ),
      ),
    );
  }
}

class _HomeDashboardView extends StatelessWidget {
  final HomeDashboardState dashboard;

  const _HomeDashboardView({required this.dashboard});

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :c, :l) = WidgetVars.of(context);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // App Logo Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const BasaAppLogo(size: 26, borderRadius: 8),
              const SizedBox(width: 8),
              Text(
                'BASA',
                style: t.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  letterSpacing: 1.2,
                  color: c.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Streak Section (Flame, Counter, Label)
          Center(
            child: StreakSection(
              streakCount: dashboard.streakCount,
              onTap: () {
                context.push(AppRoutes.deckHistory);
              },
            ),
          ),

          if (!dashboard.hasDecks) ...[
            const SizedBox(height: 40),
            HomeEmptyState(
              onCreateDeck: () {
                AddDeckMethodModal.show(
                  context,
                  onSelectGenerate: () {
                    context.push(AppRoutes.deckGenerate);
                  },
                  onSelectImport: () {
                    context.push(AppRoutes.deckImport);
                  },
                );
              },
            ),
            const SizedBox(height: 48),
          ] else ...[
            const SizedBox(height: 28),

            // Review Recommendation Card (e.g. Least Active Deck)
            if (dashboard.recommendation != null) ...[
              ReviewRecommendationCard(
                tag: dashboard.recommendation!.tag,
                title: dashboard.recommendation!.title,
                subtitle: dashboard.recommendation!.subtitle,
                onReview: () async {
                  final homeBloc = context.read<HomeBloc?>();
                  await context.push(
                    AppRoutes.deckDetailsPath(dashboard.recommendation!.id),
                  );
                  homeBloc?.add(const RefreshHomeDashboardEvent());
                },
              ),
              const SizedBox(height: 28),
            ],

            // Recent Activities Section
            if (dashboard.recentActivities.isNotEmpty) ...[
              Text(
                l.home_recentActivityTitle,
                style: t.titleMedium?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: c.onSurface,
                ),
              ),
              const SizedBox(height: 14),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dashboard.recentActivities.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = dashboard.recentActivities[index];
                  return RecentActivityTile(
                    title: item.title,
                    subtitle: item.formatSubtitle(l),
                    icon: item.icon,
                    color: item.color,
                    onTap: () async {
                      final homeBloc = context.read<HomeBloc?>();
                      await context.push(AppRoutes.deckDetailsPath(item.id));
                      homeBloc?.add(const RefreshHomeDashboardEvent());
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ],
        ],
      ),
    );
  }
}
