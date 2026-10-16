import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

/// A circular back button with standard Flutter touch ripple and styling.
class CircleBackButton extends StatelessWidget {
  /// Optional callback when the back button is pressed.
  /// If not provided, it defaults to popping the current route if possible.
  final void Function()? onPressed;

  /// Creates a [CircleBackButton].
  const CircleBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c) = WidgetVars.of(context);
    return IconButton(
      onPressed:
          onPressed ??
          () {
            if (context.canPop()) {
              context.pop();
            }
          },
      icon: const Icon(Symbols.arrow_back, size: 16, weight: 700),
      style: IconButton.styleFrom(
        backgroundColor: c.surfaceContainer,
        side: BorderSide(color: c.outlineVariant),
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(8),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
