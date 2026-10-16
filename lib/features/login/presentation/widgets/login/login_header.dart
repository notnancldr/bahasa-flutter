import 'package:bahasa/core/widgets/step_progress_header.dart';
import 'package:bahasa/features/login/domain/enums/login_step_enum.dart';
import 'package:bahasa/features/login/presentation/bloc/login/login_bloc.dart';
import 'package:bahasa/features/login/presentation/bloc/login/login_event.dart';
import 'package:bahasa/features/login/presentation/bloc/login/login_state.dart';
import 'package:bahasa/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginHeader extends StatelessWidget {
  final int current;
  final int total;
  final LoginState state;

  const LoginHeader({
    super.key,
    required this.current,
    required this.total,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return StepProgressHeader(
      current: current,
      total: total,
      title: l.newProfile_title,
      stepLabel: l.step(current + 1, total),
      onBack: () {
        final currentState = state;
        if (currentState is InputState &&
            currentState.step == LoginStep.username) {
          if (context.canPop()) {
            context.pop();
          }
        } else {
          context.read<LoginBloc>().add(PreviousStep());
        }
      },
    );
  }
}
