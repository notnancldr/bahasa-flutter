import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';

/// Reusable selectable card tile with themed borders, background,
/// leading widget, title, subtitle, and an animated selection indicator.
class CustomOption extends StatelessWidget {
  final bool selected;
  final VoidCallback? onTap;
  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final Color? selectedColor;
  final Color? unselectedColor;
  final BoxBorder? selectedBorder;
  final BoxBorder? unselectedBorder;

  const CustomOption({
    super.key,
    required this.selected,
    this.onTap,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.selectedColor,
    this.unselectedColor,
    this.selectedBorder,
    this.unselectedBorder,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :s) = WidgetVars.of(context);

    final resolvedColor = selected
        ? (selectedColor ?? c.primary.withValues(alpha: 0.75))
        : (unselectedColor ?? c.surface);

    final resolvedBorder = selected
        ? (selectedBorder ?? Border.all(color: s.primaryDark, width: 2))
        : (unselectedBorder ?? Border.all(color: c.outline, width: 2));

    return FilledButton(
      // borderRadius: borderRadius,
      onPressed: onTap,
      style: ButtonStyle(
        elevation: WidgetStatePropertyAll(0),
        backgroundColor: WidgetStatePropertyAll(resolvedColor),
        overlayColor: WidgetStateProperty.fromMap({
          WidgetState.hovered: c.inverseSurface.withAlpha(10),
        }),
        padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: borderRadius,
            side: resolvedBorder.top,
          ),
        ),
      ),
      child: Container(
        padding: padding,
        child: Row(
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 14)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [title, ?subtitle],
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: 14), trailing!],
          ],
        ),
      ),
    );
  }
}
