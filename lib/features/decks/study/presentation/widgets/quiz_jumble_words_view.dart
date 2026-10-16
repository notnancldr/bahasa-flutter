import 'package:bahasa/core/theme/app_colors.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../domain/entities/quiz_question.dart';

/// Jumble Words arrangement view in the Quiz game (`quiz_jumbleWords.png`).
class QuizJumbleWordsView extends StatelessWidget {
  /// Active jumble words question.
  final QuizQuestion question;

  /// Ordered indices into `question.wordBank` currently placed in the answer box.
  final List<int> selectedWordIndices;

  /// Callback invoked when a word chip is tapped in either the answer box or word bank.
  final ValueChanged<int> onToggleWordIndex;

  /// Creates a [QuizJumbleWordsView].
  const QuizJumbleWordsView({
    super.key,
    required this.question,
    required this.selectedWordIndices,
    required this.onToggleWordIndex,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :c, :l) = WidgetVars.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l.quiz_jumble_instruction,
          style: t.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: c.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 18),

        // Target word prompt
        Text(
          question.card.translation,
          style: t.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            fontSize: 22,
            color: c.onSurface,
          ),
        ),
        if (question.card.phoneticLang.trim().isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            question.card.phoneticLang,
            style: t.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: c.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: 18),

        // Answer box
        Container(
          constraints: const BoxConstraints(minHeight: 62),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: c.outline, width: 1.2),
          ),
          alignment: Alignment.centerLeft,
          child: selectedWordIndices.isEmpty
              ? Text(
                  l.quiz_jumble_placeholder,
                  style: t.bodySmall?.copyWith(
                    color: c.onSurfaceVariant.withValues(alpha: 0.65),
                  ),
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: selectedWordIndices.map((bankIdx) {
                    final word = question.wordBank[bankIdx];
                    return _WordChipButton(
                      word: word,
                      isSelectedInBox: true,
                      onPressed: () => onToggleWordIndex(bankIdx),
                    );
                  }).toList(),
                ),
        ),
        const SizedBox(height: 14),

        // Word bank chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(question.wordBank.length, (index) {
            final isUsed = selectedWordIndices.contains(index);
            final word = question.wordBank[index];
            return _WordChipButton(
              word: word,
              isSelectedInBox: isUsed,
              onPressed: () => onToggleWordIndex(index),
            );
          }),
        ),
      ],
    );
  }
}

class _WordChipButton extends StatelessWidget {
  final String word;
  final bool isSelectedInBox;
  final VoidCallback onPressed;

  const _WordChipButton({
    required this.word,
    required this.isSelectedInBox,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :c) = WidgetVars.of(context);

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelectedInBox
            ? AppColors.primary.withValues(alpha: 0.25)
            : Colors.transparent,
        foregroundColor: c.onSurface,
        minimumSize: const Size(0, 32),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        side: BorderSide(
          color: isSelectedInBox ? AppColors.primaryDark : c.outline,
          width: 1.1,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelectedInBox ? Symbols.close : Symbols.add,
            size: 14,
            weight: 700,
            color: c.onSurface,
          ),
          const SizedBox(width: 4),
          Text(
            word,
            style: t.labelSmall?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 11,
              color: c.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
