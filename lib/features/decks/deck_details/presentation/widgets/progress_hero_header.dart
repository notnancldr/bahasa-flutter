import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/flame_icon.dart';
import 'package:bahasa/core/widgets/streak_icon.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/deck_progress_data.dart';

/// Hero metric section at the top of the Deck Progress page.
///
/// Renders either the Streak / Active Time overview or the Accuracy overview
/// depending on [metricType].
class ProgressHeroHeader extends StatelessWidget {
  /// Which metric this page emphasizes.
  final DeckProgressMetricType metricType;

  /// Loaded progress data for the deck.
  final DeckProgressData progress;

  /// Creates a [ProgressHeroHeader].
  const ProgressHeroHeader({
    super.key,
    required this.metricType,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :c, :l) = WidgetVars.of(context);

    if (metricType == DeckProgressMetricType.streak) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FlameIcon(streakCount: progress.streakCount, size: 132),
          const SizedBox(height: 12),
          Text(
            '${progress.streakCount}',
            style: t.displaySmall?.copyWith(
              fontWeight: FontWeight.w900,
              fontSize: 34,
              color: c.onSurface,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l.deck_progress_streaks_label,
            style: t.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 22,
              color: c.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l.deck_progress_active_comparison_vs_last_month(
              progress.thisMonthActiveMinutes,
              progress.lastMonthActiveMinutes,
            ),
            style: t.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: c.onSurfaceVariant,
            ),
          ),
        ],
      );
    }

    final diff =
        progress.thisMonthAccuracyPercent - progress.lastMonthAccuracyPercent;
    final diffStr = diff >= 0 ? '+$diff' : '$diff';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const AccuracyIcon(size: 108),
        const SizedBox(height: 14),
        Text(
          '${progress.thisMonthAccuracyPercent}%',
          style: t.displaySmall?.copyWith(
            fontWeight: FontWeight.w900,
            fontSize: 34,
            color: c.onSurface,
            height: 1.05,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l.deck_progress_accuracy_subtitle,
          style: t.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: c.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l.deck_progress_comparison_vs_last_month(
            diffStr,
            progress.lastMonthAccuracyPercent,
          ),
          style: t.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: c.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
