import 'package:flutter/material.dart';

/// Flame icon widget rendered in vibrant colors or grayscale (when streak is 0).
class FlameIcon extends StatelessWidget {
  /// The current streak count. When 0 or inactive, the flame is rendered in muted gray.
  final int streakCount;

  /// The size (both width and height) of the flame icon.
  final double size;

  const FlameIcon({super.key, required this.streakCount, this.size = 180});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isInactive = streakCount <= 0;

    return CustomPaint(
      size: Size(size, size * 1.3),
      painter: _FlamePainter(isInactive: isInactive, isDark: isDark),
    );
  }
}

class _FlamePainter extends CustomPainter {
  final bool isInactive;
  final bool isDark;

  _FlamePainter({required this.isInactive, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Inactive flame colors matching the empty state screenshot
    final outerInactive = isDark
        ? const Color(0xFF333E44)
        : const Color(0xFFECECEC);
    final innerInactive = isDark
        ? const Color(0xFF252D32)
        : const Color(0xFFDEDFE1);

    // Active flame colors matching the active state screenshot
    const outerActive = Color(0xFFFF6400); // Vibrant orange
    const innerActive = Color(0xFFFFDE00); // Bright gold/yellow

    final outerColor = isInactive ? outerInactive : outerActive;
    final innerColor = isInactive ? innerInactive : innerActive;

    // Draw Outer Flame
    final outerPath = Path();
    outerPath.moveTo(w * 0.44, 0);
    outerPath.cubicTo(
      w * 0.48,
      h * 0.12,
      w * 0.58,
      h * 0.22,
      w * 0.68,
      h * 0.26,
    );
    outerPath.cubicTo(
      w * 0.60,
      h * 0.32,
      w * 0.58,
      h * 0.38,
      w * 0.60,
      h * 0.45,
    );
    outerPath.cubicTo(
      w * 0.65,
      h * 0.40,
      w * 0.70,
      h * 0.38,
      w * 0.76,
      h * 0.38,
    );
    outerPath.cubicTo(
      w * 0.88,
      h * 0.50,
      w * 0.88,
      h * 0.68,
      w * 0.80,
      h * 0.80,
    );
    outerPath.cubicTo(
      w * 0.68,
      h * 0.98,
      w * 0.32,
      h * 0.98,
      w * 0.20,
      h * 0.80,
    );
    outerPath.cubicTo(
      w * 0.12,
      h * 0.68,
      w * 0.16,
      h * 0.50,
      w * 0.28,
      h * 0.38,
    );
    outerPath.cubicTo(
      w * 0.35,
      h * 0.42,
      w * 0.40,
      h * 0.40,
      w * 0.42,
      h * 0.34,
    );
    outerPath.cubicTo(w * 0.30, h * 0.28, w * 0.32, h * 0.12, w * 0.44, 0);
    outerPath.close();

    final outerPaint = Paint()
      ..color = outerColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.drawPath(outerPath, outerPaint);

    // Draw Inner Flame
    final innerPath = Path();
    innerPath.moveTo(w * 0.50, h * 0.40);
    innerPath.cubicTo(
      w * 0.56,
      h * 0.50,
      w * 0.65,
      h * 0.60,
      w * 0.63,
      h * 0.72,
    );
    innerPath.cubicTo(
      w * 0.62,
      h * 0.84,
      w * 0.38,
      h * 0.84,
      w * 0.37,
      h * 0.72,
    );
    innerPath.cubicTo(
      w * 0.35,
      h * 0.60,
      w * 0.45,
      h * 0.50,
      w * 0.50,
      h * 0.40,
    );
    innerPath.close();

    final innerPaint = Paint()
      ..color = innerColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.drawPath(innerPath, innerPaint);
  }

  @override
  bool shouldRepaint(covariant _FlamePainter oldDelegate) {
    return oldDelegate.isInactive != isInactive || oldDelegate.isDark != isDark;
  }
}
