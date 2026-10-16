/// Base failure class for Settings feature.
abstract class SettingsFailure implements Exception {
  final String message;
  const SettingsFailure(this.message);

  @override
  String toString() => message;
}

class ProfileNotFoundFailure extends SettingsFailure {
  const ProfileNotFoundFailure([super.message = 'User profile was not found.']);
}

class InvalidUsernameFailure extends SettingsFailure {
  const InvalidUsernameFailure([
    super.message = 'Invalid username format or length.',
  ]);
}

class UsernameMismatchFailure extends SettingsFailure {
  const UsernameMismatchFailure([
    super.message = 'Username does not match the current account.',
  ]);
}

class DataTransferFailure extends SettingsFailure {
  const DataTransferFailure([super.message = 'Data transfer failed.']);
}

class StorageOperationFailure extends SettingsFailure {
  const StorageOperationFailure([super.message = 'Storage operation failed.']);
}

class FileNotFoundFailure extends SettingsFailure {
  const FileNotFoundFailure([super.message = 'Selected file was not found.']);
}
