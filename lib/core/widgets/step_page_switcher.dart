import 'package:bahasa/core/widgets/slide_fade_switcher.dart';
import 'package:flutter/material.dart';

/// Direction-aware page switcher for multi-step flows.
///
/// Automatically tracks changes to [currentStep] and slides backward
/// (old exits right, new enters left) when [currentStep] decreases, or
/// forward when [currentStep] increases.
///
/// The [child] must have a distinct key per step (e.g. ValueKey('step-1')),
/// enabling AnimatedSwitcher to detect the transition.
class StepPageSwitcher extends StatefulWidget {
  final int currentStep;
  final Widget child;
  final Duration duration;
  final double offset;
  final AlignmentGeometry alignment;

  const StepPageSwitcher({
    super.key,
    required this.currentStep,
    required this.child,
    this.duration = const Duration(milliseconds: 350),
    this.offset = 0.12,
    this.alignment = Alignment.topLeft,
  });

  @override
  State<StepPageSwitcher> createState() => _StepPageSwitcherState();
}

class _StepPageSwitcherState extends State<StepPageSwitcher> {
  bool _reverse = false;

  @override
  void didUpdateWidget(covariant StepPageSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentStep != oldWidget.currentStep) {
      _reverse = widget.currentStep < oldWidget.currentStep;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideFadeSwitcher(
      reverse: _reverse,
      duration: widget.duration,
      offset: widget.offset,
      alignment: widget.alignment,
      child: widget.child,
    );
  }
}
