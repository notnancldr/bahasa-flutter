import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/circle_icon.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button_colors.dart';
import 'package:bahasa/features/settings/presentation/widgets/share_data/share_data_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class ShareDataTransmittingStep extends StatelessWidget {
  final VoidCallback onCancel;

  const ShareDataTransmittingStep({super.key, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :t, :l) = WidgetVars.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            l.shareData_sending_overline,
            style: const TextStyle(
              color: Color(0xFF9AA3A7),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l.shareData_sending_title,
            style: t.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 22,
              color: c.onSurface,
            ),
          ),
          const Spacer(),

          const ShareDataProgressIndicator(),

          const SizedBox(height: 24),
          Text(
            l.shareData_sending_status,
            textAlign: TextAlign.center,
            style: t.bodyMedium?.copyWith(
              color: c.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),

          // Info card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E2630) : const Color(0xFFF7F9FA),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF2C3847)
                    : const Color(0xFFE6E9EB),
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                const CircleIcon(
                  Symbols.info,
                  color: Color(0xFF5A93B0),
                  backgroundColor: Color(0xFFD6EFF8),
                  size: 18,
                  padding: EdgeInsets.all(6),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l.shareData_sending_note,
                    style: t.bodySmall?.copyWith(
                      color: c.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Cancel Button
          SizedBox(
            width: double.infinity,
            child: EmbossedButton(
              l.cancel,
              type: EmbossedButtonType.outlined,
              color: EmbossedButtonColor(
                border: c.primary,
                foreground: c.primary,
              ),
              onPressed: onCancel,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
