import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Progress view displayed during AI deck generation.
class DeckGenerationProgressView extends StatelessWidget {
  final VoidCallback onRunInBackground;
  final int collectedCards;
  final int totalCards;
  final bool isLocalAi;

  const DeckGenerationProgressView({
    super.key,
    required this.onRunInBackground,
    this.collectedCards = 0,
    this.totalCards = 20,
    this.isLocalAi = false,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :t, :s, :l) = WidgetVars.of(context);

    return Column(
      children: [
        const Spacer(),

        // Progress ring with center book icon
        SizedBox(
          width: 140,
          height: 140,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 140,
                height: 140,
                child: CircularProgressIndicator(
                  strokeWidth: 8,
                  backgroundColor: c.outlineVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(s.primaryDark),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: c.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(Symbols.menu_book, size: 26, color: s.primaryDark),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // Title & Subtitle
        Text(
          l.deck_gen_progress_title,
          style: t.titleMedium?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: c.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            isLocalAi && collectedCards > 0
                ? l.deck_gen_cards_collected_progress(collectedCards, totalCards)
                : l.deck_gen_progress_subtitle,
            style: t.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: c.primary,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        const Spacer(),

        // Secondary outline button
        EmbossedButton(
          l.deck_run_in_background,
          onPressed: onRunInBackground,
          type: EmbossedButtonType.outlined,
        ),
      ],
    );
  }
}
