import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button.dart';
import 'package:bahasa/core/widgets/shape_loading.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Progress view displaying a circular progress ring and active file capsule chip.
class ImportProgressView extends StatelessWidget {
  /// Header title for the progress phase.
  final String title;

  /// Subtitle explaining current action.
  final String subtitle;

  /// Name of the active file being processed.
  final String fileName;

  /// Progress fraction between 0.0 and 1.0.
  final double progress;

  /// Callback when user chooses to run process in background.
  final VoidCallback onRunInBackground;

  const ImportProgressView({
    super.key,
    required this.title,
    required this.subtitle,
    required this.fileName,
    required this.progress,
    required this.onRunInBackground,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :t, :s, :l) = WidgetVars.of(context);

    return Column(
      children: [
        const Spacer(),

        // Circular progress ring
        SizedBox(
          width: 160,
          height: 160,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(width: 160, height: 160, child: ShapeLoading()),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // Title & Subtitle
        Text(
          title,
          style: t.titleMedium?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: c.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: t.bodySmall?.copyWith(color: c.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),

        // Active File Capsule Chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: c.surfaceContainer,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Symbols.description, size: 16, color: c.onSurfaceVariant),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  fileName,
                  style: t.labelSmall?.copyWith(color: c.onSurfaceVariant),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        // Secondary outline button
        EmbossedButton(
          l.deck_run_in_background,
          onPressed: onRunInBackground,
          type: EmbossedButtonType.outlined,
        ),
      ],
    );
  }
}
