import 'package:bahasa/core/widgets/circle_back_button.dart';
import 'package:flutter/material.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final bool showBackButton;

  const PageHeader({
    super.key,
    required this.title,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final t = theme.textTheme;

    return Row(
      children: [
        CircleBackButton(),
        Expanded(
          child: Text(title, style: t.bodyLarge, textAlign: TextAlign.center)
        ),
        SizedBox(width: 34),
      ],
    );
  }
}