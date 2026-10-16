import 'package:bahasa/core/widgets/info_chip.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 16),
        InfoChip(text: name),

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
