import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';

import '../../data/datasources/deck_details_local_data_source.dart';
import '../../domain/entities/deck_progress_data.dart';

/// Monthly calendar heatmap grid (`Minggu`..`Sabtu`) shading each day cell
/// according to its active study time (streak) or accuracy rate opacity.
class ProgressCalendarHeatmap extends StatelessWidget {
  /// Reference month/date to display.
  final DateTime referenceDate;

  /// Map of `YYYY-MM-DD` date strings to their [DailyStatSummary].
  final Map<String, DailyStatSummary> dailyStatsByDateKey;

  /// Which metric determines cell shading intensity.
  final DeckProgressMetricType metricType;

  /// Callback invoked when a date cell is tapped.
  final ValueChanged<DateTime> onDayTap;

  /// Creates a [ProgressCalendarHeatmap].
  const ProgressCalendarHeatmap({
    super.key,
    required this.referenceDate,
    required this.dailyStatsByDateKey,
    required this.metricType,
    required this.onDayTap,
  });

  static const Color _baseThemeColor = Color(0xFF2C6378);

  Color? _resolveCellFill(DailyStatSummary? stat) {
    if (stat == null) return null;

    final hasActivity = stat.cardsPracticed > 0 || stat.activeTimeMs > 0;
    if (!hasActivity) return null;

    if (metricType == DeckProgressMetricType.accuracy) {
      // Accuracy: Opacity is directly driven by accuracy percentage (0% to 100%)
      final acc = stat.cardsPracticed > 0
          ? stat.accuracyRate.clamp(0.0, 100.0)
          : 0.0;
      final opacity = (acc / 100.0).clamp(0.20, 1.0);
      return _baseThemeColor.withValues(alpha: opacity);
    } else {
      // Streak / Active Time: Opacity is directly driven by how long active that day (activeTimeMs)
      // 5 minutes (300,000 ms) = 100% full opacity
      final durationMs = stat.activeTimeMs > 0
          ? stat.activeTimeMs
          : (stat.cardsPracticed * 12000);
      final opacity = (durationMs / 300000.0).clamp(0.20, 1.0);
      return _baseThemeColor.withValues(alpha: opacity);
    }
  }

  List<DateTime> _buildCalendarCells(DateTime monthDate) {
    final firstOfMonth = DateTime(monthDate.year, monthDate.month, 1);
    // Sunday = 0 .. Saturday = 6
    final leadingDays = firstOfMonth.weekday % 7;
    final startCell = firstOfMonth.subtract(Duration(days: leadingDays));
    return List<DateTime>.generate(
      42,
      (index) =>
          DateTime(startCell.year, startCell.month, startCell.day + index),
    );
  }

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :c, :l) = WidgetVars.of(context);
    final cells = _buildCalendarCells(referenceDate);
    final headers = [
      l.deck_progress_day_sun,
      l.deck_progress_day_mon,
      l.deck_progress_day_tue,
      l.deck_progress_day_wed,
      l.deck_progress_day_thu,
      l.deck_progress_day_fri,
      l.deck_progress_day_sat,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Day of week headers
        Row(
          children: headers.map((label) {
            return Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: t.labelSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                  color: c.onSurface,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),

        // 6x7 calendar grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cells.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
            final cellDate = cells[index];
            final isCurrentMonth = cellDate.month == referenceDate.month;
            final key = DeckDetailsLocalDataSourceImpl.formatDateKey(cellDate);
            final stat = dailyStatsByDateKey[key];
            final fillColor = isCurrentMonth ? _resolveCellFill(stat) : null;

            final isHighOpacity = fillColor != null && (fillColor.a > 0.55);
            final textColor = fillColor != null
                ? (isHighOpacity ? Colors.white : _baseThemeColor)
                : (isCurrentMonth
                      ? c.onSurface
                      : c.onSurfaceVariant.withValues(alpha: 0.35));

            return OutlinedButton(
              onPressed: () => onDayTap(cellDate),
              style: OutlinedButton.styleFrom(
                backgroundColor: fillColor ?? Colors.transparent,
                padding: const EdgeInsets.all(5),
                side: BorderSide(
                  color: fillColor != null
                      ? fillColor.withValues(alpha: 1.0)
                      : isCurrentMonth
                      ? c.onSurfaceVariant.withValues(alpha: 0.65)
                      : c.outline.withValues(alpha: 0.45),
                  width: 1.1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Align(
                alignment: Alignment.topRight,
                child: Text(
                  '${cellDate.day}',
                  style: t.labelSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                    color: textColor,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),

        // Heatmap opacity intensity legend at bottom-right
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [0.20, 0.40, 0.60, 0.80, 1.0].map((opacity) {
            return Container(
              width: 11,
              height: 11,
              margin: const EdgeInsets.only(left: 4),
              decoration: BoxDecoration(
                color: _baseThemeColor.withValues(alpha: opacity),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
