import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Top bar notification button on the Home screen.
class HomeNotificationButton extends StatelessWidget {
  /// Callback triggered when notification bell is tapped.
  final VoidCallback? onPressed;

  const HomeNotificationButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        icon: Icon(
          Symbols.notifications,
          size: 26,
          color: theme.colorScheme.onSurface,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
