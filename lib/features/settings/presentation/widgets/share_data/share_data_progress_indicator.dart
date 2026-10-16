import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class ShareDataProgressIndicator extends StatelessWidget {
  final double size;
  final double iconContainerSize;
  final double strokeWidth;

  const ShareDataProgressIndicator({
    super.key,
    this.size = 160,
    this.iconContainerSize = 54,
    this.strokeWidth = 10,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: strokeWidth,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF5A93B0),
              ),
              backgroundColor: isDark
                  ? const Color(0xFF1E2D38)
                  : const Color(0xFFE2EFF5),
            ),
          ),
          Container(
            width: iconContainerSize,
            height: iconContainerSize,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A262C) : const Color(0xFFF3F9FC),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFA8D5E2), width: 2),
            ),
            child: const Icon(
              Symbols.arrow_downward,
              size: 26,
              color: Color(0xFF5A93B0),
            ),
          ),
        ],
      ),
    );
  }
}
