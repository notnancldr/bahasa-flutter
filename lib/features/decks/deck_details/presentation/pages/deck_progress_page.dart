import 'package:bahasa/core/router/app_routes.dart';
import 'package:bahasa/core/theme/app_colors.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/circle_back_button.dart';
import 'package:bahasa/features/decks/decks_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../domain/entities/deck_progress_data.dart';
import '../bloc/deck_progress_cubit.dart';
import '../bloc/deck_progress_state.dart';
import '../widgets/period_detail_bottom_sheet.dart';
import '../widgets/progress_calendar_heatmap.dart';
import '../widgets/progress_hero_header.dart';
import '../widgets/progress_monthly_bar_chart.dart';
import '../widgets/progress_period_toggle.dart';
import '../widgets/weekly_streaks_card.dart';

/// Page displaying per-deck progress for either Active Time (Streak) or Accuracy.
///
/// Features a hero metric header, Weekly Streaks card, `Bulan`/`Tahun` view toggle,
/// monthly bar chart, calendar heatmap, and tappable Period Detail bottom sheet
/// with the Top 3 Weakest Cards.
class DeckProgressPage extends StatelessWidget {
  /// Target deck identifier.
  final String deckId;

  /// Metric type (`streak` for Active Time page, `accuracy` for Accuracy page).
  final DeckProgressMetricType metricType;

  /// Optional [DeckProgressCubit] override for testing.
  final DeckProgressCubit? cubit;

  /// Creates a [DeckProgressPage].
  const DeckProgressPage({
    super.key,
    required this.deckId,
    required this.metricType,
    this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DeckProgressCubit>(
      create: (_) =>
          (cubit ?? DecksDependencies.createDeckProgressCubit(deckId))
            ..loadProgress(),
      child: _DeckProgressView(deckId: deckId, metricType: metricType),
    );
  }
}

class _DeckProgressView extends StatelessWidget {
  final String deckId;
  final DeckProgressMetricType metricType;

  const _DeckProgressView({required this.deckId, required this.metricType});

  Future<void> _openDaySheet(BuildContext context, DateTime day) async {
    final detail = await context.read<DeckProgressCubit>().selectDay(day);
    if (detail != null && context.mounted) {
      await PeriodDetailBottomSheet.show(context, detail);
    }
  }

  Future<void> _openMonthSheet(BuildContext context, int month) async {
    final detail = await context.read<DeckProgressCubit>().selectMonth(month);
    if (detail != null && context.mounted) {
      await PeriodDetailBottomSheet.show(context, detail);
    }
  }

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :c, :l) = WidgetVars.of(context);
    final pageTitle = metricType == DeckProgressMetricType.streak
        ? l.deck_progress_streak_title
        : l.deck_progress_accuracy_title;

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<DeckProgressCubit, DeckProgressState>(
          builder: (context, state) {
            return switch (state) {
              DeckProgressLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              DeckProgressError(:final message) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(message, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () =>
                            context.read<DeckProgressCubit>().loadProgress(),
                        child: Text(l.tryAgain),
                      ),
                    ],
                  ),
                ),
              ),
              DeckProgressLoaded(:final progress, :final activeTab) =>
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Top Bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CircleBackButton(),
                          Text(
                            pageTitle,
                            style: t.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                              color: c.onSurface,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              context.push(AppRoutes.deckHistoryPath(deckId));
                            },
                            tooltip: l.deck_details_history_tooltip,
                            style: IconButton.styleFrom(
                              minimumSize: const Size(42, 42),
                              side: const BorderSide(
                                color: AppColors.primary,
                                width: 1.4,
                              ),
                              shape: const CircleBorder(),
                            ),
                            icon: const Icon(
                              Symbols.history,
                              size: 20,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Hero Metric Header
                      Center(
                        child: ProgressHeroHeader(
                          metricType: metricType,
                          progress: progress,
                        ),
                      ),
                      const SizedBox(height: 22),

                      // Weekly Streaks Card
                      WeeklyStreaksCard(
                        weeklyActiveDays: progress.weeklyActiveDays,
                      ),
                      const SizedBox(height: 18),

                      // Bulan / Tahun Segmented Toggle
                      ProgressPeriodToggle(
                        activeTab: activeTab,
                        onTabSelected: (tab) =>
                            context.read<DeckProgressCubit>().selectTab(tab),
                      ),
                      const SizedBox(height: 20),

                      // Active Period Chart / Calendar View
                      if (activeTab == DeckProgressPeriodTab.month)
                        ProgressMonthlyBarChart(
                          monthlyStats: progress.monthlyStats,
                          metricType: metricType,
                          onMonthTap: (m) => _openMonthSheet(context, m),
                        )
                      else
                        ProgressCalendarHeatmap(
                          referenceDate: progress.referenceDate,
                          dailyStatsByDateKey: progress.dailyStatsByDateKey,
                          metricType: metricType,
                          onDayTap: (d) => _openDaySheet(context, d),
                        ),
                    ],
                  ),
                ),
            };
          },
        ),
      ),
    );
  }
}
