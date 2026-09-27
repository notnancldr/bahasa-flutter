import 'package:flutter/material.dart';

@immutable
sealed class LoginState {}

class InputUsernameState extends LoginState {
  final String username;
  final String isValid;

  InputUsernameState({
    required this.username,
    required this.isValid,
  });
}

class SelectLanguageState extends LoginState {
  final String language;
  
  SelectLanguageState({
    required this.language,
  });
}


