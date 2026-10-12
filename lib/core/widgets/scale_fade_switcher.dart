import 'package:flutter/material.dart';

class ScaleFadeSwitcher extends StatelessWidget {
  const ScaleFadeSwitcher({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
    this.minScale = 0.8,
  });

  /// Give each distinct child its own [Key] (e.g. ValueKey(state)).
  final Widget child;

  /// Total time for the whole sequence (out + blank + in).
  final Duration duration;

  final double minScale;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      // Forward: invisible for the first half, animates in during the second half.
      switchInCurve: const Interval(0.5, 1.0, curve: Curves.easeOutCubic),
      // Reverse: the controller runs 1 -> 0, so the value drops to 0 while
      // the controller goes 1 -> 0.5 (the first half of the time), then stays 0.
      switchOutCurve: const Interval(0.5, 1.0, curve: Curves.easeInCubic),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: minScale, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
      // Avoid the default Stack layout, which isn't needed when only one
      // child is visible at a time.
      layoutBuilder: (currentChild, previousChildren) => Stack(
        alignment: Alignment.topCenter,
        children: [...previousChildren, ?currentChild],
      ),
      child: child,
    );
  }
}
