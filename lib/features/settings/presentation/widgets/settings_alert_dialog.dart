import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/circle_icon.dart';
import 'package:flutter/material.dart';

class SettingsAlertDialog extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final String title;
  final String message;
  final Widget? content;
  final List<Widget> actions;

  const SettingsAlertDialog({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.title,
    required this.message,
    this.content,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:theme, :c, :t) = WidgetVars.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: c.surfaceBright,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 340),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleIcon(
                icon,
                color: iconColor,
                backgroundColor: iconBackgroundColor,
                size: 28,
                padding: const EdgeInsets.all(14),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: t.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: c.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: t.bodyMedium?.copyWith(
                  color: c.onSurfaceVariant,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              if (content != null) ...[const SizedBox(height: 16), content!],
              const SizedBox(height: 20),
              if (actions.length == 2)
                Row(
                  children: [
                    Expanded(child: actions[0]),
                    const SizedBox(width: 12),
                    Expanded(child: actions[1]),
                  ],
                )
              else
                Column(mainAxisSize: MainAxisSize.min, children: actions),
            ],
          ),
        ),
      ),
    );
  }
}
