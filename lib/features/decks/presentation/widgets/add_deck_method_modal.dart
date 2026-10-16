import 'package:bahasa/core/theme/app_colors.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Modal bottom sheet allowing users to choose between generating a deck
/// with AI or importing an existing `.euy` deck file.
class AddDeckMethodModal extends StatelessWidget {
  /// Callback when "Generate Deck" card is tapped.
  final VoidCallback onSelectGenerate;

  /// Callback when "Impor Deck" card is tapped.
  final VoidCallback onSelectImport;

  const AddDeckMethodModal({
    super.key,
    required this.onSelectGenerate,
    required this.onSelectImport,
  });

  /// Displays the [AddDeckMethodModal] as a bottom sheet.
  static Future<void> show(
    BuildContext context, {
    required VoidCallback onSelectGenerate,
    required VoidCallback onSelectImport,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (_) => AddDeckMethodModal(
        onSelectGenerate: onSelectGenerate,
        onSelectImport: onSelectImport,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :t, :l) = WidgetVars.of(context);

    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: c.outlineVariant,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Title & Subtitle
          Text(
            l.deck_method_title,
            style: t.titleMedium?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: c.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l.deck_method_subtitle,
            style: t.bodyMedium?.copyWith(color: c.onSurfaceVariant),
          ),
          const SizedBox(height: 20),

          // Option 1: Generate Deck
          _MethodStackedCard(
            badgeColor: AppColors.secondary,
            iconColor: const Color(0xFF7C2D12),
            icon: Symbols.auto_awesome,
            title: l.deck_method_generate_title,
            subtitle: l.deck_method_generate_subtitle,
            ctaLabel: l.deck_method_generate_cta,
            onPressed: () {
              Navigator.of(context).pop();
              onSelectGenerate();
            },
          ),
          const SizedBox(height: 16),

          // Option 2: Import Deck
          _MethodStackedCard(
            badgeColor: AppColors.tertiary,
            iconColor: const Color(0xFF5B21B6),
            icon: Symbols.folder,
            title: l.deck_method_import_title,
            subtitle: l.deck_method_import_subtitle,
            ctaLabel: l.deck_method_import_cta,
            onPressed: () {
              Navigator.of(context).pop();
              onSelectImport();
            },
          ),
        ],
      ),
    );
  }
}

class _MethodStackedCard extends StatelessWidget {
  final Color badgeColor;
  final Color iconColor;
  final IconData icon;
  final String title;
  final String subtitle;
  final String ctaLabel;
  final VoidCallback onPressed;

  const _MethodStackedCard({
    required this.badgeColor,
    required this.iconColor,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.ctaLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :t) = WidgetVars.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: t.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: c.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: t.bodySmall?.copyWith(color: c.onSurfaceVariant),
          ),
          const SizedBox(height: 18),
          EmbossedButton(
            ctaLabel,
            onPressed: onPressed,
            trailingIcon: Symbols.arrow_forward,
          ),
        ],
      ),
    );
  }
}
