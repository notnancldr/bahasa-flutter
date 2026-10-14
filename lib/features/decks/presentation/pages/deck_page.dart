import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';

/// Placeholder page for the Deck dashboard / list branch.
class DeckPage extends StatelessWidget {
  const DeckPage({super.key});

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :c, :l) = WidgetVars.of(context);

    return Scaffold(
      body: Center(
        child: Text(
          l.deck_page_placeholder,
          style: t.titleMedium?.copyWith(color: c.onSurfaceVariant),
        ),
      ),
    );
  }
}
