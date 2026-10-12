import 'package:bahasa/core/widgets/embossed_button/embossed_button.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button_colors.dart';
import 'package:bahasa/core/widgets/page_header.dart';
import 'package:bahasa/core/widgets/scale_fade_switcher.dart';
import 'package:bahasa/features/login/presentation/bloc/transfer/transfer_bloc.dart';
import 'package:bahasa/features/login/presentation/bloc/transfer/transfer_event.dart';
import 'package:bahasa/features/login/presentation/bloc/transfer/transfer_state.dart';
import 'package:bahasa/features/login/presentation/widgets/transfer/receive/receive_check_valid_step.dart';
import 'package:bahasa/features/login/presentation/widgets/transfer/receive/receive_complete_step.dart';
import 'package:bahasa/features/login/presentation/widgets/transfer/receive/receive_main_step.dart';
import 'package:bahasa/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class ReceiveStep extends StatelessWidget {
  final TransferState state;

  const ReceiveStep({
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
          child: ScaleFadeSwitcher(
            child: _buildStep(state),
          ),
        ),

        // --- Bottom section ---

        SizedBox(height: 16),

        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buttonFor(context, state),
            SizedBox(height: 8),
          ],
        ),
      ],
    );
  }

  Widget _buildStep(TransferState state) {
    
    return switch (state) {
      ReceiveState() => ReceiveMainStep(
          key: ValueKey("receive-main-step"),
          state: state,
        ),
      CheckValidState() => ReceiveCheckValidStep(
          key: ValueKey("receive-check-valid-step"),
          state: state,
        ),
      TransferCompleteState() => ReceiveCompleteStep(
          key: ValueKey("receive-complete-step"),
          state: state,
        ),
      _ => Row(),
    };
  }

  EmbossedButton _buttonFor(BuildContext context, TransferState state) {
    final l = AppLocalizations.of(context)!;

    return switch (state) {
      ReceiveState() || CheckValidState() => EmbossedButton(
        l.cancel,
        type: .outlined,
        color: EmbossedButtonErrorColor(),
        leadingIcon: Symbols.close,
        onPressed: () {
          context.read<TransferBloc>().add(CancelTransfer());
        },
      ),
      TransferCompleteState() => EmbossedButton(
        l.done,
        onPressed: () {
          context.read<TransferBloc>().add(CancelTransfer());
        },
      ),
      _ => EmbossedButton(
        l.back,
        type: .outlineMuted,
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          }
        },
      ),
    };
  }

  String _labelFor(TransferState state, AppLocalizations l) {
    return switch (state) {
      _ => l.cancel,
    };
  }

  IconData? _iconFor(TransferState state) {
    return switch (state) {
      ReceiveState() => Symbols.close,
      _ => null,
    };
  }

  void Function()? _onPressedFor(BuildContext context, TransferState state) {
    return switch (state) {
      ReceiveState() => () {
          if (context.canPop()) {
            context.pop();
          }
        },
      _ => null,
    };
  }
}