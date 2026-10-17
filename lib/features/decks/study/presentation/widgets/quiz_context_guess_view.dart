import 'package:bahasa/core/theme/app_colors.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/quiz_question.dart';

/// Context-guessing question view in the Quiz game.
/// Displays usage context or explanation and asks the user to pick the matching vocabulary word.
class QuizContextGuessView extends StatelessWidget {
  /// Active context-guess question.
  final QuizQuestion question;

  /// Currently selected option string, if any.
  final String? selectedOption;

  /// Callback invoked when the user taps an option.
  final ValueChanged<String> onSelectOption;

  /// Creates a [QuizContextGuessView].
  const QuizContextGuessView({
    super.key,
    required this.question,
    required this.selectedOption,
    required this.onSelectOption,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :c, :l) = WidgetVars.of(context);

    final contextText = question.card.additionalContext.trim().isNotEmpty
        ? question.card.additionalContext.trim()
        : question.card.defaultLanguage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Instruction header
        Text(
          l.quiz_context_instruction,
          style: t.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: c.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),

        // Context / usage explanation card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: c.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: c.outlineVariant.withAlpha(120),
              width: 1.2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.format_quote_rounded,
                    size: 20,
                    color: c.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Konteks & Penggunaan',
                    style: t.labelMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: c.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                contextText,
                style: t.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  height: 1.45,
                  color: c.onSurface,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 4 selectable vocabulary options
        ...question.options.map((option) {
          final isSelected = selectedOption == option;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: FilledButton(
              onPressed: () => onSelectOption(option),
              style: FilledButton.styleFrom(
                backgroundColor: isSelected ? AppColors.primary : c.surface,
                foregroundColor: c.onSurface,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 18,
                ),
                side: BorderSide(
                  color: isSelected ? AppColors.primaryDark : c.outline,
                  width: 1.2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  option,
                  style: t.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: isSelected ? AppColors.mainText : c.onSurface,
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
