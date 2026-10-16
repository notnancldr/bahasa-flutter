import 'package:flutter/material.dart';

class CircleIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color? backgroundColor;
  final double? size;
  final EdgeInsetsGeometry? padding;

  final bool exactColor;

  const CircleIcon(
    this.icon, {
    super.key,
    required this.color,
    this.backgroundColor,
    this.exactColor = true,
    this.size,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: color);

    return Container(
      padding: padding ?? EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Icon(
        icon,
        color: exactColor ? color : colorScheme.primary,
        size: size,
      ),
    );
  }
}
