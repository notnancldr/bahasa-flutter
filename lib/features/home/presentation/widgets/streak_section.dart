import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/features/home/presentation/widgets/flame_icon.dart';
import 'package:flutter/material.dart';

/// Displays the user's current streak with the flame icon, counter number,
/// and consecutive days label.
class StreakSection extends StatelessWidget {
  /// Number of consecutive days the user has maintained their study streak.
  final int streakCount;

  /// Optional tap callback to open streak history per PRD (FR-2.2).
  final VoidCallback? onTap;

  const StreakSection({super.key, required this.streakCount, this.onTap});

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :c, :l) = WidgetVars.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Opacity(
          opacity: streakCount > 0 ? 1 : 0.3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FlameIcon(streakCount: streakCount, size: 140),
              const SizedBox(height: 16),
              Text(
                '$streakCount',
                style: t.displayLarge?.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: c.onSurface,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l.home_consecutiveDays,
                style: t.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF7D8A8F),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
