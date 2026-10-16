import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/deck_history_period.dart';
import '../../domain/entities/deck_history_summary.dart';

/// Summary card displaying "Ringkasan [Minggu/Bulan/Tahun] ini" with 3 key metrics:
/// Total Aktivitas, Waktu Belajar, and Rata-Rata Akurasi.
class DeckHistorySummaryCard extends StatelessWidget {
  /// Active period filter.
  final DeckHistoryPeriod period;

  /// Summary statistics data.
  final DeckHistorySummary summary;

  /// Creates a [DeckHistorySummaryCard].
  const DeckHistorySummaryCard({
    super.key,
    required this.period,
    required this.summary,
  });

  String _formatDuration(BuildContext context, int durationMs) {
    final hours = durationMs ~/ 3600000;
    final minutes = (durationMs % 3600000) ~/ 60000;
    final seconds = (durationMs % 60000) ~/ 1000;

    final isIndonesian =
        Localizations.localeOf(context).languageCode.toLowerCase() == 'id';

    if (hours > 0) {
      final hUnit = isIndonesian ? 'j' : 'h';
      return '$hours$hUnit ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m';
    } else {
      final sUnit = isIndonesian ? 'd' : 's';
      return '$seconds$sUnit';
    }
  }

  String _getSummaryHeading(BuildContext context) {
    final l = WidgetVars.of(context).l;
    switch (period) {
      case DeckHistoryPeriod.week:
        return l.deck_history_summary_week;
      case DeckHistoryPeriod.month:
        return l.deck_history_summary_month;
      case DeckHistoryPeriod.year:
        return l.deck_history_summary_year;
    }
  }

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :c, :l) = WidgetVars.of(context);

    final sessionsUnit = l.deck_history_sessions_count(summary.totalActivities);
    final durationFormatted = _formatDuration(context, summary.totalDurationMs);
    final accuracyFormatted = '${summary.averageAccuracy}%';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Section title
        Text(
          _getSummaryHeading(context),
          style: t.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: c.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 10),

        // Top subtle divider
        Divider(color: c.outlineVariant.withValues(alpha: 0.6), height: 1),
        const SizedBox(height: 14),

        // 3 stats row with vertical dividers
        Row(
          children: [
            // 1. Total Aktivitas
            Expanded(
              child: _MetricItem(
                value: sessionsUnit,
                caption: l.deck_history_total_activities,
              ),
            ),

            Container(
              height: 38,
              width: 1,
              color: c.outlineVariant.withValues(alpha: 0.7),
            ),

            // 2. Waktu Belajar
            Expanded(
              child: _MetricItem(
                value: durationFormatted,
                caption: l.deck_history_study_time,
              ),
            ),

            Container(
              height: 38,
              width: 1,
              color: c.outlineVariant.withValues(alpha: 0.7),
            ),

            // 3. Rata-Rata Akurasi
            Expanded(
              child: _MetricItem(
                value: accuracyFormatted,
                caption: l.deck_history_avg_accuracy,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Bottom subtle divider
        Divider(color: c.outlineVariant.withValues(alpha: 0.6), height: 1),
      ],
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String value;
  final String caption;

  const _MetricItem({required this.value, required this.caption});

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :c) = WidgetVars.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          textAlign: TextAlign.center,
          style: t.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: c.onSurface,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          caption,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: t.bodySmall?.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: c.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
