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
  String get welcome_transfer_title => 'Transfer Old Profile';

  @override
  String get welcome_transfer_description =>
      'Transfer your profile from your old device.';

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
  String get newProfile_complete_title => 'Profile Created Successfully';

  @override
  String get newProfile_complete_description =>
      'Your profile is ready to use. Let\'s continue your learning journey with confidence.';

  @override
  String get securityFootnote =>
      'Your profile is stored securely on this device without a password';

  @override
  String get transfer_listening_title => 'Waiting for Another Device';

  @override
  String get transfer_listening_description =>
      'Open [APP_NAME :v] on another device, then insert the following address to start profile transfer.';

  @override
  String get transfer_listening_address => 'Device Address';

  @override
  String get transfer_listening_aboveQr => 'or scan this code';

  @override
  String get transfer_listening_belowQr =>
      'Waiting for data from another device...';

  @override
  String get transfer_listening_note =>
      'Make sure both devices connected to the same network.';

  @override
  String get transfer_receive_name => 'Penerimaan Berkas';

  @override
  String get transfer_receive_title => 'Menerima Berkas';

  @override
  String get transfer_receive_description =>
      'Mohon tunggu, berkas profil Anda sedang dalam proses transfer.';

  @override
  String get transfer_receive_process => 'Sedang menerima';

  @override
  String get transfer_checkValid_name => 'Pemeriksaan Berkas';

  @override
  String get transfer_checkValid_title => 'Memvalidasi Berkas';

  @override
  String get transfer_checkValid_description =>
      'Mohon tunggu sebentar, sistem sedang memastikan berkas yang diterima aman dan lengkap.';

  @override
  String get transfer_checkValid_process => 'Sedang memindai';

  @override
  String get transfer_checkValid_info_title => 'Memeriksa data profil...';

  @override
  String get transfer_checkValid_info_description =>
      'Memeriksa kelengkapan riwayat belajar, kosakata tersimpan, dan integritas data profil.';

  @override
  String get transfer_error_invalid_title => 'Invalid Data';

  @override
  String get transfer_error_invalid_description =>
      'Transfer process was interrupted before all your profile data could be copied to this device.';

  @override
  String get transfer_error_cleanup_title =>
      'Failed data has been removed from this device.';

  @override
  String get transfer_error_cleanup_description =>
      'Device local storage remains clean and safe.';

  @override
  String get transfer_complete_title => 'Profil Berhasil Dipindahkan';

  @override
  String get transfer_complete_description =>
      'Profilmu sudah siap digunakan. Mari lanjutkan perjalanan belajarmu dengan tenang.';

  @override
  String get transfer_complete_profileInfo_title => 'Info Profil';

  @override
  String get joinSince => 'Bergabung sejak';

  @override
  String get username => 'Username';

  @override
  String get defaultLanguage => 'Bahasa default';

  @override
  String get process_preparing => 'Preparing';

  @override
  String get process_gettingReady => 'Getting things ready';

  @override
  String get process_process => 'Processing';

  @override
  String get process_loading => 'Loading';

  @override
  String get back => 'Back';

  @override
  String get cancel => 'Cancel';

  @override
  String get done => 'Done';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get copy => 'Copy';

  @override
  String get paste => 'Paste';

  @override
  String get copied => 'Copied!';

  @override
  String get pasted => 'Pasted!';

  @override
  String languageName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'id': 'Indonesian',
      'en': 'English',
      'es': 'Spanish',
      'ja': 'Japanese',
      'ko': 'Korean',
      'fr': 'French',
      'ru': 'Russian',
      'ar': 'Arabic',
      'de': 'German',
      'pt': 'Portuguese',
      'zh': 'Chinese',
      'hi': 'Hindi',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String step(int first, int second) {
    return '$first of $second';
  }

  @override
  String get settings_title => 'Settings';

  @override
  String get settings_manageProfile => 'Manage profile';

  @override
  String get settings_activeStudent => 'Active Learner';

  @override
  String get settings_account_title => 'Account';

  @override
  String get settings_account_subtitle => 'Change username & photo';

  @override
  String get settings_theme_title => 'Theme';

  @override
  String get settings_theme_subtitleLight => 'Light mode (easy on the eyes)';

  @override
  String get settings_theme_subtitleDark => 'Dark mode (saves battery)';

  @override
  String get settings_theme_badgeLight => 'Light';

  @override
  String get settings_theme_badgeDark => 'Dark';

  @override
  String get settings_notif_title => 'Notifications';

  @override
  String get settings_notif_subtitle => 'Daily learning reminders';

  @override
  String get settings_data_title => 'Data & Storage';

  @override
  String get settings_data_subtitle => 'Import, export, & profile backup';

  @override
  String get account_joinedSince => 'Joined since 2026.';

  @override
  String get account_editProfile => 'Edit Profile';

  @override
  String get account_editProfile_subtitle => 'Change photo or username.';

  @override
  String get account_deleteProfile => 'Delete Profile';

  @override
  String get account_deleteProfile_subtitle =>
      'Delete account and all data permanently.';

  @override
  String get account_footer => 'Basa • Your Language Learning Companion';

  @override
  String get account_delete_dialogTitle => 'Delete this profile?';

  @override
  String get account_delete_dialogBody =>
      'All your learning data will be permanently deleted and cannot be recovered.';

  @override
  String get account_delete_confirmButton => 'Delete';

  @override
  String get editProfile_title => 'Edit Profile';

  @override
  String get editProfile_subtitle =>
      'Manage your public information and learning account.';

  @override
  String get editProfile_changePhoto => 'Change Photo';

  @override
  String get editProfile_usernameLabel => 'Username';

  @override
  String get editProfile_usernameHint =>
      'You can use letters, numbers, or periods.';

  @override
  String get editProfile_tipTitle => 'Basa Community Tip';

  @override
  String get editProfile_tipBody =>
      'This username will be visible to peers on the weekly leaderboard.';

  @override
  String get editProfile_saveButton => 'Save Changes';

  @override
  String get theme_title => 'Theme';

  @override
  String get theme_subtitle => 'Choose the display that suits you best.';

  @override
  String get theme_light => 'Light';

  @override
  String get theme_dark => 'Dark';

  @override
  String get data_sectionStorage => 'STORAGE USAGE';

  @override
  String get data_download => 'Vocabulary Downloads';

  @override
  String data_downloadSubtitle(String sizeStr) {
    return '$sizeStr stored offline';
  }

  @override
  String get data_clear => 'Clear';

  @override
  String get data_sectionDataTransfer => 'DATA TRANSFER';

  @override
  String get data_dataTransfer => 'Data Transfer';

  @override
  String get data_dataTransfer_subtitle => 'Transfer data to your new device';

  @override
  String get data_sectionDanger => 'ADVANCED ACTIONS';

  @override
  String get data_deleteData => 'Delete Data';

  @override
  String get data_deleteData_subtitle => 'Delete all history and progress';

  @override
  String get shareData_title => 'Share Data';

  @override
  String get shareData_subtitle =>
      'Enter the IP address from the receiver device to send data.';

  @override
  String get shareData_ipLabel => 'Receiver IP Address';

  @override
  String get shareData_ipPlaceholder => 'Enter IP address...';

  @override
  String get shareData_startButton => 'Start Transfer';

  @override
  String get shareData_sending_overline => 'DATA & STORAGE';

  @override
  String get shareData_sending_title => 'Sending Data';

  @override
  String get shareData_sending_status =>
      'Please wait, data is being processed...';

  @override
  String get shareData_sending_note =>
      'Do not close the app during the transfer.';

  @override
  String get shareData_failed_title => 'Transfer failed';

  @override
  String get shareData_failed_body =>
      'Connection lost or code is no longer valid. Try again?';

  @override
  String get shareData_failed_no => 'No';

  @override
  String get deleteData_dialog_title => 'Delete all data?';

  @override
  String get deleteData_dialog_body =>
      'This action cannot be undone. Type your username to confirm.';

  @override
  String get deleteData_dialog_confirmButton => 'Delete Data';

  @override
  String get deleteData_success_title => 'Data deleted successfully';

  @override
  String get deleteData_success_body =>
      'Your account still exists. You can start learning from scratch anytime.';

  @override
  String get deleteData_success_homeButton => 'Back to Home';

  @override
  String get end_of_translation => '';
}
