import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Row of two large self-assessment buttons ("Belum hafal" and "Sudah hafal")
/// displayed after the user flips a flashcard.
class FlashcardAssessmentRow extends StatelessWidget {
  /// Callback invoked when the user taps "Belum hafal" (`false`).
  final VoidCallback onNotMemorized;

  /// Callback invoked when the user taps "Sudah hafal" (`true`).
  final VoidCallback onMemorized;

  /// Creates a [FlashcardAssessmentRow].
  const FlashcardAssessmentRow({
    super.key,
    required this.onNotMemorized,
    required this.onMemorized,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:l) = WidgetVars.of(context);

    return Row(
      children: [
        Expanded(
          child: _AssessmentCardButton(
            label: l.flashcard_not_memorized,
            icon: Symbols.close,
            backgroundColor: const Color(0xFFFDEDED),
            borderColor: const Color(0xFFE5A4A4),
            iconColor: const Color(0xFFDD6B6B),
            onPressed: onNotMemorized,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _AssessmentCardButton(
            label: l.flashcard_memorized,
            icon: Symbols.check,
            backgroundColor: const Color(0xFFF0FAF0),
            borderColor: const Color(0xFFA8D5A2),
            iconColor: const Color(0xFF5A8F52),
            onPressed: onMemorized,
          ),
        ),
      ],
    );
  }
}

class _AssessmentCardButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final VoidCallback onPressed;

  const _AssessmentCardButton({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t) = WidgetVars.of(context);

    return SizedBox(
      height: 164,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: const Color(0xFF5D5D5D),
          elevation: 0,
          side: BorderSide(color: borderColor, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 38, weight: 700, color: iconColor),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: t.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: const Color(0xFF666666),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
