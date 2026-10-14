import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Error view shown when the selected `.euy` file is corrupted or invalid.
class ImportErrorView extends StatelessWidget {
  /// Reason or message describing the failure.
  final String errorMessage;

  /// Callback to retry picking another file.
  final VoidCallback onPickAnother;

  const ImportErrorView({
    super.key,
    required this.errorMessage,
    required this.onPickAnother,
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
          l.deck_import_invalid_title,
          style: t.titleMedium?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: c.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),

        // Subtitle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            l.deck_import_invalid_subtitle,
            style: t.bodySmall?.copyWith(color: c.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ),

        const Spacer(),

        // CTA
        EmbossedButton(
          l.deck_import_pick_another,
          onPressed: onPickAnother,
          trailingIcon: Symbols.folder_open,
        ),
      ],
    );
  }
}
