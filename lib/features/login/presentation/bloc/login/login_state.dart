import 'package:bahasa/features/login/domain/enums/login_step_enum.dart';
import 'package:flutter/material.dart';

@immutable
sealed class LoginState {}

class InputState extends LoginState {
  final String username;
  final String? language;

  final bool isUsernameValid;
  final bool isLanguageValid;

  final LoginStep step;
  
  InputState({
    required this.username,
    required this.language,
    required this.isUsernameValid,
    required this.isLanguageValid,
    required this.step, 
  });

  InputState copyWith({
    String? username,
    String? language,
    bool? isUsernameValid,
    bool? isLanguageValid,
    LoginStep? step,
  }) {
    return InputState(
      username: username ?? this.username,
      language: language ?? this.language,
      isUsernameValid: isUsernameValid ?? this.isUsernameValid,
      isLanguageValid: isLanguageValid ?? this.isLanguageValid,
      step: step ?? this.step,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InputState &&
        other.username == username &&
        other.language == language &&
        other.isUsernameValid == isUsernameValid &&
        other.isLanguageValid == isLanguageValid &&
        other.step == step;
  }

  @override
  int get hashCode => Object.hash(
        username,
        language,
        isUsernameValid,
        isLanguageValid,
      );
}

class DefaultLoginState extends InputState {
  DefaultLoginState(): super(
    username: "",
    isUsernameValid: false,
    language: null,
    isLanguageValid: false,
    step: LoginStep.username,
  );
}

class ProfileSavedState extends LoginState {}


