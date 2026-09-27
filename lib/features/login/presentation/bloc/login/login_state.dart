import 'package:flutter/material.dart';

@immutable
sealed class LoginState {}

class InputUsernameState extends LoginState {
  final String username;
  final bool isValid;

  InputUsernameState({
    required this.username,
    required this.isValid,
  });
}

class SelectLanguageState extends LoginState {
  final String? language;
  final String username;
  final bool isValid;
  
  SelectLanguageState({
    required this.language,
    required this.username,
    required this.isValid,
  });
}

class DefaultLoginState extends InputUsernameState {
  DefaultLoginState(): super(username: "", isValid: false);
}

class ProfileSavedState extends LoginState {}


