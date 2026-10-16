import 'package:bahasa/core/widgets/embossed_button/embossed_button.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button_colors.dart';
import 'package:bahasa/core/widgets/scale_fade_switcher.dart';
import 'package:bahasa/features/login/presentation/bloc/transfer/transfer_bloc.dart';
import 'package:bahasa/features/login/presentation/bloc/transfer/transfer_event.dart';
import 'package:bahasa/features/login/presentation/bloc/transfer/transfer_state.dart';
import 'package:bahasa/features/login/presentation/widgets/transfer/receive/receive_check_valid_step.dart';
import 'package:bahasa/features/login/presentation/widgets/transfer/receive/receive_complete_step.dart';
import 'package:bahasa/features/login/presentation/widgets/transfer/receive/receive_error_step.dart';
import 'package:bahasa/features/login/presentation/widgets/transfer/receive/receive_main_step.dart';
import 'package:bahasa/core/router/app_routes.dart';
import 'package:bahasa/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class ReceiveStep extends StatelessWidget {
  final TransferState state;

  const ReceiveStep({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // --- Top section ---
        Expanded(child: ScaleFadeSwitcher(child: _buildStep(state))),

        // --- Bottom section ---
        const SizedBox(height: 16),

        Column(
          mainAxisSize: MainAxisSize.min,
          children: [_buildButtons(context, state), const SizedBox(height: 8)],
        ),
      ],
    );
  }

  Widget _buildStep(TransferState state) {
    return switch (state) {
      ReceiveState() => ReceiveMainStep(
        key: const ValueKey('receive-main-step'),
        state: state,
      ),
      CheckValidState() => ReceiveCheckValidStep(
        key: const ValueKey('receive-check-valid-step'),
        state: state,
      ),
      TransferCompleteState() => ReceiveCompleteStep(
        key: const ValueKey('receive-complete-step'),
        state: state,
      ),
      TransferErrorState() => ReceiveErrorStep(
        key: const ValueKey('receive-error-step'),
        state: state,
      ),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildButtons(BuildContext context, TransferState state) {
    final l = AppLocalizations.of(context)!;

    if (state is TransferErrorState) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          EmbossedButton(
            l.tryAgain,
            leadingIcon: Symbols.refresh,
            onPressed: () {
              context.read<TransferBloc>().add(RestartServer());
            },
          ),
          const SizedBox(height: 12),
          EmbossedButton(
            l.back,
            type: EmbossedButtonType.outlineMuted,
            onPressed: () {
              context.read<TransferBloc>().add(CancelTransfer());
              if (context.canPop()) {
                context.pop();
              }
            },
          ),
        ],
      );
    }

    return switch (state) {
      ReceiveState() || CheckValidState() => EmbossedButton(
        l.cancel,
        type: EmbossedButtonType.outlined,
        color: const EmbossedButtonErrorColor(),
        leadingIcon: Symbols.close,
        onPressed: () {
          context.read<TransferBloc>().add(CancelTransfer());
        },
      ),
      TransferCompleteState() => EmbossedButton(
        l.done,
        onPressed: () {
          context.read<TransferBloc>().add(CancelTransfer());
          context.go(AppRoutes.loginAiSelection);
        },
      ),
      _ => EmbossedButton(
        l.back,
        type: EmbossedButtonType.outlineMuted,
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          }
        },
      ),
    };
  }
}
