import 'package:bahasa/core/theme/app_colors.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../domain/entities/quiz_question.dart';

/// Bottom sheet overlay displayed when the user checks their answer in Quiz,
/// matching `quiz_correct.png` and `quiz_wrong.png`.
class QuizFeedbackSheet extends StatelessWidget {
  /// Evaluated question.
  final QuizQuestion question;

  /// Whether the user's answer was correct.
  final bool isCorrect;

  /// Callback invoked when the user taps "Lanjut" (`Continue`).
  final VoidCallback onContinue;

  /// Creates a [QuizFeedbackSheet].
  const QuizFeedbackSheet({
    super.key,
    required this.question,
    required this.isCorrect,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :c, :l) = WidgetVars.of(context);
    final rimColor = isCorrect
        ? const Color(0xFF5A8F52)
        : const Color(0xFFC25959);

    return Container(
      decoration: BoxDecoration(
        color: rimColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.only(top: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: const EdgeInsets.fromLTRB(22, 12, 22, 28),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top handle bar
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: c.outline,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 22),

              // Status icon circle
              Center(
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: isCorrect
                        ? const Color(0xFFE7EFE6)
                        : const Color(0xFFF6E6E6),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: isCorrect
                      ? const Icon(
                          Symbols.check,
                          size: 46,
                          weight: 700,
                          color: Color(0xFF5A8F52),
                        )
                      : Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFC25959),
                              width: 4,
                            ),
                          ),
                          child: const Icon(
                            Symbols.close,
                            size: 34,
                            weight: 700,
                            color: Color(0xFFC25959),
                          ),
                        ),
                ),
              ).animate().scale(
                delay: 100.ms,
                duration: 300.ms,
                curve: Curves.easeOutBack,
              ),
              const SizedBox(height: 18),

              if (isCorrect)
                Text(
                  l.quiz_feedback_correct_title,
                  textAlign: TextAlign.center,
                  style: t.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    color: c.onSurface,
                  ),
                )
              else ...[
                Text(
                  l.quiz_feedback_wrong_title,
                  textAlign: TextAlign.center,
                  style: t.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: c.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      question.correctAnswer,
                      style: t.labelLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.mainText,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),

              // Card context explanation box
              if (question.card.additionalContext.trim().isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: c.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: c.outline, width: 1),
                  ),
                  child: Text(
                    question.card.additionalContext,
                    style: t.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.45,
                      color: c.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              EmbossedButton(l.quiz_continue_button, onPressed: onContinue),
            ],
          ),
        ),
      ),
    );
  }
}
