import 'package:flutter/material.dart';

@immutable
sealed class LoginEvent {}

// Create profile
class CreateProfileEvent extends LoginEvent {}

class InputUsername extends CreateProfileEvent {
  final String username;

  InputUsername({
    required this.username,
  });
}

class SelectDefaultLanguage extends CreateProfileEvent {
  final String? language;

  SelectDefaultLanguage({
    required this.language,
  });
}

class SaveProfile extends CreateProfileEvent {}