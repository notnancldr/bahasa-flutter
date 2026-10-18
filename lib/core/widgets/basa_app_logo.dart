import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Reusable BASA application logo displaying `icon - basa app.svg`.
class BasaAppLogo extends StatelessWidget {
  /// Size (width and height) of the logo badge.
  final double size;

  /// Optional border radius (defaults to 16).
  final double borderRadius;

  /// Creates a [BasaAppLogo].
  const BasaAppLogo({
    super.key,
    this.size = 64,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SvgPicture.asset(
        'lib/core/assets/icon - basa app.svg',
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}
