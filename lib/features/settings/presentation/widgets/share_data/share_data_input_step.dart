import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button.dart';
import 'package:bahasa/core/widgets/page_header.dart';
import 'package:bahasa/features/settings/presentation/widgets/share_data/qr_scanner_modal.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class ShareDataInputStep extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onStartTransfer;

  const ShareDataInputStep({
    super.key,
    required this.controller,
    required this.onStartTransfer,
  });

  Future<void> _handleScanQr(BuildContext context) async {
    final scanned = await QrScannerModal.show(context);
    if (scanned != null && scanned.trim().isNotEmpty) {
      controller.text = scanned.trim();
    }
  }

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :t, :l) = WidgetVars.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PageHeader(title: l.settings_title),
                const SizedBox(height: 24),
                Text(
                  l.shareData_title,
                  style: t.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                    color: c.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l.shareData_subtitle,
                  style: t.bodyMedium?.copyWith(
                    color: c.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  l.shareData_ipLabel,
                  style: t.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: c.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: l.shareData_ipPlaceholder,
                    filled: true,
                    fillColor: isDark ? const Color(0xFF1E2630) : Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: c.outline, width: 1.2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: c.outline, width: 1.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: c.primary, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: c.outlineVariant, height: 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        l.shareData_or,
                        style: t.bodySmall?.copyWith(
                          color: c.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: c.outlineVariant, height: 1),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: EmbossedButton(
                    l.shareData_scanQrButton,
                    type: EmbossedButtonType.outlined,
                    leadingIcon: Symbols.qr_code_scanner,
                    onPressed: () => _handleScanQr(context),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom Start Button
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
          child: SizedBox(
            width: double.infinity,
            child: EmbossedButton(
              l.shareData_startButton,
              type: EmbossedButtonType.filled,
              onPressed: onStartTransfer,
            ),
          ),
        ),
      ],
    );
  }
}
