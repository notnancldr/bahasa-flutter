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
      'de': 'German',
      'it': 'Italian',
      'ru': 'Russian',
      'ar': 'Arabic',
      'nl': 'Dutch',
      'pt': 'Portuguese',
      'zh': 'Chinese',
      'th': 'Thai',
      'vi': 'Vietnamese',
      'tr': 'Turkish',
      'hi': 'Hindi',
      'sv': 'Swedish',
      'no': 'Norwegian',
      'da': 'Danish',
      'fi': 'Finnish',
      'pl': 'Polish',
      'uk': 'Ukrainian',
      'el': 'Greek',
      'he': 'Hebrew',
      'ms': 'Malay',
      'tl': 'Filipino',
      'cs': 'Czech',
      'hu': 'Hungarian',
      'ro': 'Romanian',
      'bg': 'Bulgarian',
      'hr': 'Croatian',
      'sk': 'Slovak',
      'sl': 'Slovenian',
      'sw': 'Swahili',
      'fa': 'Persian',
      'ur': 'Urdu',
      'bn': 'Bengali',
      'ta': 'Tamil',
      'lat': 'Latin',
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
  String get settings_language_title => 'Language';

  @override
  String get settings_language_subtitle => 'Select app primary language';

  @override
  String get settings_language_alert_title => 'Change App & Deck Language';

  @override
  String get settings_language_alert_message =>
      'Changing the language here will cause future decks and explanations to be translated and explained using the selected language.';

  @override
  String get settings_language_alert_confirm => 'Change Language';

  @override
  String get settings_language_alert_cancel => 'Cancel';

  @override
  String get settings_notif_title => 'Notifications';

  @override
  String get settings_notif_subtitle => 'Daily learning reminders';

  @override
  String get settings_data_title => 'Data & Storage';

  @override
  String get settings_data_subtitle => 'Vocab storage and transfer profile';

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
  String get shareData_or => 'or';

  @override
  String get shareData_scanQrButton => 'Scan QR Code';

  @override
  String get shareData_scanner_title => 'Scan Receiver QR';

  @override
  String get shareData_scanner_instruction =>
      'Point camera at the QR code on the receiver device';

  @override
  String get shareData_scanner_permission_denied =>
      'Camera permission is required to scan QR code';

  @override
  String get shareData_scanner_error => 'Unable to access camera';

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
  String get home_consecutiveDays => 'Consecutive Days';

  @override
  String get home_emptyDeckTitle => 'You don\'t have any deck yet!';

  @override
  String get home_createDeckButton => 'Create Deck';

  @override
  String get home_rarelyStudied => 'Rarely Studied';

  @override
  String get home_reviewButton => 'Review';

  @override
  String home_lastStudiedDaysAgo(int days) {
    return 'Last studied $days days ago.';
  }

  @override
  String get home_recentActivityTitle => 'Recent Activity';

  @override
  String home_recentActivitySubtitle(int cards, int time, String unit) {
    String _temp0 = intl.Intl.pluralLogic(
      cards,
      locale: localeName,
      other: '$cards cards',
      one: '1 card',
    );
    String _temp1 = intl.Intl.selectLogic(unit, {
      'hoursAgo': '$time hours ago',
      'yesterday': 'Yesterday',
      'daysAgo': '$time days ago',
      'other': '$time',
    });
    return '$_temp0 • $_temp1';
  }

  @override
  String home_cardsCount(int count) {
    return '$count cards';
  }

  @override
  String home_timeHoursAgo(int hours) {
    return '$hours hours ago';
  }

  @override
  String get home_timeYesterday => 'Yesterday';

  @override
  String home_timeDaysAgo(int days) {
    return '$days days ago';
  }

  @override
  String get deck_method_title => 'Add New Deck';

  @override
  String get deck_method_subtitle => 'Choose how you want to create your deck.';

  @override
  String get deck_method_generate_title => 'Generate Deck';

  @override
  String get deck_method_generate_subtitle =>
      'Create a new deck automatically.';

  @override
  String get deck_method_generate_cta => 'Start';

  @override
  String get deck_method_import_title => 'Import Deck';

  @override
  String get deck_method_import_subtitle => 'Use an existing .euy file.';

  @override
  String get deck_method_import_cta => 'Choose File';

  @override
  String get deck_gen_appbar_title => 'Generate Deck';

  @override
  String get deck_gen_name_title => 'Name your deck';

  @override
  String get deck_gen_name_desc => 'This name will appear in your deck list.';

  @override
  String get deck_gen_name_label => 'Deck Name';

  @override
  String get deck_gen_name_hint => 'Example: Basic Japanese Vocabulary...';

  @override
  String get deck_gen_country_title => 'Select Country';

  @override
  String get deck_gen_country_desc =>
      'Deck content will be tailored to this country.';

  @override
  String get deck_gen_country_search => 'Search Country';

  @override
  String get deck_gen_diff_title => 'Select Difficulty Level';

  @override
  String get deck_gen_diff_desc => 'This helps adjust the card difficulty.';

  @override
  String get deck_gen_diff_beginner => 'Beginner';

  @override
  String get deck_gen_diff_intermediate => 'Intermediate';

  @override
  String get deck_gen_diff_expert => 'Expert';

  @override
  String get deck_gen_desc_title => 'Add description';

  @override
  String get deck_gen_desc_subtitle =>
      'Tell a bit about your study focus for this deck.';

  @override
  String get deck_gen_desc_hint =>
      'Example: Focus on everyday vocabulary for casual conversation...';

  @override
  String get deck_gen_review_title => 'Review before creating';

  @override
  String get deck_gen_review_desc => 'Make sure the details below are correct.';

  @override
  String get deck_gen_review_change => 'Change';

  @override
  String get deck_gen_create_button => 'Create Deck';

  @override
  String deck_gen_limit_reached_title(String time) {
    return 'Online AI daily limit reached (1 deck/day). Reset in $time.';
  }

  @override
  String deck_gen_limit_countdown_button(String time) {
    return 'Create Deck (Reset in $time)';
  }

  @override
  String get deck_gen_cancel_button => 'Cancel';

  @override
  String get deck_gen_progress_header => 'Creating Deck';

  @override
  String get deck_gen_progress_title => 'Preparing your deck...';

  @override
  String get deck_gen_progress_subtitle =>
      'You will be notified once it is ready.';

  @override
  String deck_gen_cards_collected_progress(int count, int total) {
    return 'Collected $count / $total cards';
  }

  @override
  String get deck_gen_in_progress_badge => 'Generating...';

  @override
  String get deck_run_in_background => 'Run in Background';

  @override
  String get deck_gen_error_title => 'Deck creation failed';

  @override
  String get deck_gen_error_subtitle =>
      'Something went wrong while preparing your deck. No partial data was saved.';

  @override
  String get deck_back_to_home => 'Back to Home Page';

  @override
  String get deck_import_appbar_title => 'Import Deck';

  @override
  String get deck_import_title => 'Select deck file';

  @override
  String get deck_import_subtitle =>
      'Select a .euy file from your device storage.';

  @override
  String get deck_import_empty_title => 'No file chosen yet';

  @override
  String get deck_import_empty_format => 'Supported format: .euy';

  @override
  String get deck_import_pick_button => 'Choose from Storage';

  @override
  String get deck_import_change_file => 'Change File';

  @override
  String get deck_import_verifying_title => 'Verifying file...';

  @override
  String get deck_import_verifying_subtitle =>
      'Ensuring the file format and content are valid.';

  @override
  String get deck_import_importing_title => 'Importing Deck';

  @override
  String get deck_import_invalid_title => 'Invalid file';

  @override
  String get deck_import_invalid_subtitle =>
      'The selected file is corrupted or not a recognized .euy format.';

  @override
  String get deck_import_pick_another => 'Choose Another File';

  @override
  String get deck_import_ready_title => 'Deck is ready!';

  @override
  String get deck_import_ready_subtitle =>
      'Check the details below before proceeding.';

  @override
  String get deck_card_count_label => 'Card Count';

  @override
  String get deck_file_size_label => 'File Size';

  @override
  String get deck_continue => 'Continue';

  @override
  String get deck_page_placeholder => 'Deck';

  @override
  String get deck_compilation_title => 'Deck Compilation';

  @override
  String get deck_search_hint => 'Search your decks...';

  @override
  String get deck_select_all => 'Select all';

  @override
  String get deck_deselect_all => 'Deselect all';

  @override
  String deck_selected_count(int count) {
    return '$count deck selected';
  }

  @override
  String get deck_delete_button => 'Delete';

  @override
  String get deck_delete_dialog_title => 'Delete This Deck??';

  @override
  String get deck_delete_dialog_body =>
      'This action cannot be undone. Type your username to confirm.';

  @override
  String deck_delete_dialog_hint(String username) {
    return 'Type \"$username\"...';
  }

  @override
  String get deck_empty_search_title => 'No decks found';

  @override
  String get deck_add_fab_tooltip => 'Add Deck';

  @override
  String get nav_home => 'Home';

  @override
  String get nav_deck => 'Deck';

  @override
  String get nav_settings => 'Settings';

  @override
  String get deck_details_play_quiz => 'Play\nQuiz';

  @override
  String get deck_details_play_flashcard => 'Play\nFlash Card';

  @override
  String get deck_details_streak_label => 'Streak';

  @override
  String get deck_details_accuracy_label => 'Accuracy';

  @override
  String get deck_details_search_hint => 'Search cards...';

  @override
  String get deck_details_empty_cards => 'No cards found';

  @override
  String get deck_details_card_description_label => 'DESCRIPTION';

  @override
  String get deck_details_history_tooltip => 'History';

  @override
  String get deck_progress_streak_title => 'Active Time';

  @override
  String get deck_progress_accuracy_title => 'Accuracy';

  @override
  String get deck_progress_streaks_label => 'Streaks';

  @override
  String get deck_progress_accuracy_subtitle => 'This Month\'s Accuracy';

  @override
  String deck_progress_comparison_vs_last_month(String diff, int lastMonth) {
    return '$diff% vs last month ($lastMonth%)';
  }

  @override
  String deck_progress_active_comparison_vs_last_month(
    int thisMonth,
    int lastMonth,
  ) {
    return '${thisMonth}m this month (${lastMonth}m last month)';
  }

  @override
  String get deck_progress_weekly_streaks_title => 'Weekly Streaks';

  @override
  String get deck_progress_weekly_restarts_note =>
      '*This will be restarted every week';

  @override
  String get deck_progress_day_mon_short => 'Mon';

  @override
  String get deck_progress_day_tue_short => 'Tue';

  @override
  String get deck_progress_day_wed_short => 'Wed';

  @override
  String get deck_progress_day_thu_short => 'Thu';

  @override
  String get deck_progress_day_fri_short => 'Fri';

  @override
  String get deck_progress_day_sat_short => 'Sat';

  @override
  String get deck_progress_day_sun_short => 'Sun';

  @override
  String get deck_progress_day_sun => 'Sun';

  @override
  String get deck_progress_day_mon => 'Mon';

  @override
  String get deck_progress_day_tue => 'Tue';

  @override
  String get deck_progress_day_wed => 'Wed';

  @override
  String get deck_progress_day_thu => 'Thu';

  @override
  String get deck_progress_day_fri => 'Fri';

  @override
  String get deck_progress_day_sat => 'Sat';

  @override
  String get deck_progress_tab_month => 'Month';

  @override
  String get deck_progress_tab_year => 'Year';

  @override
  String get deck_progress_metric_card => 'Card';

  @override
  String get deck_progress_metric_accurate => 'Accurate';

  @override
  String get deck_progress_metric_active => 'Active';

  @override
  String get deck_progress_weakest_cards_title => 'Top 3 Weakest Cards';

  @override
  String get deck_progress_weakest_empty =>
      'No cards studied in this period yet';

  @override
  String deck_progress_wrong_count(int count) {
    return '${count}x Wrong';
  }

  @override
  String deck_progress_accurate_percent(int percent) {
    return '$percent% Accurate';
  }

  @override
  String get flashcard_title => 'Flashcard';

  @override
  String get flashcard_instruction =>
      'Read the word below and flip the card to see its meaning:';

  @override
  String flashcard_card_progress(int current, int total) {
    return 'Card $current of $total';
  }

  @override
  String get flashcard_question_label => 'Question';

  @override
  String get flashcard_answer_label => 'Answer';

  @override
  String get flashcard_tap_to_flip => 'Tap to see meaning';

  @override
  String get flashcard_flip_button => 'Flip Card';

  @override
  String get flashcard_not_memorized => 'Not memorized';

  @override
  String get flashcard_memorized => 'Memorized';

  @override
  String get flashcard_complete_title => 'Practice Complete';

  @override
  String flashcard_complete_cards_value(int count) {
    return '${count}Card';
  }

  @override
  String get flashcard_complete_memorized_label => 'Memorized';

  @override
  String get flashcard_complete_not_memorized_label => 'Not Memorized';

  @override
  String flashcard_complete_active_time_value(int minutes, int seconds) {
    return '+${minutes}m ${seconds}s';
  }

  @override
  String get flashcard_complete_active_time_label => 'Session Active Time';

  @override
  String get flashcard_complete_finish_button => 'Done';

  @override
  String get quiz_title => 'Quiz';

  @override
  String get quiz_mc_instruction =>
      'Choose the matching meaning for the word below:';

  @override
  String get quiz_context_instruction =>
      'Guess the vocabulary word based on this usage context:';

  @override
  String get quiz_jumble_instruction =>
      'Arrange the translation for this word:';

  @override
  String get quiz_jumble_placeholder => 'Tap words below to arrange them here';

  @override
  String get quiz_check_answer_button => 'Check Answer';

  @override
  String get quiz_feedback_correct_title => 'Spot On Answer';

  @override
  String get quiz_feedback_wrong_title => 'The correct answer is';

  @override
  String get quiz_continue_button => 'Continue';

  @override
  String quiz_complete_score_value(int correct, int total) {
    return '$correct / $total';
  }

  @override
  String get quiz_complete_correct_label => 'Correct Answers';

  @override
  String get deck_history_title => 'Activity History';

  @override
  String get deck_history_period_week => 'This week';

  @override
  String get deck_history_period_month => 'This month';

  @override
  String get deck_history_period_year => 'This year';

  @override
  String get deck_history_summary_week => 'This Week\'s Summary';

  @override
  String get deck_history_summary_month => 'This Month\'s Summary';

  @override
  String get deck_history_summary_year => 'This Year\'s Summary';

  @override
  String get deck_history_total_activities => 'Total Activities';

  @override
  String get deck_history_study_time => 'Study Time';

  @override
  String get deck_history_avg_accuracy => 'Avg. Accuracy';

  @override
  String deck_history_sessions_count(int count) {
    return '$count sessions';
  }

  @override
  String get deck_history_activities_title => 'Study Activities';

  @override
  String deck_history_activities_count(int count) {
    return '$count activities';
  }

  @override
  String get deck_history_empty_title => 'No Activities Yet';

  @override
  String get deck_history_empty_subtitle =>
      'Complete flashcard or quiz sessions to see your history here.';

  @override
  String get deck_history_quiz_label => 'Word Quiz';

  @override
  String get deck_history_flashcard_label => 'Flashcard';

  @override
  String deck_history_score_badge(int correct, int total) {
    return '$correct / $total Correct';
  }

  @override
  String deck_history_minutes_badge(int minutes) {
    return '$minutes Min';
  }

  @override
  String deck_history_seconds_badge(int seconds) {
    return '$seconds Sec';
  }

  @override
  String get deck_history_sheet_correct_answers => 'Correct Answers';

  @override
  String get deck_history_sheet_session_duration => 'Session Duration';

  @override
  String get deck_history_sheet_accuracy => 'Accuracy';

  @override
  String get deck_history_sheet_cards_studied => 'Cards studied';

  @override
  String get deck_history_sheet_mastered => 'Mastered';

  @override
  String get deck_history_sheet_needs_review => 'Needs Review';

  @override
  String get deck_history_sheet_close => 'Close details';

  @override
  String get deck_history_time_today => 'Today';

  @override
  String get deck_history_time_yesterday => 'Yesterday';

  @override
  String get nav_multiplayer => 'League';

  @override
  String get multiplayer_title => 'Play Together';

  @override
  String get multiplayer_banner_title => 'Practice with Friends';

  @override
  String get multiplayer_banner_desc =>
      'Cooperative learning for 2 players on the same Wi-Fi without internet quota.';

  @override
  String get multiplayer_create_room => 'Create New Room';

  @override
  String get multiplayer_create_room_desc => 'Set your device as host';

  @override
  String get multiplayer_join_room => 'Join Room';

  @override
  String get multiplayer_join_room_desc => 'Join an existing room';

  @override
  String get multiplayer_room_title => 'Room';

  @override
  String get multiplayer_room_ip_label => 'THIS DEVICE ADDRESS';

  @override
  String get multiplayer_room_scan_label => 'or scan this code';

  @override
  String get multiplayer_room_waiting =>
      'Waiting for data from another device...';

  @override
  String get multiplayer_room_wifi_note =>
      'Make sure both devices are connected to the same Wi-Fi network.';

  @override
  String get multiplayer_join_scan_qr => 'Tap to scan Host QR';

  @override
  String get multiplayer_join_or_scan => 'or enter IP address';

  @override
  String get multiplayer_join_ip_placeholder => 'Enter Host IP Address....';

  @override
  String get multiplayer_join_button => 'Join Room';

  @override
  String get multiplayer_lobby_title => 'Practice Lobby';

  @override
  String multiplayer_lobby_connected_count(int current, int total) {
    return 'Connected Players ($current/$total)';
  }

  @override
  String get multiplayer_lobby_role_host => 'Clue Giver';

  @override
  String get multiplayer_lobby_role_guesser => 'Guesser';

  @override
  String get multiplayer_lobby_ready => 'Ready';

  @override
  String get multiplayer_lobby_start_button => 'Choose Deck';

  @override
  String get multiplayer_lobby_waiting_host =>
      'Waiting for Host to choose deck...';

  @override
  String get multiplayer_select_deck_title => 'Choose Deck';

  @override
  String get multiplayer_select_deck_search => 'Search your deck...';

  @override
  String get multiplayer_game_title => 'Practice Together';

  @override
  String multiplayer_host_elaborate_prompt(String name) {
    return 'Explain to $name regarding the word above';
  }

  @override
  String multiplayer_guesser_listen_prompt(String name) {
    return 'Listen to explanation from $name';
  }

  @override
  String multiplayer_guesser_waiting_title(String name) {
    return 'Waiting for Answer from $name....';
  }

  @override
  String multiplayer_guesser_waiting_desc(String name) {
    return '$name (Clue Giver) is choosing an answer from the system. Stay relaxed and get ready!';
  }

  @override
  String get multiplayer_score_plus => '+1';

  @override
  String get multiplayer_score_minus => '-1';

  @override
  String get multiplayer_score_zero => '+0';

  @override
  String get multiplayer_score_label => 'Points';

  @override
  String get multiplayer_score_total => 'Your Current Total Score:';

  @override
  String multiplayer_score_points(int score) {
    return '$score Points';
  }

  @override
  String get multiplayer_continue_button => 'Continue Question';

  @override
  String get multiplayer_complete_title => 'Practice Session Completed';

  @override
  String multiplayer_complete_correct_count(int correct, int total) {
    return '$correct / $total';
  }

  @override
  String get multiplayer_complete_correct_label => 'Correct Answers';

  @override
  String get multiplayer_complete_time_label => 'Session Active Time';

  @override
  String get multiplayer_back_button => 'Back';

  @override
  String get multiplayer_history_title => 'Multiplayer History';

  @override
  String get multiplayer_leave_confirm_title => 'Leave Room?';

  @override
  String get multiplayer_leave_confirm_desc =>
      'The practice session will end for both players.';

  @override
  String get multiplayer_leave_confirm_yes => 'Leave';

  @override
  String get multiplayer_leave_confirm_no => 'Cancel';

  @override
  String get ai_mode_choose_title => 'Choose AI processing mode';

  @override
  String get ai_mode_choose_subtitle =>
      'Determine how BASA AI creates vocabulary cards for you. This choice can be changed at any time in Settings.';

  @override
  String get ai_mode_feature_header => 'Feature';

  @override
  String get ai_mode_online_header => 'Online';

  @override
  String get ai_mode_local_header => 'Local';

  @override
  String get ai_feature_unlimited_generation =>
      'Generate deck without limitations';

  @override
  String get ai_feature_offline_use => 'Can be used without internet (offline)';

  @override
  String get ai_feature_private_storage =>
      'Data stored securely on device (private)';

  @override
  String get ai_feature_faster_process => 'Faster generation process';

  @override
  String get ai_feature_broader_context =>
      'Broader & dynamic vocabulary context';

  @override
  String get ai_feature_more_accurate => 'More accurate vocabulary results';

  @override
  String get ai_feature_daily_limit => '1 deck per day limit';

  @override
  String get ai_feature_requires_internet => 'Requires internet connection';

  @override
  String get ai_feature_data_training => 'Data used to train AI';

  @override
  String get ai_button_start_download => 'Start Download (2.59GB)';

  @override
  String get ai_button_continue_online => 'continue using online model';

  @override
  String get ai_download_progress_title => 'Local AI Download in Progress...';

  @override
  String get ai_download_continue_in_background => 'Continue in Background';

  @override
  String get ai_download_retry => 'Retry Download';

  @override
  String get ai_download_error_title => 'Download Failed';

  @override
  String get ai_download_complete_title => 'AI Download Successful';

  @override
  String get ai_download_complete_subtitle =>
      'Your profile is ready to use. Let\'s continue your learning journey calmly.';

  @override
  String get ai_download_complete_button => 'Done';

  @override
  String get settings_ai_title => 'AI Processing Mode';

  @override
  String get settings_ai_subtitle =>
      'Configure AI processing model and Gemini API';

  @override
  String get settings_gemini_api_key => 'Gemini API Key';

  @override
  String get settings_gemini_api_key_desc =>
      'Required for Online AI generation';

  @override
  String get settings_gemini_api_key_hint => 'Enter your Gemini API key...';

  @override
  String get settings_gemini_guide => 'Gemini API Setup Guide';

  @override
  String get settings_local_model_status => 'Local Model Status';

  @override
  String settings_local_model_downloaded(String size) {
    return 'Downloaded ($size)';
  }

  @override
  String get settings_local_model_not_downloaded => 'Not Downloaded';

  @override
  String get settings_download_local_model => 'Download Local Model (2.59GB)';

  @override
  String get settings_delete_local_model => 'Delete Local Model';

  @override
  String get deck_gen_online_daily_limit_reached =>
      'Online generation limit reached (maximum 1 deck per day). Please use Local AI or try again tomorrow.';

  @override
  String get settings_cancel_download => 'Cancel';

  @override
  String get settings_delete_local_model_confirm_title =>
      'Delete Local AI Model?';

  @override
  String get settings_delete_local_model_confirm_desc =>
      'This will remove the 2.59 GB model file from device storage. You can download it again anytime.';

  @override
  String get settings_local_model_downloading =>
      'Downloading local AI model...';

  @override
  String get end_of_translation => '';
}
