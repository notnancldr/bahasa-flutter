import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button.dart';
import 'package:flutter/material.dart';

/// Empty state widget shown when the user has no decks or learning history.
///
/// Displays a prominent "Kamu belum punya deck!" message and a "Buat Deck" action button.
class HomeEmptyState extends StatelessWidget {
  /// Callback when the "Buat Deck" button is tapped.
  final VoidCallback onCreateDeck;

  const HomeEmptyState({super.key, required this.onCreateDeck});

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :t, :l) = WidgetVars.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l.home_emptyDeckTitle,
          style: t.titleMedium?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: c.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: 160,
          child: EmbossedButton(
            l.home_createDeckButton,
            onPressed: onCreateDeck,
          ),
        ),
      ],
    );
  }
}
