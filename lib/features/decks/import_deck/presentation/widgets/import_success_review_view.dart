import 'package:bahasa/core/theme/app_colors.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../domain/entities/euy_deck.dart';

/// Ready / Success review view displayed once the deck has been validated and imported.
class ImportSuccessReviewView extends StatelessWidget {
  /// The imported deck entity.
  final EuyDeck deck;

  /// Formatted file size string.
  final String fileSizeFormatted;

  /// Callback to continue to the deck view.
  final VoidCallback onContinue;

  const ImportSuccessReviewView({
    super.key,
    required this.deck,
    required this.fileSizeFormatted,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :t, :l) = WidgetVars.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        Text(
          l.deck_import_ready_title,
          style: t.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: c.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l.deck_import_ready_subtitle,
          style: t.bodySmall?.copyWith(color: c.onSurfaceVariant),
        ),
        const SizedBox(height: 24),

        // Detail Summary Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: c.outline),
          ),
          child: Column(
            children: [
              _SummaryDetailRow(
                badgeBg: AppColors.secondary,
                iconColor: const Color(0xFF7C2D12),
                icon: Symbols.style,
                label: l.deck_gen_name_label,
                value: deck.name,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: c.outlineVariant,
                ),
              ),
              _SummaryDetailRow(
                badgeBg: AppColors.tertiary,
                iconColor: const Color(0xFF5B21B6),
                icon: Symbols.layers,
                label: l.deck_card_count_label,
                value: l.home_cardsCount(deck.listCards.length),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: c.outlineVariant,
                ),
              ),
              _SummaryDetailRow(
                badgeBg: AppColors.secondary,
                iconColor: const Color(0xFF7C2D12),
                icon: Symbols.folder,
                label: l.deck_file_size_label,
                value: fileSizeFormatted,
              ),
            ],
          ),
        ),

        const Spacer(),

        // Primary Action Button
        EmbossedButton(
          l.deck_continue,
          onPressed: onContinue,
          trailingIcon: Symbols.arrow_forward,
        ),
      ],
    );
  }
}

class _SummaryDetailRow extends StatelessWidget {
  final Color badgeBg;
  final Color iconColor;
  final IconData icon;
  final String label;
  final String value;

  const _SummaryDetailRow({
    required this.badgeBg,
    required this.iconColor,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :t) = WidgetVars.of(context);

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: badgeBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 14),
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}
