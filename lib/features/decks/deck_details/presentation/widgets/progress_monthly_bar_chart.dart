import 'package:bahasa/core/theme/app_colors.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/deck_progress_data.dart';

/// 12-month vertical bar chart (`J F M A M J J A S O N D`) with dashed
/// horizontal gridlines (`0, 1, 10, 30, 50, 70, 100`).
///
/// Tapping any month bar triggers [onMonthTap] with the 1-indexed month number.
class ProgressMonthlyBarChart extends StatelessWidget {
  /// 12 monthly stat points for the year.
  final List<MonthlyStatPoint> monthlyStats;

  /// Which metric determines bar height.
  final DeckProgressMetricType metricType;

  /// Callback invoked when a month bar (1..12) is tapped.
  final ValueChanged<int> onMonthTap;

  /// Creates a [ProgressMonthlyBarChart].
  const ProgressMonthlyBarChart({
    super.key,
    required this.monthlyStats,
    required this.metricType,
    required this.onMonthTap,
  });

  static const List<String> _monthInitials = [
    'J',
    'F',
    'M',
    'A',
    'M',
    'J',
    'J',
    'A',
    'S',
    'O',
    'N',
    'D',
  ];

  static const List<int> _gridLevels = [100, 70, 50, 30, 10, 1, 0];

  double _resolveNormalizedHeight(MonthlyStatPoint point) {
    final rawValue = metricType == DeckProgressMetricType.accuracy
        ? point.accuracyPercent.toDouble()
        : (point.cardsPracticed > 0
              ? point.cardsPracticed.toDouble().clamp(1.0, 100.0)
              : point.activeMinutes.toDouble().clamp(0.0, 100.0));
    return (rawValue / 100.0).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :c) = WidgetVars.of(context);
    const chartHeight = 220.0;

    return SizedBox(
      height: chartHeight + 32,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Y-axis labels
          SizedBox(
            width: 26,
            height: chartHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _gridLevels.map((lvl) {
                return Text(
                  '$lvl',
                  style: t.labelSmall?.copyWith(
                    fontSize: 9,
                    color: c.onSurfaceVariant,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(width: 6),

          // Chart area + X-axis labels
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: chartHeight,
                  child: Stack(
                    children: [
                      // Dashed horizontal gridlines
                      Positioned.fill(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(_gridLevels.length, (idx) {
                            final isBottom = idx == _gridLevels.length - 1;
                            return CustomPaint(
                              size: const Size(double.infinity, 1),
                              painter: _DashedLinePainter(
                                color: c.outline,
                                isSolid: isBottom,
                              ),
                            );
                          }),
                        ),
                      ),

                      // 12 tappable bars
                      Positioned.fill(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(12, (index) {
                            final point = index < monthlyStats.length
                                ? monthlyStats[index]
                                : MonthlyStatPoint(
                                    month: index + 1,
                                    activeTimeMs: 0,
                                    cardsPracticed: 0,
                                    correctAnswer: 0,
                                    accuracyPercent: 0,
                                  );
                            final ratio = _resolveNormalizedHeight(point);
                            final barHeight = ratio > 0
                                ? (ratio * (chartHeight - 8)).clamp(
                                    12.0,
                                    chartHeight,
                                  )
                                : 6.0;

                            return Expanded(
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => onMonthTap(index + 1),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 220),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 3,
                                    ),
                                    height: barHeight,
                                    decoration: BoxDecoration(
                                      color: ratio > 0
                                          ? AppColors.success
                                          : c.outline.withValues(alpha: 0.35),
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(4),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(12, (index) {
                    return Expanded(
                      child: Text(
                        _monthInitials[index],
                        textAlign: TextAlign.center,
                        style: t.labelSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 10,
                          color: c.onSurface,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  final bool isSolid;

  const _DashedLinePainter({required this.color, required this.isSolid});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    if (isSolid) {
      canvas.drawLine(Offset.zero, Offset(size.width, 0), paint);
      return;
    }

    const dashWidth = 4.0;
    const dashSpace = 3.0;
    var startX = 0.0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset((startX + dashWidth).clamp(0.0, size.width), 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.isSolid != isSolid;
  }
}
