import 'dart:async';

import 'package:bahasa/core/errors/login_error.dart';
import 'package:bahasa/core/localization/locale_cubit.dart';
import 'package:bahasa/features/login/domain/enums/login_step_enum.dart';
import 'package:bahasa/features/login/presentation/bloc/login/login_event.dart';
import 'package:bahasa/features/login/presentation/bloc/login/login_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LocaleCubit _localeCubit;

  LoginBloc({required this._localeCubit}):
      super(DefaultLoginState()) {
    on<InputUsername>(_handleUsernameInput);
    on<SelectDefaultLanguage>(_handleDefaultLanguage);
    on<SaveProfile>(_handleSaveProfile);
    on<PreviousStep>(_handlePreviousStep);
  }

  bool _validateUsername(String? username, {int minLength = 3, int maxLength = 20}) {
    if (username == null) return false;

    final trimmed = username.trim();
    if (trimmed.length < minLength || trimmed.length > maxLength) {
      return false;
    }

    final usernameRegExp = RegExp(r'^[a-zA-Z0-9](?!.*[.]{2})[a-zA-Z0-9.]*[a-zA-Z0-9]$');
    return usernameRegExp.hasMatch(trimmed);
  }

  bool _validateLanguage(String? language) {
    // TODO: complete implementation
    return RegExp(r'^\w{2}$').hasMatch(language ?? "");
  }

  Future<void> _handleUsernameInput(InputUsername event, Emitter<LoginState> emit) async {
    final isValid = _validateUsername(event.username);
    final currentState = state;

    emit(
      currentState is InputState
        ? currentState.copyWith(step: LoginStep.username, username: event.username, isUsernameValid: isValid)
        : DefaultLoginState(),
    );
  }

  Future<void> _handleDefaultLanguage(SelectDefaultLanguage event, Emitter<LoginState> emit) async {
    final currentState = state;
    final isValid = _validateLanguage(event.language);

    String? language = event.language ?? (currentState is InputState ? currentState.language : null);

    emit(
      currentState is InputState
        ? currentState.copyWith(step: LoginStep.language, language: language, isLanguageValid: isValid)
        : DefaultLoginState(),
    );

    if (language == null) return;

    await _changeLanguage(language);
  }

  Future<void> _handleSaveProfile(SaveProfile event, Emitter<LoginState> emit) async {
    final currentState = state;

    if (currentState is! InputState || !currentState.isLanguageValid || !currentState.isUsernameValid) {
      throw LoginNotValid();
    }

    if (currentState.language == null) {
      throw LoginNotValid();
    }

    // TODO: persist username / create the actual profile record here
    // (e.g. via a ProfileRepository), once that layer exists.

    emit(ProfileSavedState());
  }

  void _handlePreviousStep(LoginEvent event, Emitter<LoginState> emit) {
    final currentState = state;
    if (currentState is! InputState) return;

    emit(switch (currentState) {
      InputState(step: LoginStep.language) => currentState.copyWith(step: LoginStep.username),
      InputState(step: LoginStep.username) => currentState,
    });
  }

  /// Persists the chosen language and applies it as the active app locale.
  Future<void> _changeLanguage(String language) async {
    await _localeCubit.changeLanguage(language); // this already saves to SharedPreferences internally
  }

  // @override
  // Future<void> close() async {
  //   await _subscription?.cancel();
  //   await _importServer.dispose();
  //   return super.close();
  // }
}