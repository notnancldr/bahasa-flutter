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
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 32),

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
                const SizedBox(height: 12),

                // Detailed error message container
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: c.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: c.outlineVariant),
                  ),
                  child: Text(
                    errorMessage.isNotEmpty
                        ? errorMessage
                        : l.deck_gen_error_subtitle,
                    style: t.bodySmall?.copyWith(
                      color: c.onSurfaceVariant,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),

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
