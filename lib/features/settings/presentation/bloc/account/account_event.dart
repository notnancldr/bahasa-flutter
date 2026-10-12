sealed class AccountEvent {
  const AccountEvent();
}

class LoadAccountEvent extends AccountEvent {
  const LoadAccountEvent();
}

class PickAndChangePhotoEvent extends AccountEvent {
  const PickAndChangePhotoEvent();
}

class ChangeProfilePhotoEvent extends AccountEvent {
  final String photoPath;
  const ChangeProfilePhotoEvent(this.photoPath);
}

class ChangeUsernameEvent extends AccountEvent {
  final String newUsername;
  const ChangeUsernameEvent(this.newUsername);
}

class RequestDeleteProfileConfirmationEvent extends AccountEvent {
  const RequestDeleteProfileConfirmationEvent();
}

class ConfirmDeleteProfileEvent extends AccountEvent {
  const ConfirmDeleteProfileEvent();
}

class CancelAccountActionEvent extends AccountEvent {
  const CancelAccountActionEvent();
}

