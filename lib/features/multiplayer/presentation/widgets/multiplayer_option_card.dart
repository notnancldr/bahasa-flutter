import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';

/// Interactive answer option tile supporting idle, selected, correct, and wrong feedback states.
class MultiplayerOptionCard extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final VoidCallback? onTap;

  const MultiplayerOptionCard({
    super.key,
    required this.text,
    this.isSelected = false,
    this.isCorrect = false,
    this.isWrong = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t) = WidgetVars.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bgColor;
    Color borderColor;
    Color textColor;

    if (isCorrect) {
      bgColor = isDark ? const Color(0xFF1E3A2A) : const Color(0xFFE8F5E9);
      borderColor = const Color(0xFF4CAF50);
      textColor = isDark ? const Color(0xFFA5D6A7) : const Color(0xFF2E7D32);
    } else if (isWrong) {
      bgColor = isDark ? const Color(0xFF3E2020) : const Color(0xFFFFEBEE);
      borderColor = const Color(0xFFE57373);
      textColor = isDark ? const Color(0xFFEF9A9A) : const Color(0xFFC62828);
    } else if (isSelected) {
      bgColor = isDark ? const Color(0xFF1E3A4A) : const Color(0xFFBCE7F0);
      borderColor = const Color(0xFF7CB8C9);
      textColor = isDark ? Colors.white : const Color(0xFF1D4A5C);
    } else {
      bgColor = isDark ? const Color(0xFF1E2630) : const Color(0xFFF8FAFC);
      borderColor = isDark ? const Color(0xFF2E3846) : const Color(0xFFE2E8F0);
      textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor, width: 1.5),
            ),
            child: Text(
              text,
              style: t.bodyLarge?.copyWith(
                fontWeight: (isSelected || isCorrect || isWrong)
                    ? FontWeight.w700
                    : FontWeight.w600,
                fontSize: 15,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
