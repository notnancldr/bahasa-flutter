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
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :s) = WidgetVars.of(context);

    return InkWell(
      borderRadius: borderRadius,
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: selected
              ? c.primary.withValues(alpha: 0.75)
              : c.surface,
          border: Border.all(
            color: selected
                ? s.primaryDark
                : c.outline,
            width: 2,
          ),
        ),
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
          ],
        ),
      ),
    );
  }
}