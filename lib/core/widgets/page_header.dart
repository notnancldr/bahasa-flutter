import 'package:bahasa/core/utils/widget_var.dart';
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
    final WidgetVars(:theme, :t) = WidgetVars.of(context);

    return Row(
      children: [
        const CircleBackButton(),
        Expanded(
          child: Text(title, style: t.bodyLarge, textAlign: TextAlign.center),
        ),
        const SizedBox(width: 34),
      ],
    );
  }
}
