import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';

class ReceiveStepHeader extends StatelessWidget {
  final String title;
  final String description;
  final String name;

  const ReceiveStepHeader(
    this.title, {
    super.key,
    required this.description,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :c) = WidgetVars.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 16),
        Card.filled(
          color: c.surfaceContainer,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Text(name, style: t.labelMedium),
          ),
        ),

        SizedBox(height: 54),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: .center,
        ),
        SizedBox(height: 8),
        Text(
          description,
          style: Theme.of(context).textTheme.labelMedium,
          textAlign: .center,
        ),
      ],
    );
  }
}
