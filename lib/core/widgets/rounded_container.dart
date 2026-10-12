import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final Color? color;
  final bool useBorder;
  final bool textContent;

  const RoundedContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.color,
    this.useBorder = false,
    this.textContent = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final c = theme.colorScheme;

    return Container(
      width: width,
      height: height,
      padding: textContent
        ? EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0)
        : EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: color ?? c.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: useBorder? BoxBorder.all(
          color: c.outline,
        ) : null,
      ),
      child: child,
    );
  }
}