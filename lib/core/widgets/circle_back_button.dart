import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class CircleBackButton extends StatelessWidget {
  final void Function()? onPressed;

  const CircleBackButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final c = theme.colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onPressed ?? () {
        if (context.canPop()) {
          context.pop();
        }
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: c.surfaceContainer,
          border: BoxBorder.all(
            color: c.outlineVariant,
          ),
        ),
        child: Icon(
          Symbols.arrow_back,
          size: 16,
          weight: 700,
        ),
      ),
    );
  }
}