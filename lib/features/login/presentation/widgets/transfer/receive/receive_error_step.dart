import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/features/login/presentation/bloc/transfer/transfer_state.dart';
import 'package:bahasa/features/login/presentation/widgets/transfer/receive/receive_step_header.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class ReceiveErrorStep extends StatelessWidget {
  final TransferErrorState state;

  const ReceiveErrorStep({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :c, :l) = WidgetVars.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ReceiveStepHeader(
          l.transfer_error_invalid_title,
          description: l.transfer_error_invalid_description,
          name: l.transfer_checkValid_name,
        ),

        const SizedBox(height: 48),

        // Layered concentric red alert circles
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: c.error.withValues(alpha: 0.12),
          ),
          alignment: Alignment.center,
          child: Container(
            width: 104,
            height: 104,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: c.error.withValues(alpha: 0.22),
            ),
            alignment: Alignment.center,
            child: Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: c.error.withValues(alpha: 0.8),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Symbols.error,
                size: 38,
                color: Colors.white,
                weight: 700,
              ),
            ),
          ),
        ),

        const SizedBox(height: 54),

        // Clean-up and safety reassurance card
        Card.outlined(
          color: c.surfaceContainerLow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: c.outlineVariant.withValues(alpha: 0.6)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: c.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Symbols.verified_user,
                    size: 20,
                    color: c.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.transfer_error_cleanup_title,
                        style: t.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l.transfer_error_cleanup_description,
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
