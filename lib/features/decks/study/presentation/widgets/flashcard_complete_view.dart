import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button.dart';
import 'package:bahasa/core/widgets/flame_icon.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/study_session_result.dart';

/// Completion summary view (`Latihan Selesai`) displayed at the end of a
/// Flashcard session, matching `flashcards_complete.png`.
class FlashcardCompleteView extends StatelessWidget {
  /// Session result data.
  final StudySessionResult result;

  /// Callback invoked when the user finishes and returns to Deck Details.
  final VoidCallback onFinish;

  /// Creates a [FlashcardCompleteView].
  const FlashcardCompleteView({
    super.key,
    required this.result,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :c, :l) = WidgetVars.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),

          // Flame icon & title
          const Center(child: FlameIcon(streakCount: 1, size: 150)),
          const SizedBox(height: 20),
          Text(
            l.flashcard_complete_title,
            textAlign: TextAlign.center,
            style: t.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
              fontSize: 26,
              color: c.onSurface,
            ),
          ),
          const SizedBox(height: 28),

          // 4-column grid of rounded card outcome tiles
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: result.outcomes.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.38,
            ),
            itemBuilder: (context, index) {
              final isMemorized = result.outcomes[index];
              return DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: isMemorized
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFFC9502), Color(0xFFFF4C0D)],
                        )
                      : null,
                  color: isMemorized ? null : c.surface,
                ),
              );
            },
          ),

          const Spacer(flex: 2),

          Divider(color: c.outline, height: 1),
          const SizedBox(height: 16),

          // 3-column summary stats row
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _SummaryStatColumn(
                    value: l.flashcard_complete_cards_value(
                      result.correctCount,
                    ),
                    label: l.flashcard_complete_memorized_label,
                  ),
                ),
                VerticalDivider(color: c.outline, width: 16, thickness: 1),
                Expanded(
                  child: _SummaryStatColumn(
                    value: l.flashcard_complete_cards_value(result.wrongCount),
                    label: l.flashcard_complete_not_memorized_label,
                  ),
                ),
                VerticalDivider(color: c.outline, width: 16, thickness: 1),
                Expanded(
                  child: _SummaryStatColumn(
                    value: l.flashcard_complete_active_time_value(
                      result.durationMinutes,
                      result.durationSeconds,
                    ),
                    label: l.flashcard_complete_active_time_label,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          EmbossedButton(
            l.flashcard_complete_finish_button,
            onPressed: onFinish,
          ),
        ],
      ),
    );
  }
}

class _SummaryStatColumn extends StatelessWidget {
  final String value;
  final String label;

  const _SummaryStatColumn({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :c) = WidgetVars.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          textAlign: TextAlign.center,
          style: t.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            fontSize: 19,
            color: c.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: t.labelSmall?.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: c.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
