import 'package:bahasa/core/theme/app_colors.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/quiz_question.dart';

/// Multiple Choice question view in the Quiz game (`quiz_multipleChoice.png`).
class QuizMultipleChoiceView extends StatelessWidget {
  /// Active multiple-choice question.
  final QuizQuestion question;

  /// Currently selected option string, if any.
  final String? selectedOption;

  /// Callback invoked when the user taps an option.
  final ValueChanged<String> onSelectOption;

  /// Creates a [QuizMultipleChoiceView].
  const QuizMultipleChoiceView({
    super.key,
    required this.question,
    required this.selectedOption,
    required this.onSelectOption,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :c, :l) = WidgetVars.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l.quiz_mc_instruction,
          style: t.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: c.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 18),

        // Target foreign word & phonetic reading
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

        // 4 selectable options
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
                    fontSize: 13.5,
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
