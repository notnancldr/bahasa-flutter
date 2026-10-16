import 'package:bahasa/core/widgets/embossed_button/embossed_button_colors.dart';
import 'package:flutter/material.dart';

enum EmbossedButtonType { filled, outlined, outlineMuted }

class EmbossedButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final WidgetStatesController? statesController;
  final EmbossedButtonType type;
  final EmbossedButtonColor color;

  const EmbossedButton(
    this.text, {
    super.key,
    required this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.statesController,
    this.type = EmbossedButtonType.filled,
    this.color = const EmbossedButtonColor(),
  });

  bool get _isEnabled =>
      onPressed != null &&
      !(statesController?.value.contains(WidgetState.disabled) ?? false);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final borderRadius = BorderRadius.circular(999);
    final isOutlineMuted = type == EmbossedButtonType.outlineMuted;
    final isOutlined = isOutlineMuted || type == EmbossedButtonType.outlined;
    final isFilled = !isOutlined;

    final gradient = _isEnabled && isFilled
        ? color.resolveGradient(theme)
        : null;

    final Color backgroundColor;
    if (!_isEnabled) {
      backgroundColor = scheme.onSurface.withAlpha(31);
    } else if (isOutlined || gradient != null) {
      backgroundColor = Colors.transparent;
    } else {
      backgroundColor = color.resolveBackground(theme);
    }

    final foregroundColor = _isEnabled
        ? color.resolveForeground(theme, outlined: isOutlined)
        : scheme.onSurface.withAlpha(97);

    final Color borderColor;
    if (!_isEnabled) {
      borderColor = scheme.onSurface.withAlpha(97);
    } else if (isOutlineMuted) {
      borderColor = scheme.outline;
    } else {
      borderColor = color.resolveBorder(theme);
    }

    final shadowColor = isFilled ? color.resolveShadow(theme) : null;

    return Transform.translate(
      offset: _isEnabled ? const Offset(0, -2) : Offset.zero,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          gradient: gradient,
          border: isOutlined && _isEnabled
              ? Border.all(color: borderColor, width: 2)
              : null,
          boxShadow: _isEnabled && shadowColor != null
              ? [BoxShadow(color: shadowColor, offset: const Offset(0, 2))]
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
              Flexible(
                child: Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: foregroundColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: 8),
                Icon(trailingIcon, color: foregroundColor, size: 18),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
