import 'dart:math' as math;

import 'package:bahasa/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class ReceiveProgressIndicator extends StatelessWidget {
  /// 0.0 - 1.0, or null for an indeterminate (unknown size) indicator.
  final double? value;
  final String label;
  final double size;
  final double strokeWidth;
  final Duration duration;
  final Curve curve;

  const ReceiveProgressIndicator({
    super.key,
    required this.value,
    required this.label,
    this.size = 156,
    this.strokeWidth = 10,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    final target = value;

    // Unknown total size: nothing to tween, show indeterminate ring.
    if (target == null) {
      return _buildBody(context, null);
    }

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: target.clamp(0.0, 1.0)),
      duration: duration,
      curve: curve,
      builder: (context, animated, _) => _buildBody(context, animated),
    );
  }

  Widget _buildBody(BuildContext context, double? animatedValue) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    final s = theme.extension<AppSemanticColors>()!;
    final t = theme.textTheme;

    final percentage = animatedValue != null
        ? (animatedValue * 100).round()
        : null;

    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        children: [
          SizedBox(
            height: size,
            width: size,
            child: animatedValue == null
                ? CircularProgressIndicator(
                    strokeWidth: strokeWidth,
                    strokeCap: StrokeCap.round,
                    color: c.primary,
                    backgroundColor: c.surfaceContainer,
                  )
                : CustomPaint(
                    painter: _GradientRingPainter(
                      progress: animatedValue,
                      strokeWidth: strokeWidth,
                      startColor: s.primaryDark,
                      endColor: c.primary,
                      trackColor: c.surfaceContainer,
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: .stretch,
              mainAxisAlignment: .center,
              children: [
                Row(
                  mainAxisAlignment: .center,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: c.surfaceContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Symbols.download,
                        size: 24,
                        color: c.primaryFixedDim,
                      ),
                    ),
                  ],
                ),
                if (percentage != null)
                  Text(
                    "$percentage%",
                    textAlign: .center,
                    style: const TextStyle(fontSize: 26, fontWeight: .w800),
                  ),
                Text(label, style: t.labelSmall, textAlign: .center),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientRingPainter extends CustomPainter {
  final double progress; // 0.0 - 1.0
  final double strokeWidth;
  final Color startColor;
  final Color endColor;
  final Color trackColor;

  _GradientRingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.startColor,
    required this.endColor,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final arcRect = rect.deflate(strokeWidth / 2);

    // Track
    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = trackColor;
    canvas.drawArc(arcRect, 0, math.pi * 2, false, trackPaint);

    final sweep = math.pi * 2 * progress;
    if (sweep <= 0.001) return;

    // Gradient spans only the filled arc, so the tip is always endColor.
    // Sweep gradients start at 3 o'clock, so rotate -90deg to start at the top.
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      // ..shader = SweepGradient(
      //   startAngle: 0,
      //   endAngle: math.pi * 2,
      //   colors: [startColor, endColor, endColor, startColor],
      //   stops: [0, 0.5, 0.99, 1],
      //   transform: const GradientRotation(-math.pi / 2),
      // ).createShader(rect);
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: math.pi * 2,
        colors: [startColor, endColor, startColor],
        stops: [0, progress, 1],
        transform: const GradientRotation(-math.pi / 2),
      ).createShader(rect);

    canvas.drawArc(arcRect, -math.pi / 2, sweep, false, progressPaint);
  }

  @override
  bool shouldRepaint(_GradientRingPainter old) =>
      old.progress != progress ||
      old.strokeWidth != strokeWidth ||
      old.startColor != startColor ||
      old.endColor != endColor ||
      old.trackColor != trackColor;
}
