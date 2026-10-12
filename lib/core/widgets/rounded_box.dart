import 'package:flutter/material.dart';

class RoundedBox extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final Color? color;
  final bool useBorder;

  const RoundedBox({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.color,
    this.useBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final c = theme.colorScheme;

    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color ?? c.surfaceBright,
        borderRadius: BorderRadius.circular(16),
        border: useBorder? BoxBorder.all(
          color: c.outline,
        ) : null,
      ),
      child: child,
    );
  }
}