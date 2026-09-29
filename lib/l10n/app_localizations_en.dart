// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Basa';

  @override
  String get welcome_startUsing => 'Start Using';

  @override
  String get welcome_description =>
      'Choose how you want to start learning today.';

  @override
  String get welcome_newProfile_title => 'Create New Profile';

  @override
  String get welcome_newProfile_description =>
      'Start fresh with a new profile.';

  @override
  String get welcome_sync_title => 'Sync Profile';

  @override
  String get welcome_sync_description =>
      'Transfer your profile from an old device.';

  @override
  String get welcome_nextButton => 'Get Started';

  @override
  String get newProfile_title => 'Profile Registration';

  @override
  String get newProfile_step_username_title => 'Enter Username';

  @override
  String get newProfile_step_username_description =>
      'This name will be used as your learning account\'s display name on this device';

  @override
  String get newProfile_step_username_fieldName => 'Username';

  @override
  String get newProfile_step_username_fieldPlaceholder => 'Enter username...';

  @override
  String get newProfile_step_username_fieldHint =>
      'You can use letters, numbers, or periods.';

  @override
  String get newProfile_step_language_title => 'Choose Main Language';

  @override
  String get newProfile_step_language_description =>
      'This language will be used as the main language for navigation and exercise instructions.';

  @override
  String get newProfile_step_language_search => 'Search language...';

  @override
  String get newProfile_nextButton => 'Continue';

  @override
  String get newProfile_saveButton => 'Save';

  @override
  String get newProfile_complete_title => 'Profil Berhasil Dibuat';

  @override
  String get newProfile_complete_description =>
      'Profilmu sudah siap digunakan. Mari lanjutkan pengalaman belajarmu dengan tenang.';

  @override
  String get securityFootnote =>
      'Your profile is stored securely on this device without a password';

  @override
  String get done => 'Done';

  @override
  String step(int first, int second) {
    return '$first of $second';
  }

  @override
  String get end_of_translation => '';
}
