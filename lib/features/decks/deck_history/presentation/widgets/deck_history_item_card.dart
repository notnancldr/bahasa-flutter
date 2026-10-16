import 'package:bahasa/core/theme/app_colors.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../domain/entities/deck_history_item.dart';

/// Single study activity session card matching `deck_history_currentWeek.png`.
class DeckHistoryItemCard extends StatelessWidget {
  /// Study session item data.
  final DeckHistoryItem item;

  /// Callback when user taps the card to inspect details.
  final VoidCallback onTap;

  /// Creates a [DeckHistoryItemCard].
  const DeckHistoryItemCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  String _formatDateTime(BuildContext context, DateTime dateTime) {
    final WidgetVars(:l) = WidgetVars.of(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sessionDay = DateTime(dateTime.year, dateTime.month, dateTime.day);

    final timeStr = DateFormat('HH:mm').format(dateTime);

    if (sessionDay == today) {
      return '${l.deck_history_time_today}, $timeStr WIB';
    } else if (sessionDay == today.subtract(const Duration(days: 1))) {
      return '${l.deck_history_time_yesterday}, $timeStr WIB';
    } else {
      final localeCode = Localizations.localeOf(context).languageCode;
      final dayName = DateFormat('EEEE', localeCode).format(dateTime);
      return '$dayName, $timeStr WIB';
    }
  }

  String _formatDurationBadge(BuildContext context, int durationMs) {
    final WidgetVars(:l) = WidgetVars.of(context);
    final minutes = (durationMs / 60000).round();
    if (minutes > 0) {
      return l.deck_history_minutes_badge(minutes);
    } else {
      final seconds = (durationMs / 1000).round();
      return l.deck_history_seconds_badge(seconds);
    }
  }

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :c, :l) = WidgetVars.of(context);

    final isQuiz = item.isQuiz;
    final titleText = isQuiz
        ? l.deck_history_quiz_label
        : l.deck_history_flashcard_label;
    final dateTimeText = _formatDateTime(context, item.completedAt);
    final scoreText = l.deck_history_score_badge(
      item.correctCount,
      item.totalQuestions,
    );
    final durationText = _formatDurationBadge(context, item.durationMs);

    // Color definitions matching the design
    final iconBgColor = isQuiz
        ? const Color(0xFFF3E8FF)
        : const Color(0xFFFFEDD5);
    final iconColor = isQuiz
        ? const Color(0xFF7C3AED)
        : const Color(0xFFEA580C);
    final iconData = isQuiz ? Symbols.article : Symbols.view_carousel;

    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.outlineVariant.withValues(alpha: 0.8)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Leading avatar icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(iconData, size: 22, color: iconColor),
                  ),
                ),
                const SizedBox(width: 12),

                // Main details column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Date row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              titleText,
                              style: t.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 14.5,
                                color: c.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            dateTimeText,
                            style: t.bodySmall?.copyWith(
                              fontSize: 11,
                              color: c.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),

                      // Subtitle (deck name)
                      Text(
                        item.deckName,
                        style: t.bodySmall?.copyWith(
                          fontSize: 12,
                          color: c.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      // Badges row
                      Row(
                        children: [
                          // Score badge
                          _BadgePill(
                            label: scoreText,
                            backgroundColor: const Color(0xFFE8F5E9),
                            textColor: const Color(0xFF2E7D32),
                          ),
                          const SizedBox(width: 6),

                          // Duration badge
                          _BadgePill(
                            label: durationText,
                            backgroundColor: c.surfaceContainerHighest,
                            textColor: c.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 6),

                // Trailing chevron
                const Icon(
                  Icons.chevron_right,
                  size: 22,
                  color: AppColors.primaryDark,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BadgePill extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const _BadgePill({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
