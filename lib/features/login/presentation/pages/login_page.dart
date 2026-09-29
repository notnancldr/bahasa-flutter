import 'package:bahasa/core/localization/locale_cubit.dart';
import 'package:bahasa/core/widgets/embossed_button.dart';
import 'package:bahasa/core/widgets/slide_fade_switcher.dart';
import 'package:bahasa/features/login/domain/enums/login_step_enum.dart';
import 'package:bahasa/features/login/presentation/bloc/login/login_bloc.dart';
import 'package:bahasa/features/login/presentation/bloc/login/login_event.dart';
import 'package:bahasa/features/login/presentation/bloc/login/login_state.dart';
import 'package:bahasa/features/login/presentation/widgets/login/login_complete.dart';
import 'package:bahasa/features/login/presentation/widgets/login/login_header.dart';
import 'package:bahasa/features/login/presentation/widgets/security_footnote.dart';
import 'package:bahasa/features/login/presentation/widgets/login/input_username_step.dart';
import 'package:bahasa/features/login/presentation/widgets/login/select_language_step.dart';
import 'package:bahasa/l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(
        localeCubit: context.read<LocaleCubit>(),
      ),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  int _lastStep = 0;
  bool _reverse = false;

  static int _stepFor(LoginState state) {
    return switch (state) {
      InputState(step: LoginStep.username) => 0,
      InputState(step: LoginStep.language) => 1,
      ProfileSavedState() => 2,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        final step = _stepFor(state);
        if (step != _lastStep) {
          _reverse = step < _lastStep;
          _lastStep = step;
        };
        return PopScope(
          canPop: state is! InputState || state.step == LoginStep.username,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) context.read<LoginBloc>().add(PreviousStep());
          },
          child: Scaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Top section: header + step content, takes remaining space ---
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LoginHeader(state: state, current: _stepFor(state), total: 2)
                            .animate(
                              // Prevent initial animation
                              value: 1,
                              target: (state is ProfileSavedState) ? 0 : 1,
                            )
                            .fade()
                            .slideY(),
                          // Text((state is ProfileSavedState).toString()),
                          SizedBox(height: 8),
                          Expanded(
                            child: SlideFadeSwitcher(
                              reverse: _reverse,
                              child: _buildStep(state),
                            ),
                          ),
                        ],
                      ),
                    ),
      
                    // --- Bottom section: pinned button + footnote ---
      
                    SizedBox(height: 16),
      
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        EmbossedButton(
                          _labelFor(state, l),
                          onPressed: _onPressedFor(context, state),
                          trailingIcon: _iconFor(state),
                        ),
                        SizedBox(height: 16),
                        SecurityFootnote(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _buildStep(LoginState state) {
    return switch (state) {
      InputState(step: LoginStep.username) =>
        InputUsernameStep(key: const ValueKey('username-step'), state: state),
      InputState(step: LoginStep.language) =>
        SelectLanguageStep(key: const ValueKey('language-step'), state: state),
      ProfileSavedState() =>
        LoginComplete(key: const ValueKey('login-complete')),
    };
  }

  String _labelFor(LoginState state, AppLocalizations l) {
    return switch (state) {
      InputState(step: LoginStep.language) => l.newProfile_saveButton,
      ProfileSavedState() => l.done,
      _ => l.newProfile_nextButton,
    };
  }

  IconData? _iconFor(LoginState state) {
    return switch (state) {
      ProfileSavedState() => null,
      _ => Symbols.arrow_forward,
    };
  }

  void Function()? _onPressedFor(BuildContext context, LoginState state) {
    return switch (state) {
      InputState(step: LoginStep.username, isUsernameValid: true) => () {
          context.read<LoginBloc>().add(SelectDefaultLanguage(language: state.language));
        },
      InputState(step: LoginStep.username, isUsernameValid: false) => null,
      InputState(step: LoginStep.language, isLanguageValid: true) => () {
          context.read<LoginBloc>().add(SaveProfile());
        },
      ProfileSavedState() => () {
          context.go("/");
        },
      _ => null,
    };
  }
}