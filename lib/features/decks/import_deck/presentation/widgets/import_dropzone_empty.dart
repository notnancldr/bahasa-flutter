import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Dashed dropzone container shown when no `.euy` file is selected.
class ImportDropzoneEmpty extends StatelessWidget {
  /// Callback when user taps the pick file button.
  final VoidCallback onPickFile;

  const ImportDropzoneEmpty({super.key, required this.onPickFile});

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :t, :s, :l) = WidgetVars.of(context);

    return CustomPaint(
      painter: _DashedRectPainter(
        color: c.outlineVariant,
        strokeWidth: 1.5,
        dashWidth: 6,
        dashSpace: 4,
        radius: 20,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: c.surfaceContainerLowest,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: c.surfaceContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Symbols.upload_file,
                size: 26,
                color: c.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l.deck_import_empty_title,
              style: t.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: c.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              l.deck_import_empty_format,
              style: t.bodySmall?.copyWith(color: c.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: onPickFile,
              style: OutlinedButton.styleFrom(
                foregroundColor: s.primaryDark,
                side: BorderSide(color: c.primary, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
              ),
              icon: Icon(Symbols.folder_open, size: 18, color: s.primaryDark),
              label: Text(
                l.deck_import_pick_button,
                style: t.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: s.primaryDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double radius;

  _DashedRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius),
        ),
      );

    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final length = (distance + dashWidth < metric.length)
            ? dashWidth
            : metric.length - distance;
        final extract = metric.extractPath(distance, distance + length);
        canvas.drawPath(extract, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRectPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.radius != radius;
  }
}
