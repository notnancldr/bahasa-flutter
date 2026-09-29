import 'package:flutter/material.dart';

enum EmbossedButtonType { filled, outlined, outlineMuted }

class EmbossedButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final WidgetStatesController? statesController;
  final EmbossedButtonType type;

  const EmbossedButton(
    this.text, {
    super.key,
    required this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.statesController,
    this.type = EmbossedButtonType.filled,
  });

  bool get _isEnabled => !(statesController?.value.contains(WidgetState.disabled) ?? false)
    && onPressed != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final c = theme.colorScheme;

    final borderRadius = BorderRadius.circular(999);
    final isOutlined = type == EmbossedButtonType.outlined
      || type == EmbossedButtonType.outlineMuted;
    final isOutlineMuted = type == EmbossedButtonType.outlineMuted;

    final Color backgroundColor = !_isEnabled
        ? c.onSurface.withAlpha(31)
        : isOutlined
            ? Colors.transparent
            : c.primaryContainer;

    final Color foregroundColor = !_isEnabled
        ? c.onSurface.withAlpha(97)
        : isOutlined
            ? c.onPrimaryContainer
            : c.onPrimaryContainer;

    final Color shadowColor = !_isEnabled || isOutlined
        ? Colors.transparent
        : c.primaryFixedDim;

    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: isOutlined
            ? Border.all(
                color: isOutlineMuted
                    ? c.outline
                    : _isEnabled
                        ? c.primary
                        : c.onSurface.withAlpha(97),
                width: 2,
              )
            : null,
        boxShadow: _isEnabled
            ? [
                BoxShadow(
                  color: shadowColor,
                  offset: const Offset(0, 2),
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: FilledButton(
        style: ButtonStyle(
          elevation: const WidgetStatePropertyAll(0),
          shadowColor: const WidgetStatePropertyAll(Colors.transparent),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: borderRadius),
          ),
          backgroundColor: WidgetStatePropertyAll(backgroundColor),
          foregroundColor: WidgetStatePropertyAll(foregroundColor),
          overlayColor: WidgetStatePropertyAll(foregroundColor.withAlpha(20)),
          padding: const WidgetStatePropertyAll(EdgeInsets.all(12)),
        ),
        onPressed: _isEnabled ? onPressed : null,
        statesController: statesController,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leadingIcon != null) ...[
              Icon(leadingIcon, color: foregroundColor, size: 18),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(
                color: foregroundColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: 8),
              Icon(trailingIcon, color: foregroundColor, size: 18),
            ],
          ],
        ),
      ),
    );
  }
}