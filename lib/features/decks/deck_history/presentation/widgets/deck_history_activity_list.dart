import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../domain/entities/deck_history_item.dart';
import 'deck_history_item_card.dart';

/// Renders the "Aktifitas Belajar" section with session count and list of study sessions.
class DeckHistoryActivityList extends StatelessWidget {
  /// Completed study sessions to display.
  final List<DeckHistoryItem> items;

  /// Callback when user taps a session card to open details.
  final ValueChanged<DeckHistoryItem> onSessionTap;

  /// Creates a [DeckHistoryActivityList].
  const DeckHistoryActivityList({
    super.key,
    required this.items,
    required this.onSessionTap,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :c, :l) = WidgetVars.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Section Header Row: Title & Count
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l.deck_history_activities_title,
              style: t.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: c.onSurfaceVariant,
              ),
            ),
            Text(
              l.deck_history_activities_count(items.length),
              style: t.bodySmall?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: c.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // List or Empty State
        if (items.isEmpty)
          _EmptyHistoryView()
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = items[index];
              return DeckHistoryItemCard(
                item: item,
                onTap: () => onSessionTap(item),
              );
            },
          ),
      ],
    );
  }
}

class _EmptyHistoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :c, :l) = WidgetVars.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.outlineVariant.withValues(alpha: 0.6)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Symbols.history_toggle_off,
            size: 44,
            color: c.onSurfaceVariant.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 12),
          Text(
            l.deck_history_empty_title,
            style: t.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: c.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l.deck_history_empty_subtitle,
            textAlign: TextAlign.center,
            style: t.bodySmall?.copyWith(
              fontSize: 12,
              color: c.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
