import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/circle_icon.dart';
import 'package:bahasa/core/widgets/in_box_divider.dart';
import 'package:bahasa/features/login/presentation/bloc/transfer/transfer_state.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class ReceiveCompleteStep extends StatelessWidget {
  final TransferCompleteState state;

  const ReceiveCompleteStep({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:theme, :c, :t, :s, :l) = WidgetVars.of(context);

    return Column(
      crossAxisAlignment: .center,
      children: [
        Padding(
          padding: const EdgeInsets.all(32),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: s.success.withAlpha(50),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: s.success.withAlpha(50),
                borderRadius: BorderRadius.circular(999),
                border: BoxBorder.all(width: 1, color: s.success),
                boxShadow: [
                  BoxShadow(blurRadius: 16, color: s.success.withAlpha(60)),
                ],
              ),
              child: Icon(
                Symbols.check,
                size: 48,
                weight: 800,
                color: c.onPrimaryContainer,
              ),
            ),
          ),
        ),
        Text(
          l.transfer_complete_title,
          style: t.titleLarge,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          l.transfer_complete_description,
          style: t.labelLarge,
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 32),

        Card.outlined(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleIcon(
                      Symbols.description,
                      color: s.info,
                      exactColor: false,
                      size: 18,
                    ),
                    SizedBox(width: 16),
                    Text(
                      l.transfer_complete_profileInfo_title,
                      style: t.titleMedium,
                    ),
                  ],
                ),

                SizedBox(height: 12),

                InBoxDivider(),

                SizedBox(height: 12),

                _ProfileInfoItem(
                  icon: Symbols.calendar_month,
                  color: c.secondary,
                  title: l.joinSince,
                  content: "Dummy", // TODO: Real data
                ),

                _ProfileInfoItem(
                  icon: Symbols.person,
                  color: s.success,
                  title: l.username,
                  content: "Dummy", // TODO: Real data
                ),

                _ProfileInfoItem(
                  icon: Symbols.language,
                  color: c.tertiary,
                  title: l.defaultLanguage,
                  content: "Dummy", // TODO: Real data
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileInfoItem extends StatelessWidget {
  final IconData icon;
  final Color color;

  final String title;
  final String content;

  const _ProfileInfoItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t) = WidgetVars.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleIcon(icon, color: color, exactColor: false),

          SizedBox(width: 16),

          Column(
            crossAxisAlignment: .start,
            children: [
              Text(title, style: t.labelMedium),
              Text(content, style: t.titleSmall),
            ],
          ),
        ],
      ),
    );
  }
}
