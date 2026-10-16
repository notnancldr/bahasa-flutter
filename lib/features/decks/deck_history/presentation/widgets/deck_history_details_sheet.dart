import 'package:bahasa/core/theme/app_colors.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../domain/entities/deck_history_card_log.dart';
import '../../domain/entities/deck_history_item.dart';

/// Modal bottom sheet displaying detailed study session statistics and practiced cards
/// matching `deck_history_details.png`.
class DeckHistoryDetailsSheet extends StatelessWidget {
  /// Session item data.
  final DeckHistoryItem session;

  /// Card question logs practiced during this session.
  final List<DeckHistoryCardLog> cardLogs;

  /// Whether question logs are still being loaded.
  final bool isLoading;

  /// Creates a [DeckHistoryDetailsSheet].
  const DeckHistoryDetailsSheet({
    super.key,
    required this.session,
    required this.cardLogs,
    this.isLoading = false,
  });

  /// Displays the [DeckHistoryDetailsSheet] modal bottom sheet.
  static Future<void> show(
    BuildContext context, {
    required DeckHistoryItem session,
    required List<DeckHistoryCardLog> cardLogs,
    bool isLoading = false,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DeckHistoryDetailsSheet(
        session: session,
        cardLogs: cardLogs,
        isLoading: isLoading,
      ),
    );
  }

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

  String _formatDuration(BuildContext context, int durationMs) {
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

    final dateTimeText = _formatDateTime(context, session.completedAt);
    final scoreRatio = '${session.correctCount} / ${session.totalQuestions}';
    final accuracyPercent = '${session.finalScore.round()}%';
    final durationFormatted = _formatDuration(context, session.durationMs);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top drag handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: c.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Header: Deck Title & Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      session.deckName,
                      style: t.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: AppColors.primaryDark,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: IconButton.styleFrom(
                      backgroundColor: c.surfaceContainerHighest,
                      minimumSize: const Size(36, 36),
                      padding: EdgeInsets.zero,
                    ),
                    icon: Icon(
                      Symbols.close,
                      size: 18,
                      color: c.onSurfaceVariant,
                    ),
                  ),
                ],
              ),

              // Timestamp
              Center(
                child: Text(
                  dateTimeText,
                  style: t.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: c.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 3-Metric Summary Card
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: c.outlineVariant),
                ),
                child: Row(
                  children: [
                    // Correct Answers
                    Expanded(
                      child: _SheetStatColumn(
                        value: '$scoreRatio Benar',
                        label: l.deck_history_sheet_correct_answers,
                      ),
                    ),
                    Container(height: 36, width: 1, color: c.outlineVariant),

                    // Duration
                    Expanded(
                      child: _SheetStatColumn(
                        value: durationFormatted,
                        label: l.deck_history_sheet_session_duration,
                      ),
                    ),
                    Container(height: 36, width: 1, color: c.outlineVariant),

                    // Accuracy
                    Expanded(
                      child: _SheetStatColumn(
                        value: accuracyPercent,
                        label: l.deck_history_sheet_accuracy,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Section Header: Kartu yang dipelajari
              Center(
                child: Text(
                  l.deck_history_sheet_cards_studied,
                  style: t.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: c.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Practiced Cards List
              Flexible(
                child: isLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : cardLogs.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            l.deck_progress_weakest_empty,
                            style: t.bodySmall?.copyWith(
                              color: c.onSurfaceVariant,
                            ),
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: cardLogs.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final cardLog = cardLogs[index];
                          return _CardLogRow(log: cardLog);
                        },
                      ),
              ),
              const SizedBox(height: 16),

              // Dismiss button: Tutup rincian
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.primaryDark,
                  elevation: 0,
                  minimumSize: const Size.fromHeight(46),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: Text(
                  l.deck_history_sheet_close,
                  style: t.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetStatColumn extends StatelessWidget {
  final String value;
  final String label;

  const _SheetStatColumn({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :c) = WidgetVars.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          textAlign: TextAlign.center,
          style: t.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 14.5,
            color: c.onSurface,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 3),
        Text(
          label,
          textAlign: TextAlign.center,
          style: t.bodySmall?.copyWith(
            fontSize: 10.5,
            color: c.onSurfaceVariant,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _CardLogRow extends StatelessWidget {
  final DeckHistoryCardLog log;

  const _CardLogRow({required this.log});

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :c, :l) = WidgetVars.of(context);

    final isMastered = log.isCorrect;
    final badgeLabel = isMastered
        ? l.deck_history_sheet_mastered
        : l.deck_history_sheet_needs_review;
    final badgeBg = isMastered
        ? const Color(0xFFE8F5E9)
        : const Color(0xFFFFEBEE);
    final badgeTextColor = isMastered
        ? const Color(0xFF2E7D32)
        : const Color(0xFFC62828);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.outlineVariant),
      ),
      child: Row(
        children: [
          // Term and translation
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  log.defaultLanguage,
                  style: t.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                    color: c.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  log.translation,
                  style: t.bodySmall?.copyWith(
                    fontSize: 11.5,
                    color: c.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Mastery badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              badgeLabel,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: badgeTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
