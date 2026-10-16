import 'package:bahasa/features/settings/domain/entities/user_profile.dart';

sealed class AccountState {
  const AccountState();

  UserProfile? get profile => switch (this) {
    AccountLoaded(:final profile) => profile,
    AccountPhotoUpdated(:final profile) => profile,
    AccountUsernameUpdated(:final profile) => profile,
    AccountLanguageUpdated(:final profile) => profile,
    AccountConfirmDeletePrompt(:final profile) => profile,
    AccountError(:final previousProfile) => previousProfile,
    _ => null,
  };
}

class AccountInitial extends AccountState {
  const AccountInitial();
}

class AccountLoading extends AccountState {
  const AccountLoading();
}

class AccountLoaded extends AccountState {
  @override
  final UserProfile profile;
  const AccountLoaded(this.profile);
}

class AccountPhotoUpdated extends AccountState {
  @override
  final UserProfile profile;
  const AccountPhotoUpdated(this.profile);
}

class AccountUsernameUpdated extends AccountState {
  @override
  final UserProfile profile;
  const AccountUsernameUpdated(this.profile);
}

class AccountLanguageUpdated extends AccountState {
  @override
  final UserProfile profile;
  const AccountLanguageUpdated(this.profile);
}

class AccountConfirmDeletePrompt extends AccountState {
  @override
  final UserProfile profile;
  const AccountConfirmDeletePrompt(this.profile);
}

class AccountDeleting extends AccountState {
  const AccountDeleting();
}

class AccountDeletedSuccess extends AccountState {
  const AccountDeletedSuccess();
}

class AccountError extends AccountState {
  final String message;
  final UserProfile? previousProfile;
  const AccountError(this.message, {this.previousProfile});
}
