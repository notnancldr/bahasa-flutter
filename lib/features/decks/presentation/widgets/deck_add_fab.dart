import 'package:bahasa/core/theme/app_colors.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Rounded-square floating action button for adding a new deck on the Deck Compilation page.
class DeckAddFab extends StatelessWidget {
  /// Callback invoked when the button is pressed.
  final VoidCallback onPressed;

  /// Creates a [DeckAddFab].
  const DeckAddFab({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:l) = WidgetVars.of(context);

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Tooltip(
        message: l.deck_add_fab_tooltip,
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primaryDark,
            foregroundColor: Colors.white,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Icon(Symbols.add, size: 34, color: Colors.white),
        ),
      ),
    );
  }
}
