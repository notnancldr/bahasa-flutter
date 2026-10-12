import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage<T> buildSlideTransitionPage<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
  Offset begin = const Offset(1.0, 0.0), // Default: slide in from right
  Offset end = Offset.zero,
  Curve curve = Curves.easeOutCubic,
  Duration transitionDuration = const Duration(milliseconds: 500),
  Duration reversTransitionDuration = const Duration(milliseconds: 300),
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: transitionDuration,
    reverseTransitionDuration: reversTransitionDuration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween(
        begin: begin,
        end: end,
      ).chain(CurveTween(curve: curve));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}
