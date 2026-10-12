import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';

class InfoChip extends StatelessWidget {
  final String text;
  final IconData? leading;

  const InfoChip({super.key, required this.text, this.leading});

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :t) = WidgetVars.of(context);

    return Chip(
      avatar: leading != null
          ? Icon(leading, size: 16, color: c.onSurface)
          : null,
      label: Text(
        text,
        style: t.labelSmall?.copyWith(fontWeight: FontWeight.w600),
      ),
      backgroundColor: c.surfaceContainer,
      side: BorderSide.none,
      shape: const StadiumBorder(),
      visualDensity: VisualDensity.compact,
    );
  }
}
