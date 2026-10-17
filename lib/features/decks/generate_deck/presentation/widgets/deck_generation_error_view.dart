import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Error view displayed when deck generation fails.
class DeckGenerationErrorView extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onBackToHome;

  const DeckGenerationErrorView({
    super.key,
    required this.errorMessage,
    required this.onBackToHome,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :t, :l) = WidgetVars.of(context);

    return Column(
      children: [
        const Spacer(),

        // Error circle badge
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: c.errorContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(Symbols.error, size: 36, color: c.error),
        ),
        const SizedBox(height: 24),

        // Title
        Text(
          l.deck_gen_error_title,
          style: t.titleMedium?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: c.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),

        // Subtitle / Detailed error message
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            errorMessage.isNotEmpty ? errorMessage : l.deck_gen_error_subtitle,
            style: t.bodySmall?.copyWith(color: c.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ),

        const Spacer(),

        // CTA
        EmbossedButton(
          l.deck_back_to_home,
          onPressed: onBackToHome,
          trailingIcon: Symbols.home,
        ),
      ],
    );
  }
}
