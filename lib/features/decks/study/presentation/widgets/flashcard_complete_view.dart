import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button.dart';
import 'package:bahasa/core/widgets/flame_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_symbols_icons/symbols.dart';

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
          Center(
            child: const FlameIcon(streakCount: 1, size: 150)
                .animate()
                .scale(duration: 400.ms, curve: Curves.easeOutBack)
                .fadeIn(duration: 300.ms),
          ),
          const SizedBox(height: 20),
          Text(
            l.flashcard_complete_title,
            textAlign: TextAlign.center,
            style: t.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
              fontSize: 26,
              color: c.onSurface,
            ),
          )
              .animate()
              .slideY(
                begin: 0.3,
                end: 0.0,
                duration: 350.ms,
                delay: 150.ms,
                curve: Curves.easeOutCubic,
              )
              .fadeIn(delay: 150.ms),
          const SizedBox(height: 28),

          // 5-column grid of rounded star icons
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: result.outcomes.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 14,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, index) {
              final isMemorized = result.outcomes[index];
              return Center(
                child: Icon(
                  Symbols.star,
                  fill: 1,
                  size: 46,
                  color: isMemorized
                      ? const Color(0xFFFF6D00)
                      : (Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF37474F)
                          : const Color(0xFFCFD8DC)),
                ),
              )
                  .animate()
                  .scale(
                    delay: (250 + index * 50).ms,
                    duration: 300.ms,
                    curve: Curves.easeOutBack,
                  )
                  .fadeIn(delay: (250 + index * 50).ms);
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
          )
              .animate()
              .slideY(
                begin: 0.3,
                end: 0.0,
                delay: 600.ms,
                duration: 350.ms,
                curve: Curves.easeOutCubic,
              )
              .fadeIn(delay: 600.ms),
          const SizedBox(height: 24),

          EmbossedButton(
            l.flashcard_complete_finish_button,
            onPressed: onFinish,
          )
              .animate()
              .slideY(
                begin: 0.4,
                end: 0.0,
                delay: 750.ms,
                duration: 350.ms,
                curve: Curves.easeOutCubic,
              )
              .fadeIn(delay: 750.ms),
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
