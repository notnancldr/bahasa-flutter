import 'package:bahasa/core/widgets/embossed_button/embossed_button.dart';
import 'package:bahasa/core/widgets/page_header.dart';
import 'package:bahasa/core/widgets/scale_fade_switcher.dart';
import 'package:bahasa/features/login/presentation/bloc/transfer/transfer_state.dart';
import 'package:bahasa/features/login/presentation/widgets/transfer/non_receive/listening_step.dart';
import 'package:bahasa/features/login/presentation/widgets/transfer/non_receive/start_host_step.dart';
import 'package:bahasa/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class NonReceiveStep extends StatelessWidget {
  final TransferState state;

  const NonReceiveStep({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // --- Top section ---
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageHeader(title: "Transfer Profil"),
              SizedBox(height: 8),
              Expanded(
                child: ScaleFadeSwitcher(
                  child: _buildStep(state),
                ),
              ),
            ],
          ),
        ),

        // --- Bottom section ---

        SizedBox(height: 16),

        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            EmbossedButton(
              _labelFor(state, l),
              type: .outlineMuted,
              onPressed: _onPressedFor(context, state),
            ),
            SizedBox(height: 8),
          ],
        ),
      ],
    );
  }

  Widget _buildStep(TransferState state) {
    return switch (state) {
      ListeningState() => ListeningStep(
          key: ValueKey("nonreceive-listening"),
          state: state,
        ),
      StartHostState() => StartHostStep(
          key: ValueKey("nonreceive-starthost"),
          // state: NO STATE,
        ),
      _ => Row(),
    };
  }

  String _labelFor(TransferState state, AppLocalizations l) {
    return switch (state) {
      _ => l.back,
    };
  }

  void Function()? _onPressedFor(BuildContext context, TransferState state) {
    return switch (state) {
      ListeningState() => () {
          if (context.canPop()) {
            context.pop();
          }
        },
      _ => null,
    };
  }
}