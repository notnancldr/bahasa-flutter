import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/features/login/presentation/bloc/transfer/transfer_state.dart';
import 'package:bahasa/features/login/presentation/widgets/file_chip.dart';
import 'package:bahasa/features/login/presentation/widgets/transfer/receive/receive_progress_indicator.dart';
import 'package:bahasa/features/login/presentation/widgets/transfer/receive/receive_step_header.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class ReceiveCheckValidStep extends StatelessWidget {
  final CheckValidState state;

  const ReceiveCheckValidStep({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:theme, :l, :c, :t, :s) = WidgetVars.of(context);

    return Column(
      crossAxisAlignment: .center,
      children: [
        ReceiveStepHeader(
          l.transfer_checkValid_title,
          description: l.transfer_checkValid_description,
          name: l.transfer_checkValid_name,
        ),

        SizedBox(height: 32),

        // Progress
        ReceiveProgressIndicator(
          value: null,
          label: l.transfer_checkValid_process,
        ),

        // File details
        SizedBox(height: 24),
        FileChip(fileName: state.fileName),

        Text("${l.process_process}...", style: t.labelLarge),

        SizedBox(height: 32),

        Card.outlined(
          color: s.success.withValues(alpha: .08),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: s.success.withValues(alpha: .35),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Symbols.verified_user,
                    size: 22,
                    color: c.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.transfer_checkValid_info_title,
                        style: t.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l.transfer_checkValid_info_description,
                        style: t.bodySmall?.copyWith(
                          color: c.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
