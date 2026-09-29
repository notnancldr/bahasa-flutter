import 'package:flutter/material.dart';

/// Switches between children with a slide + fade:
/// the old child exits to the left, the new one enters from the right.
///
/// The child MUST have a distinct key per "page" (e.g. ValueKey('step-1')),
/// otherwise AnimatedSwitcher can't tell that the child changed.
class SlideFadeSwitcher extends StatelessWidget {
  const SlideFadeSwitcher({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 350),
    this.offset = 0.12,
    this.reverse = false,
    this.alignment = Alignment.topLeft,
  });

  final Widget child;
  final Duration duration;

  /// Horizontal travel as a fraction of the child's width.
  final double offset;

  /// Set to true when navigating backwards (old exits right, new enters from left).
  final bool reverse;

  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    final dx = reverse ? -offset : offset;

    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          alignment: alignment,
          children: [
            ...previousChildren,
            ?currentChild,
          ],
        );
      },
      transitionBuilder: (transitionChild, animation) {
        final isIncoming = transitionChild.key == child.key;

        // Outgoing children run their animation 1 -> 0, so `begin` is where
        // they end up: the opposite side from where the new child starts.
        final slide = Tween<Offset>(
          begin: Offset(isIncoming ? dx : -dx, 0),
          end: Offset.zero,
        ).animate(animation);

        return ClipRect(
          child: SlideTransition(
            position: slide,
            child: FadeTransition(opacity: animation, child: transitionChild),
          ),
        );
      },
      child: child,
    );
  }
}