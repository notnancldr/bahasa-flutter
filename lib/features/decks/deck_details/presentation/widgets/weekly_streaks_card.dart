import 'package:bahasa/core/theme/app_colors.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/flame_icon.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Card displaying the user's Mon–Sun weekly streak flames with an amber
/// footer note indicating the weekly reset.
class WeeklyStreaksCard extends StatelessWidget {
  /// List of 7 booleans representing Monday (index 0) through Sunday (index 6).
  final List<bool> weeklyActiveDays;

  /// Creates a [WeeklyStreaksCard].
  const WeeklyStreaksCard({super.key, required this.weeklyActiveDays});

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :c, :l) = WidgetVars.of(context);
    final dayLabels = [
      l.deck_progress_day_mon_short,
      l.deck_progress_day_tue_short,
      l.deck_progress_day_wed_short,
      l.deck_progress_day_thu_short,
      l.deck_progress_day_fri_short,
      l.deck_progress_day_sat_short,
      l.deck_progress_day_sun_short,
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9C57A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFBE0B4), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l.deck_progress_weekly_streaks_title,
                      style: t.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                        color: c.onSurface,
                      ),
                    ),
                    Icon(
                      Symbols.arrow_forward,
                      size: 20,
                      color: c.onSurfaceVariant,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(7, (index) {
                    final isActive =
                        index < weeklyActiveDays.length &&
                        weeklyActiveDays[index];
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          dayLabels[index],
                          style: t.labelSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                            color: c.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        FlameIcon(
                          streakCount: isActive ? 1 : 0,
                          size: isActive ? 30 : 24,
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
            child: Text(
              l.deck_progress_weekly_restarts_note,
              style: t.labelSmall?.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.secodaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
