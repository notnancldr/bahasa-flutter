import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WaitingDots extends StatelessWidget {
  const WaitingDots({
    super.key,
    required this.color,
    this.count = 3,
    this.dotSize = 8,
    this.spacing = 8,
    this.pulseDuration = const Duration(milliseconds: 600),
    this.stagger = const Duration(milliseconds: 200),
  });

  final Color color;
  final int count;
  final double dotSize;
  final double spacing;
  final Duration pulseDuration;
  final Duration stagger;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < count; i++) ...[
          if (i > 0) SizedBox(width: spacing),
          Container(
                key: ValueKey('waiting-$i'),
                width: dotSize,
                height: dotSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: color,
                ),
              )
              .animate(
                delay: stagger * i,
                onPlay: (controller) => controller.repeat(reverse: true),
              )
              .scale(
                begin: const Offset(0.6, 0.6),
                end: const Offset(1, 1),
                duration: pulseDuration,
                curve: Curves.easeInOut,
              )
              .fade(
                begin: 0.4,
                end: 1,
                duration: pulseDuration,
                curve: Curves.easeInOut,
              ),
        ],
      ],
    );
  }
}
