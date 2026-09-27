import 'dart:async';

import 'package:bahasa/core/errors/login_error.dart';
import 'package:bahasa/features/login/presentation/bloc/login/login_event.dart';
import 'package:bahasa/features/login/presentation/bloc/login/login_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(): super(DefaultLoginState()) {
    on<InputUsername>(_handleUsernameInput);
    on<SelectDefaultLanguage>(_handleDefaultLanguage);
    on<SaveProfile>((_, _) {}); // TODO
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

    emit(InputUsernameState(
      username: event.username,
      isValid: isValid,
    ));
  }
  
  Future<void> _handleDefaultLanguage(SelectDefaultLanguage event, Emitter<LoginState> emit) async {
    final currentState = state;
    final isValid = _validateLanguage(event.language);

    late String username;
    String? language;

    switch (currentState) {
      case InputUsernameState(username: final usernameState):
        username = usernameState;
        break;
      case SelectLanguageState(
        language :final languageState,
        username :final usernameState,
      ):
        language = languageState;
        username = usernameState;
        break;
      default:
        throw LoginNotValid();
    }

    emit(SelectLanguageState(
      language: event.language ?? language,
      username: username,
      isValid: isValid,
    ));
  }

  // @override
  // Future<void> close() async {
  //   await _subscription?.cancel();
  //   await _importServer.dispose();
  //   return super.close();
  // }
}