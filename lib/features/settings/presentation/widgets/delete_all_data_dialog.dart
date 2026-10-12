import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button_colors.dart';
import 'package:bahasa/features/settings/presentation/widgets/settings_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class DeleteAllDataDialog extends StatefulWidget {
  final String expectedUsername;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const DeleteAllDataDialog({
    super.key,
    required this.expectedUsername,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  State<DeleteAllDataDialog> createState() => _DeleteAllDataDialogState();
}

class _DeleteAllDataDialogState extends State<DeleteAllDataDialog> {
  late final TextEditingController _controller;
  bool _canDelete = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final matches = _controller.text.trim() == widget.expectedUsername.trim();
    if (matches != _canDelete) {
      setState(() {
        _canDelete = matches;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :t, :l) = WidgetVars.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SettingsAlertDialog(
      icon: Symbols.priority_high,
      iconColor: const Color(0xFFC62828),
      iconBackgroundColor: isDark
          ? const Color(0xFF381E1E)
          : const Color(0xFFFDE8E8),
      title: l.deleteData_dialog_title,
      message: l.deleteData_dialog_body,
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Ketik "${widget.expectedUsername}"...',
          hintStyle: t.bodyMedium?.copyWith(
            color: c.onSurfaceVariant.withAlpha(150),
          ),
          filled: true,
          fillColor: c.surfaceContainer,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
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
      actions: [
        EmbossedButton(
          l.cancel,
          type: EmbossedButtonType.outlined,
          color: EmbossedButtonColor(border: c.primary, foreground: c.primary),
          onPressed: widget.onCancel,
        ),
        EmbossedButton(
          l.deleteData_dialog_confirmButton,
          type: EmbossedButtonType.filled,
          color: const EmbossedButtonColor(
            background: Color(0xFFD26B6B),
            foreground: Colors.white,
            shadow: Color(0xFFB34242),
          ),
          onPressed: _canDelete ? widget.onConfirm : null,
        ),
      ],
    );
  }
}
