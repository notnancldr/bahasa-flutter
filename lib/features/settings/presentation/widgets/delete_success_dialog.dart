import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button_colors.dart';
import 'package:bahasa/features/settings/presentation/widgets/settings_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class DeleteSuccessDialog extends StatelessWidget {
  final VoidCallback onGoHome;

  const DeleteSuccessDialog({super.key, required this.onGoHome});

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :l) = WidgetVars.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SettingsAlertDialog(
      icon: Symbols.check,
      iconColor: const Color(0xFF4A8A5A),
      iconBackgroundColor: isDark
          ? const Color(0xFF1E2D22)
          : const Color(0xFFE8F3EA),
      title: l.deleteData_success_title,
      message: l.deleteData_success_body,
      actions: [
        SizedBox(
          width: double.infinity,
          child: EmbossedButton(
            l.deleteData_success_homeButton,
            type: EmbossedButtonType.filled,
            color: const EmbossedButtonColor(
              background: Color(0xFFA8D5A2),
              foreground: Colors.white,
              shadow: Color(0xFF75B36D),
            ),
            onPressed: onGoHome,
          ),
        ),
      ],
    );
  }
}
