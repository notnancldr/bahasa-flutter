import 'package:bahasa/core/widgets/embossed_button.dart';
import 'package:bahasa/features/login/presentation/bloc/login/login_bloc.dart';
import 'package:bahasa/features/login/presentation/bloc/login/login_event.dart';
import 'package:bahasa/features/login/presentation/bloc/login/login_state.dart';
import 'package:bahasa/features/login/presentation/widgets/login/login_header.dart';
import 'package:bahasa/features/login/presentation/widgets/security_footnote.dart';
import 'package:bahasa/features/login/presentation/widgets/login/input_username_step.dart';
import 'package:bahasa/features/login/presentation/widgets/login/select_language_step.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
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
                        LoginHeader(current: _stepFor(state), total: 2),
                        SizedBox(height: 8),
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 350),
                            switchInCurve: Curves.easeOut,
                            switchOutCurve: Curves.easeIn,
                            layoutBuilder: (currentChild, previousChildren) {
                              return Stack(
                                alignment: Alignment.topLeft,
                                children: <Widget>[
                                  ...previousChildren,
                                  if (currentChild != null) currentChild,
                                ],
                              );
                            },
                            transitionBuilder: (child, animation) {
                              final slideIn = Tween<Offset>(
                                begin: const Offset(0.12, 0),
                                end: Offset.zero,
                              ).animate(animation);
                              return ClipRect(
                                child: SlideTransition(
                                  position: slideIn,
                                  child: FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                                ),
                              );
                            },
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
                        _labelFor(state),
                        onPressed: _onPressedFor(context, state),
                        trailingIcon: Symbols.arrow_forward,
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
      _ => const SizedBox.shrink(key: ValueKey('unknown-step')),
    };
  }

  String _labelFor(LoginState state) {
    return switch (state) {
      SelectLanguageState() => "Simpan",
      _ => "Lanjutkan",
    };
  }

  void Function()? _onPressedFor(BuildContext context, LoginState state) {
    return switch (state) {
      InputUsernameState(isValid: true) => () {
          context.read<LoginBloc>().add(SelectDefaultLanguage(language: null));
        },
      InputUsernameState(isValid: false) => null,
      SelectLanguageState() => () {
          context.read<LoginBloc>().add(SaveProfile());
        },
      _ => null,
    };
  }
}