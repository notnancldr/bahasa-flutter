import 'package:bahasa/features/login/presentation/bloc/transfer/transfer_state.dart';
import 'package:bahasa/features/login/presentation/widgets/file_chip.dart';
import 'package:bahasa/features/login/presentation/widgets/transfer/receive/receive_progress_indicator.dart';
import 'package:bahasa/features/login/presentation/widgets/transfer/receive/receive_step_header.dart';
import 'package:bahasa/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ReceiveMainStep extends StatelessWidget {
  final ReceiveState state;

  const ReceiveMainStep({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final l = AppLocalizations.of(context)!;
    final t = theme.textTheme;

    final progressValue = state.fileSize != null
        ? state.progress / state.fileSize!
        : null;

    return Column(
      crossAxisAlignment: .center,
      children: [
        ReceiveStepHeader(
          l.transfer_receive_title,
          description: l.transfer_receive_description,
          name: l.transfer_receive_name,
        ),

        SizedBox(height: 32),

        // Progress
        ReceiveProgressIndicator(
          value: progressValue,
          label: l.transfer_receive_process,
        ),

        // File details
        SizedBox(height: 24),
        Row(
          mainAxisAlignment: .center,
          children: [
            Column(
              children: [
                FileChip(fileName: state.fileName),
                SizedBox(height: 8),
                Text(_progressReadable(), style: t.labelLarge),
              ],
            ),
          ],
        ),
      ],
    );
  }

  String _bytesToReadable(int bytes) {
    final units = ["bytes", "KB", "MB", "GB"];
    double value = bytes.toDouble();
    int currentUnit = 0;

    while (value >= 1000 && (currentUnit + 1) < units.length) {
      currentUnit++;
      value = value / 1000;
    }

    return "${value.toStringAsFixed(1)} ${units[currentUnit]}";
  }

  String _progressReadable() {
    if (state.fileSize == null) {
      return _bytesToReadable(state.progress);
    }
    return "${_bytesToReadable(state.progress)} / ${_bytesToReadable(state.fileSize!)}";
  }
}
