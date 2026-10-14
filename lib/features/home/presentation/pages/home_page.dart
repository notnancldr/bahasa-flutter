import 'package:bahasa/core/router/app_routes.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/features/home/presentation/bloc/home_dashboard_state.dart';
import 'package:bahasa/features/home/presentation/widgets/home_empty_state.dart';
import 'package:bahasa/features/home/presentation/widgets/home_notification_button.dart';
import 'package:bahasa/features/home/presentation/widgets/recent_activity_tile.dart';
import 'package:bahasa/features/home/presentation/widgets/review_recommendation_card.dart';
import 'package:bahasa/features/home/presentation/widgets/streak_section.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The primary landing screen of the Bahasa app.
///
/// Presents the current study streak (flame + count), review recommendations
/// for least/most active decks, recent activity list, or an empty state when
/// no decks have been registered.
class HomePage extends StatelessWidget {
  /// Optional dashboard state override (e.g. for testing or empty state previews).
  final HomeDashboardState? state;

  const HomePage({super.key, this.state});

  @override
  Widget build(BuildContext context) {
    final dashboard = state ?? HomeDashboardState.initial(hasDecks: true);
    final WidgetVars(:t, :c, :l) = WidgetVars.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Bar with Notification Bell
              HomeNotificationButton(
                onPressed: () {
                  // In the future, this can navigate to notification center
                },
              ),
              const SizedBox(height: 12),

              // Streak Section (Flame, Counter, Label)
              Center(
                child: StreakSection(
                  streakCount: dashboard.streakCount,
                  onTap: () {
                    // Navigate to history or streak breakdown if available
                  },
                ),
              ),

              if (!dashboard.hasDecks) ...[
                const SizedBox(height: 40),
                HomeEmptyState(
                  onCreateDeck: () {
                    context.go(AppRoutes.deck);
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
                    onReview: () {
                      context.go(AppRoutes.deck);
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
                        onTap: () {
                          context.go(AppRoutes.deck);
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
