import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/custom_options.dart';
import 'package:flutter/material.dart';

/// Step 3: Difficulty level selection (beginner, intermediate, expert).
class DeckGenerationDifficultyStep extends StatelessWidget {
  final String selectedDifficulty;
  final ValueChanged<String> onDifficultySelected;

  const DeckGenerationDifficultyStep({
    super.key,
    required this.selectedDifficulty,
    required this.onDifficultySelected,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :t, :s, :l) = WidgetVars.of(context);

    final options = [
      (key: 'beginner', title: l.deck_gen_diff_beginner),
      (key: 'intermediate', title: l.deck_gen_diff_intermediate),
      (key: 'expert', title: l.deck_gen_diff_expert),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        Text(
          l.deck_gen_diff_title,
          style: t.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: c.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l.deck_gen_diff_desc,
          style: t.bodySmall?.copyWith(color: c.onSurfaceVariant),
        ),
        const SizedBox(height: 28),
        ...options.map((opt) {
          final isSelected = selectedDifficulty == opt.key;
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: CustomOption(
              selected: isSelected,
              onTap: () => onDifficultySelected(opt.key),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              borderRadius: BorderRadius.circular(16),
              selectedColor: const Color(0xFFA0D1E4),
              unselectedColor: c.surfaceContainerHighest.withValues(
                alpha: 0.55,
              ),
              selectedBorder: Border.all(color: s.primaryDark, width: 1.5),
              unselectedBorder: Border.all(
                color: Colors.transparent,
                width: 1.5,
              ),
              title: Text(
                opt.title,
                style: t.bodyLarge?.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: c.onSurface,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
