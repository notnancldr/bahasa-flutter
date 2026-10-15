import 'package:bahasa/core/widgets/circle_back_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Reusable segmented progress bar for multi-step flows.
class StepProgressBar extends StatelessWidget {
  final int current;
  final int total;
  final double height;
  final double spacing;
  final Color? activeColor;
  final Color? inactiveColor;
  final Duration duration;

  const StepProgressBar({
    super.key,
    required this.current,
    required this.total,
    this.height = 6,
    this.spacing = 8,
    this.activeColor,
    this.inactiveColor,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final active = activeColor ?? c.primary;
    final inactive = inactiveColor ?? c.outline;

    if (total <= 0) return const SizedBox.shrink();

    return Row(
      children: List.generate(2 * total - 1, (index) {
        if ((index + 1) % 2 == 0) {
          return SizedBox(width: spacing);
        }

        final currentBox = (index / 2).toInt();
        final isActive = currentBox <= current;
        final backgroundColor = isActive ? active : inactive;

        return Expanded(
          child: AnimatedContainer(
            key: ValueKey('stepindicator-$currentBox'),
            height: height,
            duration: duration,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        );
      }),
    );
  }
}

/// Reusable navigation header with back button, step title,
/// optional step counter pill badge, and segmented [StepProgressBar].
class StepProgressHeader extends StatelessWidget {
  final int current;
  final int total;
  final String title;
  final String? stepLabel;
  final VoidCallback? onBack;
  final Widget? trailing;

  const StepProgressHeader({
    super.key,
    required this.current,
    required this.total,
    required this.title,
    this.stepLabel,
    this.onBack,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    final t = theme.textTheme;

    final badgeText = stepLabel ?? '${current + 1} / $total';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleBackButton(onPressed: onBack),
                const SizedBox(width: 8),
                Text(title, style: t.labelMedium),
              ],
            ),
            trailing ??
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: c.surfaceContainer,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(badgeText, style: t.labelSmall),
                ),
          ],
        ),
        const SizedBox(height: 12),
        StepProgressBar(current: current, total: total),
      ],
    );
  }
}
