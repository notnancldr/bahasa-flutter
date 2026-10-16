import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../domain/entities/deck_card_item.dart';

/// Modal bottom sheet displaying the full details of a [DeckCardItem],
/// including target phrase, default language meaning, phonetic reading,
/// and usage description.
class CardDetailBottomSheet extends StatelessWidget {
  /// The card to display.
  final DeckCardItem card;

  /// Creates a [CardDetailBottomSheet].
  const CardDetailBottomSheet({super.key, required this.card});

  /// Shows the [CardDetailBottomSheet] for [card].
  static Future<void> show(BuildContext context, DeckCardItem card) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CardDetailBottomSheet(card: card),
    );
  }

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :c, :l) = WidgetVars.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: c.outline,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            // Close button
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Symbols.close, size: 22, color: c.onSurfaceVariant),
              ),
            ),

            // Target word
            Text(
              card.translation,
              textAlign: TextAlign.center,
              style: t.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 24,
                color: c.onSurface,
              ),
            ),
            const SizedBox(height: 4),

            // Meaning in default language
            Text(
              card.defaultLanguage,
              textAlign: TextAlign.center,
              style: t.titleMedium?.copyWith(
                fontSize: 16,
                color: c.onSurfaceVariant,
              ),
            ),

            if (card.phoneticLang.trim().isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                card.phoneticLang,
                textAlign: TextAlign.center,
                style: t.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                  fontSize: 16,
                  color: c.onSurfaceVariant,
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Description box
            if (card.additionalContext.trim().isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: c.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.deck_details_card_description_label,
                      style: t.labelSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: c.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      card.additionalContext,
                      style: t.bodyMedium?.copyWith(
                        height: 1.45,
                        color: c.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
