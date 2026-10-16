import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../domain/entities/deck_card_item.dart';

/// Body section of the Deck Details page containing the card search bar
/// and the bordered list of vocabulary cards.
class DeckCardListSection extends StatelessWidget {
  /// Controller for the card search text field.
  final TextEditingController searchController;

  /// Callback fired when the search text changes.
  final ValueChanged<String> onSearchChanged;

  /// Filtered list of cards to display.
  final List<DeckCardItem> cards;

  /// Callback invoked when a card tile is tapped.
  final ValueChanged<DeckCardItem> onCardTap;

  /// Creates a [DeckCardListSection].
  const DeckCardListSection({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.cards,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :c, :l) = WidgetVars.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Subtle top divider handle
        Center(
          child: Container(
            width: 56,
            height: 3.5,
            decoration: BoxDecoration(
              color: c.outline,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Pill search bar
        TextField(
          controller: searchController,
          onChanged: onSearchChanged,
          style: t.bodyMedium?.copyWith(color: c.onSurface),
          decoration: InputDecoration(
            hintText: l.deck_details_search_hint,
            hintStyle: t.bodyMedium?.copyWith(color: c.onSurfaceVariant),
            prefixIcon: Icon(
              Symbols.search,
              size: 20,
              color: c.onSurfaceVariant,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(999),
              borderSide: BorderSide(color: c.outline, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(999),
              borderSide: BorderSide(color: c.primary, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Rounded outer container holding the card list
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: c.outline, width: 1.2),
          ),
          child: cards.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Text(
                      l.deck_details_empty_cards,
                      style: t.bodyMedium?.copyWith(color: c.onSurfaceVariant),
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cards.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final card = cards[index];
                    return _DeckCardTile(
                      card: card,
                      onTap: () => onCardTap(card),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _DeckCardTile extends StatelessWidget {
  final DeckCardItem card;
  final VoidCallback onTap;

  const _DeckCardTile({required this.card, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :c) = WidgetVars.of(context);

    return FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        backgroundColor: c.surface,
        foregroundColor: c.onSurface,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card.translation,
                  style: t.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: c.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  card.defaultLanguage,
                  style: t.bodySmall?.copyWith(
                    fontSize: 13,
                    color: c.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Symbols.chevron_right,
            size: 20,
            weight: 600,
            color: c.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
