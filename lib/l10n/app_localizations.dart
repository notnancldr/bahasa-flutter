import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In id, this message translates to:
  /// **'Basa'**
  String get appTitle;

  /// No description provided for @welcome_startUsing.
  ///
  /// In id, this message translates to:
  /// **'Mulai Gunakan'**
  String get welcome_startUsing;

  /// No description provided for @welcome_description.
  ///
  /// In id, this message translates to:
  /// **'Pilih cara Anda memulai pembelajaran hari ini.'**
  String get welcome_description;

  /// No description provided for @welcome_newProfile_title.
  ///
  /// In id, this message translates to:
  /// **'Buat Profil Baru'**
  String get welcome_newProfile_title;

  /// No description provided for @welcome_newProfile_description.
  ///
  /// In id, this message translates to:
  /// **'Mulai dari awal dengan profil baru.'**
  String get welcome_newProfile_description;

  /// No description provided for @welcome_transfer_title.
  ///
  /// In id, this message translates to:
  /// **'Pindahkan Profil Lama'**
  String get welcome_transfer_title;

  /// No description provided for @welcome_transfer_description.
  ///
  /// In id, this message translates to:
  /// **'Pindahkan profil dari perangkat lama Anda.'**
  String get welcome_transfer_description;

  /// No description provided for @welcome_nextButton.
  ///
  /// In id, this message translates to:
  /// **'Mulai Sekarang'**
  String get welcome_nextButton;

  /// No description provided for @newProfile_title.
  ///
  /// In id, this message translates to:
  /// **'Registrasi Profil'**
  String get newProfile_title;

  /// No description provided for @newProfile_step_username_title.
  ///
  /// In id, this message translates to:
  /// **'Masukkan Username'**
  String get newProfile_step_username_title;

  /// No description provided for @newProfile_step_username_description.
  ///
  /// In id, this message translates to:
  /// **'Nama ini akan digunakan sebagai tampilan akun belajar Anda di perangkat ini'**
  String get newProfile_step_username_description;

  /// No description provided for @newProfile_step_username_fieldName.
  ///
  /// In id, this message translates to:
  /// **'Username'**
  String get newProfile_step_username_fieldName;

  /// No description provided for @newProfile_step_username_fieldPlaceholder.
  ///
  /// In id, this message translates to:
  /// **'Masukkan username...'**
  String get newProfile_step_username_fieldPlaceholder;

  /// No description provided for @newProfile_step_username_fieldHint.
  ///
  /// In id, this message translates to:
  /// **'Dapat menggunakan huruf, angka, atau tanda titik.'**
  String get newProfile_step_username_fieldHint;

  /// No description provided for @newProfile_step_language_title.
  ///
  /// In id, this message translates to:
  /// **'Pilih Bahasa Utama'**
  String get newProfile_step_language_title;

  /// No description provided for @newProfile_step_language_description.
  ///
  /// In id, this message translates to:
  /// **'Bahasa ini akan digunakan sebagai bahasa utama navigasi dan pengantar latihan.'**
  String get newProfile_step_language_description;

  /// No description provided for @newProfile_step_language_search.
  ///
  /// In id, this message translates to:
  /// **'Cari bahasa...'**
  String get newProfile_step_language_search;

  /// No description provided for @newProfile_nextButton.
  ///
  /// In id, this message translates to:
  /// **'Lanjutkan'**
  String get newProfile_nextButton;

  /// No description provided for @newProfile_saveButton.
  ///
  /// In id, this message translates to:
  /// **'Simpan'**
  String get newProfile_saveButton;

  /// No description provided for @newProfile_complete_title.
  ///
  /// In id, this message translates to:
  /// **'Profil Berhasil Dibuat'**
  String get newProfile_complete_title;

  /// No description provided for @newProfile_complete_description.
  ///
  /// In id, this message translates to:
  /// **'Profilmu sudah siap digunakan. Mari lanjutkan pengalaman belajarmu dengan tenang.'**
  String get newProfile_complete_description;

  /// No description provided for @securityFootnote.
  ///
  /// In id, this message translates to:
  /// **'Profil Anda tersimpan aman di perangkat ini tanpa kata sandi'**
  String get securityFootnote;

  /// No description provided for @transfer_listening_title.
  ///
  /// In id, this message translates to:
  /// **'Menunggu Perangkat Lain'**
  String get transfer_listening_title;

  /// No description provided for @transfer_listening_description.
  ///
  /// In id, this message translates to:
  /// **'Buka [NAMA_APLIKASI :v] di perangkat lama, lalu masukkan alamat berikut untuk memulai pemindahan profil.'**
  String get transfer_listening_description;

  /// No description provided for @transfer_listening_address.
  ///
  /// In id, this message translates to:
  /// **'Alamat Perangkat Ini'**
  String get transfer_listening_address;

  /// No description provided for @transfer_listening_aboveQr.
  ///
  /// In id, this message translates to:
  /// **'atau pindai kode ini'**
  String get transfer_listening_aboveQr;

  /// No description provided for @transfer_listening_belowQr.
  ///
  /// In id, this message translates to:
  /// **'Menunggu data dari perangkat lain...'**
  String get transfer_listening_belowQr;

  /// No description provided for @transfer_listening_note.
  ///
  /// In id, this message translates to:
  /// **'Pastikan kedua perangkat terhubung ke jaringan Wi-Fi yang sama.'**
  String get transfer_listening_note;

  /// No description provided for @transfer_receive_name.
  ///
  /// In id, this message translates to:
  /// **'Penerimaan Berkas'**
  String get transfer_receive_name;

  /// No description provided for @transfer_receive_title.
  ///
  /// In id, this message translates to:
  /// **'Menerima Berkas'**
  String get transfer_receive_title;

  /// No description provided for @transfer_receive_description.
  ///
  /// In id, this message translates to:
  /// **'Mohon tunggu, berkas profil Anda sedang dalam proses transfer.'**
  String get transfer_receive_description;

  /// No description provided for @transfer_receive_process.
  ///
  /// In id, this message translates to:
  /// **'Sedang menerima'**
  String get transfer_receive_process;

  /// No description provided for @transfer_checkValid_name.
  ///
  /// In id, this message translates to:
  /// **'Pemeriksaan Berkas'**
  String get transfer_checkValid_name;

  /// No description provided for @transfer_checkValid_title.
  ///
  /// In id, this message translates to:
  /// **'Memvalidasi Berkas'**
  String get transfer_checkValid_title;

  /// No description provided for @transfer_checkValid_description.
  ///
  /// In id, this message translates to:
  /// **'Mohon tunggu sebentar, sistem sedang memastikan berkas yang diterima aman dan lengkap.'**
  String get transfer_checkValid_description;

  /// No description provided for @transfer_checkValid_process.
  ///
  /// In id, this message translates to:
  /// **'Sedang memindai'**
  String get transfer_checkValid_process;

  /// No description provided for @transfer_checkValid_info_title.
  ///
  /// In id, this message translates to:
  /// **'Memeriksa data profil...'**
  String get transfer_checkValid_info_title;

  /// No description provided for @transfer_checkValid_info_description.
  ///
  /// In id, this message translates to:
  /// **'Memeriksa kelengkapan riwayat belajar, kosakata tersimpan, dan integritas data profil.'**
  String get transfer_checkValid_info_description;

  /// No description provided for @transfer_complete_title.
  ///
  /// In id, this message translates to:
  /// **'Profil Berhasil Dipindahkan'**
  String get transfer_complete_title;

  /// No description provided for @transfer_complete_description.
  ///
  /// In id, this message translates to:
  /// **'Profilmu sudah siap digunakan. Mari lanjutkan perjalanan belajarmu dengan tenang.'**
  String get transfer_complete_description;

  /// No description provided for @transfer_complete_profileInfo_title.
  ///
  /// In id, this message translates to:
  /// **'Info Profil'**
  String get transfer_complete_profileInfo_title;

  /// No description provided for @joinSince.
  ///
  /// In id, this message translates to:
  /// **'Bergabung sejak'**
  String get joinSince;

  /// No description provided for @username.
  ///
  /// In id, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @defaultLanguage.
  ///
  /// In id, this message translates to:
  /// **'Bahasa default'**
  String get defaultLanguage;

  /// No description provided for @process_preparing.
  ///
  /// In id, this message translates to:
  /// **'Menyiapkan'**
  String get process_preparing;

  /// No description provided for @process_gettingReady.
  ///
  /// In id, this message translates to:
  /// **'Mempersiapkan semuanya'**
  String get process_gettingReady;

  /// No description provided for @process_process.
  ///
  /// In id, this message translates to:
  /// **'Memproses'**
  String get process_process;

  /// No description provided for @process_loading.
  ///
  /// In id, this message translates to:
  /// **'Memuat'**
  String get process_loading;

  /// No description provided for @back.
  ///
  /// In id, this message translates to:
  /// **'Kembali'**
  String get back;

  /// No description provided for @cancel.
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get cancel;

  /// No description provided for @done.
  ///
  /// In id, this message translates to:
  /// **'Selesai'**
  String get done;

  /// No description provided for @tryAgain.
  ///
  /// In id, this message translates to:
  /// **'Coba Lagi'**
  String get tryAgain;

  /// No description provided for @copy.
  ///
  /// In id, this message translates to:
  /// **'Salin'**
  String get copy;

  /// No description provided for @paste.
  ///
  /// In id, this message translates to:
  /// **'tempel'**
  String get paste;

  /// No description provided for @copied.
  ///
  /// In id, this message translates to:
  /// **'Disalin!'**
  String get copied;

  /// No description provided for @pasted.
  ///
  /// In id, this message translates to:
  /// **'Dikutip!'**
  String get pasted;

  /// Display name of a language, resolved from its ISO 639-1 code
  ///
  /// In id, this message translates to:
  /// **'{code, select, id{Indonesia} en{Inggris} es{Spanyol} ja{Jepang} ko{Korea} fr{Prancis} ru{Rusia} ar{Arab} de{Jerman} pt{Portugis} zh{Mandarin} hi{Hindi} other{{code}}}'**
  String languageName(String code);

  /// No description provided for @step.
  ///
  /// In id, this message translates to:
  /// **'{first} dari {second}'**
  String step(int first, int second);

  /// No description provided for @end_of_translation.
  ///
  /// In id, this message translates to:
  /// **''**
  String get end_of_translation;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
