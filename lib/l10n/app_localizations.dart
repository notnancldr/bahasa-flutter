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

  /// No description provided for @welcome_sync_title.
  ///
  /// In id, this message translates to:
  /// **'Sinkronisasi Profil'**
  String get welcome_sync_title;

  /// No description provided for @welcome_sync_description.
  ///
  /// In id, this message translates to:
  /// **'Pindahkan profil dari perangkat lama.'**
  String get welcome_sync_description;

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

  /// No description provided for @done.
  ///
  /// In id, this message translates to:
  /// **'Selesai'**
  String get done;

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
