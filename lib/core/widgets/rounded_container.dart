import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';

enum RoundedContainerVariant {
  /// Uses surfaceContainer color with 8px padding (or 4x8px for text content)
  container,

  /// Uses surfaceBright color with 16px padding and border by default
  box,
}

class RoundedContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final Color? color;
  final bool? useBorder;
  final bool textContent;
  final EdgeInsetsGeometry? padding;
  final RoundedContainerVariant variant;

  const RoundedContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.color,
    this.useBorder,
    this.textContent = false,
    this.padding,
    this.variant = RoundedContainerVariant.container,
  });

  const RoundedContainer.box({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.color,
    this.useBorder = true,
    this.textContent = false,
    this.padding,
    this.variant = RoundedContainerVariant.box,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c) = WidgetVars.of(context);

    final resolvedPadding =
        padding ??
        (variant == RoundedContainerVariant.box
            ? const EdgeInsets.all(16.0)
            : textContent
            ? const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0)
            : const EdgeInsets.all(8.0));

    final effectiveUseBorder =
        useBorder ?? (variant == RoundedContainerVariant.box);

    final defaultColor = variant == RoundedContainerVariant.box
        ? c.surfaceBright
        : c.surfaceContainer;

    return Container(
      width: width,
      height: height,
      padding: resolvedPadding,
      decoration: BoxDecoration(
        color: color ?? defaultColor,
        borderRadius: BorderRadius.circular(16),
        border: effectiveUseBorder ? BoxBorder.all(color: c.outline) : null,
      ),
      child: child,
    );
  }
}
