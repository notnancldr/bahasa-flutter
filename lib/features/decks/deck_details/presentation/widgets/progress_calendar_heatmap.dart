import 'package:bahasa/core/theme/app_colors.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';

import '../../data/datasources/deck_details_local_data_source.dart';
import '../../domain/entities/deck_progress_data.dart';

/// Monthly calendar heatmap grid (`Minggu`..`Sabtu`) shading each day cell
/// according to its study activity / accuracy and opening the Period Detail
/// bottom sheet when tapped.
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

  static const List<Color> _heatmapPalette = [
    Color(0xFFD6EEF6),
    Color(0xFFAEDCEB),
    Color(0xFF8CCBDF),
    Color(0xFF69B9D4),
    Color(0xFF47A7C8),
  ];

  Color? _resolveCellFill(DailyStatSummary? stat) {
    if (stat == null || (stat.cardsPracticed <= 0 && stat.activeTimeMs <= 0)) {
      return null;
    }

    if (metricType == DeckProgressMetricType.accuracy) {
      final acc = stat.accuracyRate.clamp(0.0, 100.0);
      final bucket = ((acc / 100.0) * (_heatmapPalette.length - 1))
          .round()
          .clamp(0, _heatmapPalette.length - 1);
      return _heatmapPalette[bucket];
    }

    final practiced = stat.cardsPracticed;
    final bucket = (practiced ~/ 5).clamp(0, _heatmapPalette.length - 1);
    return _heatmapPalette[bucket];
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

            return OutlinedButton(
              onPressed: () => onDayTap(cellDate),
              style: OutlinedButton.styleFrom(
                backgroundColor: fillColor ?? Colors.transparent,
                padding: const EdgeInsets.all(5),
                side: BorderSide(
                  color: fillColor != null
                      ? AppColors.primaryDark
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
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                    color: isCurrentMonth
                        ? (fillColor != null
                              ? AppColors.primaryDark
                              : c.onSurface)
                        : c.onSurfaceVariant.withValues(alpha: 0.4),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),

        // Heatmap intensity legend at bottom-right
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: _heatmapPalette.map((swatch) {
            return Container(
              width: 11,
              height: 11,
              margin: const EdgeInsets.only(left: 4),
              decoration: BoxDecoration(
                color: swatch,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
