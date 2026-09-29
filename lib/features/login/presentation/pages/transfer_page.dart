import 'package:bahasa/core/localization/locale_cubit.dart';
import 'package:bahasa/core/widgets/embossed_button.dart';
import 'package:bahasa/core/widgets/slide_fade_switcher.dart';
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

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  static int _stepFor(LoginState state) {
    return switch (state) {
      InputUsernameState() => 0,
      SelectLanguageState() => 1,
      ProfileSavedState() => 2,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Top section: header + step content, takes remaining space ---
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LoginHeader(current: _stepFor(state), total: 2)
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
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStep(LoginState state) {
    return switch (state) {
      InputUsernameState() =>
        InputUsernameStep(key: const ValueKey('username-step'), state: state),
      SelectLanguageState() =>
        SelectLanguageStep(key: const ValueKey('language-step'), state: state),
      ProfileSavedState() =>
        LoginComplete(key: const ValueKey('login-complete')),
    };
  }

  String _labelFor(LoginState state, AppLocalizations l) {
    return switch (state) {
      SelectLanguageState() => l.newProfile_saveButton,
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
      InputUsernameState(isValid: true) => () {
          context.read<LoginBloc>().add(SelectDefaultLanguage(language: null));
        },
      InputUsernameState(isValid: false) => null,
      SelectLanguageState(isValid: true) => () {
          context.read<LoginBloc>().add(SaveProfile());
        },
      ProfileSavedState() => () {
          context.go("/");
        },
      _ => null,
    };
  }
}