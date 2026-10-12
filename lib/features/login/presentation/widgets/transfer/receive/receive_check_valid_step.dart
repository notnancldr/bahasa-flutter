import 'package:bahasa/core/theme/theme_extensions.dart';
import 'package:bahasa/core/widgets/rounded_box.dart';
import 'package:bahasa/core/widgets/rounded_container.dart';
import 'package:bahasa/features/login/presentation/bloc/transfer/transfer_state.dart';
import 'package:bahasa/features/login/presentation/widgets/transfer/receive/receive_progress_indicator.dart';
import 'package:bahasa/features/login/presentation/widgets/transfer/receive/receive_step_header.dart';
import 'package:bahasa/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class ReceiveCheckValidStep extends StatelessWidget {
  final CheckValidState state;

  const ReceiveCheckValidStep({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final l = AppLocalizations.of(context)!;
    final c = theme.colorScheme;
    final t = theme.textTheme;
    final s = theme.extension<AppSemanticColors>()!;

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
        ReceiveProgressIndicator (
          value: null,
          label: l.transfer_checkValid_process,
        ),

        // File details
        SizedBox(height: 24),
        Row(
          mainAxisAlignment: .center,
          children: [
            Column(
              children: [
                RoundedContainer(child: Row(
                  children: [
                    Icon(
                      Symbols.folder_zip,
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Text(
                      state.fileName,
                      style: t.labelSmall,
                    ),
                  ],
                )),
                SizedBox(height: 8),
                Text(
                  "${l.process_process}...",
                  style: t.labelLarge,
                ),
              ],
            ),
          ],
        ),

        SizedBox(height: 32),

        RoundedBox(
          child: Row(
            crossAxisAlignment: .start,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: s.success,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Icon(
                  Symbols.verified_user,
                  color: c.onPrimaryContainer,
                ),
              ),

              SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      l.transfer_checkValid_info_title,
                      style: t.titleSmall,
                    ),
                    Text(
                      l.transfer_checkValid_info_description,
                      style: t.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}