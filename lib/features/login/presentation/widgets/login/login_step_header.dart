import 'package:flutter/material.dart';

class LoginStepHeader extends StatelessWidget {
  final String title;
  final String description;

  const LoginStepHeader(
    this.title, {
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 32),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 8),
        Text(
          description,
          style: Theme.of(context).textTheme.labelMedium,
          textAlign: TextAlign.left,
        ),
      ],
    );
  }
}