import 'package:bahasa/core/theme/app_colors.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../bloc/generate_deck_state.dart';

/// Review summary step allowing the user to review choices and jump back to edit.
class DeckGenerationReviewStep extends StatelessWidget {
  final GenerateDeckWizardState state;
  final ValueChanged<int> onEditStep;
  final VoidCallback onCreateDeck;
  final VoidCallback onCancel;

  const DeckGenerationReviewStep({
    super.key,
    required this.state,
    required this.onEditStep,
    required this.onCreateDeck,
    required this.onCancel,
  });

  String _formatDifficulty(String diff, WidgetVars v) {
    return switch (diff) {
      'beginner' => v.l.deck_gen_diff_beginner,
      'intermediate' => v.l.deck_gen_diff_intermediate,
      'expert' => v.l.deck_gen_diff_expert,
      _ => diff,
    };
  }

  @override
  Widget build(BuildContext context) {
    final v = WidgetVars.of(context);
    final WidgetVars(:c, :t, :l) = v;

    final langName = l.languageName(state.language);
    final diffLabel = _formatDifficulty(state.difficulty, v);
    final descText = state.description.isEmpty ? '-' : state.description;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        Text(
          l.deck_gen_review_title,
          style: t.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: c.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l.deck_gen_review_desc,
          style: t.bodySmall?.copyWith(color: c.onSurfaceVariant),
        ),
        const SizedBox(height: 24),

        // Summary Container Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: c.outline),
          ),
          child: Column(
            children: [
              _ReviewRow(
                badgeBg: AppColors.secondary,
                iconColor: const Color(0xFF7C2D12),
                icon: Symbols.title,
                label: l.deck_gen_name_label,
                value: state.name,
                onEdit: () => onEditStep(0),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: c.outlineVariant,
                ),
              ),
              _ReviewRow(
                badgeBg: AppColors.tertiary,
                iconColor: const Color(0xFF5B21B6),
                icon: Symbols.public,
                label: l.deck_gen_country_title,
                value: langName,
                onEdit: () => onEditStep(1),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: c.outlineVariant,
                ),
              ),
              _ReviewRow(
                badgeBg: AppColors.secondary,
                iconColor: const Color(0xFF7C2D12),
                icon: Symbols.bar_chart,
                label: l.deck_gen_diff_title,
                value: diffLabel,
                onEdit: () => onEditStep(2),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: c.outlineVariant,
                ),
              ),
              _ReviewRow(
                badgeBg: AppColors.tertiary,
                iconColor: const Color(0xFF5B21B6),
                icon: Symbols.description,
                label: l.deck_gen_desc_title,
                value: descText,
                onEdit: () => onEditStep(3),
              ),
            ],
          ),
        ),

        const Spacer(),

        // Primary: Buat Deck
        EmbossedButton(l.deck_gen_create_button, onPressed: onCreateDeck),
        const SizedBox(height: 12),

        // Secondary: Batal
        EmbossedButton(
          l.deck_gen_cancel_button,
          onPressed: onCancel,
          type: EmbossedButtonType.outlined,
        ),
      ],
    );
  }
}

class _ReviewRow extends StatelessWidget {
  final Color badgeBg;
  final Color iconColor;
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onEdit;

  const _ReviewRow({
    required this.badgeBg,
    required this.iconColor,
    required this.icon,
    required this.label,
    required this.value,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :t, :s, :l) = WidgetVars.of(context);

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: badgeBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: t.labelSmall?.copyWith(color: c.onSurfaceVariant),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: t.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: c.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: onEdit,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            l.deck_gen_review_change,
            style: t.labelMedium?.copyWith(
              color: s.primaryDark,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
