import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';

class InBoxDivider extends StatelessWidget {
  const InBoxDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c) = WidgetVars.of(context);

    return Divider(indent: 8, color: c.outline);
  }
}
