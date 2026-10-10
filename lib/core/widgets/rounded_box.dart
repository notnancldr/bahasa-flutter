import 'package:bahasa/core/widgets/rounded_container.dart';
import 'package:flutter/material.dart';

class RoundedBox extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final Color? color;
  final bool useBorder;

  const RoundedBox({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.color,
    this.useBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return RoundedContainer.box(
      width: width,
      height: height,
      color: color,
      useBorder: useBorder,
      child: child,
    );
  }
}
