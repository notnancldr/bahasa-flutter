import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class FileChip extends StatelessWidget {
  final String fileName;

  const FileChip({super.key, required this.fileName});

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :t) = WidgetVars.of(context);

    return Chip(
      avatar: Icon(Symbols.folder, size: 16, color: c.onSurface),
      label: Text(
        fileName,
        style: t.labelSmall?.copyWith(fontWeight: FontWeight.w600),
      ),
      backgroundColor: c.surfaceContainer,
      side: BorderSide.none,
      shape: const StadiumBorder(),
      visualDensity: VisualDensity.compact,
    );
  }
}
