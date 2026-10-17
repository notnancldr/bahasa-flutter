import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Grid of stars depicting outcomes of each question on the completion screen.
class MultiplayerStarGrid extends StatelessWidget {
  final List<bool?> outcomes;
  final int totalQuestions;

  const MultiplayerStarGrid({
    super.key,
    required this.outcomes,
    this.totalQuestions = 10,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final emptyColor = isDark
        ? const Color(0xFF37474F)
        : const Color(0xFFCFD8DC);
    const filledColor = Color(0xFFFF6D00);

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 16,
      children: List.generate(totalQuestions, (index) {
        final isCorrect = index < outcomes.length && outcomes[index] == true;

        return Icon(
          Symbols.star,
          size: 44,
          fill: 1.0,
          color: isCorrect ? filledColor : emptyColor,
        );
      }),
    );
  }
}
