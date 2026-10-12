import 'package:bahasa/core/widgets/scale_fade_switcher.dart';
import 'package:bahasa/features/login/login_dependencies.dart';
import 'package:bahasa/features/login/presentation/bloc/transfer/transfer_bloc.dart';
import 'package:bahasa/features/login/presentation/bloc/transfer/transfer_event.dart';
import 'package:bahasa/features/login/presentation/bloc/transfer/transfer_state.dart';
import 'package:bahasa/features/login/presentation/widgets/transfer/non_receive_step.dart';
import 'package:bahasa/features/login/presentation/widgets/transfer/receive_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransferPage extends StatelessWidget {
  final TransferBloc? bloc;

  const TransferPage({super.key, this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return (bloc ?? LoginDependencies.createTransferBloc())
          ..add(InitServer());
      },
      child: const TransferView(),
    );
  }
}

class TransferView extends StatelessWidget {
  const TransferView({super.key});

  static int _stepFor(TransferState state) {
    return switch (state) {
      ReceiveState() => 1,
      CheckValidState() => 1,
      TransferCompleteState() => 1,
      TransferErrorState() => 1,
      _ => 0,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: BlocBuilder<TransferBloc, TransferState>(
            builder: (context, state) {
              return _buildSwitcher(context, state);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSwitcher(BuildContext context, TransferState state) {
    return ScaleFadeSwitcher(
      child: switch (_stepFor(state)) {
        1 => ReceiveStep(key: const ValueKey('receive-step'), state: state),
        _ => NonReceiveStep(
          key: const ValueKey('non-receive-step'),
          state: state,
        ),
      },
    );
  }
}
