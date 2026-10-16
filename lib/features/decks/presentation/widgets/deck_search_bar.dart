import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Rounded pill search input bar used on the Deck Compilation page.
class DeckSearchBar extends StatelessWidget {
  /// Controller for the search text input.
  final TextEditingController controller;

  /// Callback invoked whenever the search query text changes.
  final ValueChanged<String> onChanged;

  /// Creates a [DeckSearchBar].
  const DeckSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :t, :l) = WidgetVars.of(context);

    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: t.bodyMedium?.copyWith(color: c.onSurface),
      decoration: InputDecoration(
        hintText: l.deck_search_hint,
        hintStyle: t.bodyMedium?.copyWith(color: c.onSurfaceVariant),
        prefixIcon: Icon(Symbols.search, size: 20, color: c.onSurfaceVariant),
        filled: true,
        fillColor: c.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: c.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: c.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: c.primary, width: 1.5),
        ),
      ),
    );
  }
}
