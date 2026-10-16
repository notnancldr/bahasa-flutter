import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/flame_icon.dart';
import 'package:bahasa/core/widgets/streak_icon.dart';
import 'package:flutter/material.dart';

/// Activity summary row on the Deck Details page displaying tappable
/// per-deck Streak and Accuracy metrics separated by a vertical divider.
class DeckActivitySummaryRow extends StatelessWidget {
  /// Consecutive study days streak for this deck.
  final int streakCount;

  /// Accuracy percentage (0..100) for this deck.
  final int accuracyPercent;

  /// Callback invoked when the Streak metric is tapped.
  final VoidCallback onTapStreak;

  /// Callback invoked when the Accuracy metric is tapped.
  final VoidCallback onTapAccuracy;

  /// Creates a [DeckActivitySummaryRow].
  const DeckActivitySummaryRow({
    super.key,
    required this.streakCount,
    required this.accuracyPercent,
    required this.onTapStreak,
    required this.onTapAccuracy,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :l) = WidgetVars.of(context);

    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: _MetricSummaryButton(
              icon: FlameIcon(streakCount: streakCount, size: 42),
              valueText: '$streakCount',
              unitText: 'x',
              label: l.deck_details_streak_label,
              onPressed: onTapStreak,
            ),
          ),
          VerticalDivider(
            width: 24,
            thickness: 1.2,
            indent: 6,
            endIndent: 6,
            color: c.outline,
          ),
          Expanded(
            child: _MetricSummaryButton(
              icon: const AccuracyIcon(size: 40),
              valueText: '$accuracyPercent',
              unitText: '%',
              label: l.deck_details_accuracy_label,
              onPressed: onTapAccuracy,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricSummaryButton extends StatelessWidget {
  final Widget icon;
  final String valueText;
  final String unitText;
  final String label;
  final VoidCallback onPressed;

  const _MetricSummaryButton({
    required this.icon,
    required this.valueText,
    required this.unitText,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :c) = WidgetVars.of(context);

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: c.onSurface,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 14),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: valueText,
                        style: t.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          fontSize: 28,
                          height: 1.0,
                          color: c.onSurface,
                        ),
                      ),
                      TextSpan(
                        text: unitText,
                        style: t.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: c.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: t.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: c.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
