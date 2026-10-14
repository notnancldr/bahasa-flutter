import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Card preview displayed once an `.euy` file is selected.
class ImportFileCardSelected extends StatelessWidget {
  /// Name of the chosen file.
  final String fileName;

  /// Human-readable file size string.
  final String fileSizeFormatted;

  /// Callback to replace the chosen file.
  final VoidCallback onChangeFile;

  const ImportFileCardSelected({
    super.key,
    required this.fileName,
    required this.fileSizeFormatted,
    required this.onChangeFile,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :t, :s, :l) = WidgetVars.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.primary, width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: c.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(Symbols.draft, size: 22, color: s.primaryDark),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName,
                      style: t.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: c.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      fileSizeFormatted,
                      style: t.bodySmall?.copyWith(color: c.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 1, thickness: 1, color: c.outlineVariant),
          const SizedBox(height: 10),
          InkWell(
            onTap: onChangeFile,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Symbols.refresh, size: 16, color: s.primaryDark),
                  const SizedBox(width: 6),
                  Text(
                    l.deck_import_change_file,
                    style: t.labelMedium?.copyWith(
                      color: s.primaryDark,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
