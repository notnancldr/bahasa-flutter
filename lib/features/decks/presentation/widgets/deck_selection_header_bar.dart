import 'package:bahasa/core/theme/app_colors.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Top-right action bar displayed above the deck grid in selection mode,
/// allowing the user to select all or deselect all visible decks.
class DeckSelectionHeaderBar extends StatelessWidget {
  /// Whether all visible decks are currently selected.
  final bool isAllSelected;

  /// Callback invoked when the user taps "Pilih semua".
  final VoidCallback onSelectAll;

  /// Callback invoked when the user taps "Batal pilih semua".
  final VoidCallback onDeselectAll;

  /// Creates a [DeckSelectionHeaderBar].
  const DeckSelectionHeaderBar({
    super.key,
    required this.isAllSelected,
    required this.onSelectAll,
    required this.onDeselectAll,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:l) = WidgetVars.of(context);

    return Align(
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        onPressed: isAllSelected ? onDeselectAll : onSelectAll,
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryDark,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        icon: Icon(
          isAllSelected ? Symbols.deselect : Symbols.select_all,
          size: 18,
          color: AppColors.primaryDark,
        ),
        label: Text(
          isAllSelected ? l.deck_deselect_all : l.deck_select_all,
          style: const TextStyle(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
