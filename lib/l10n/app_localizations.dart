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

  /// No description provided for @transfer_error_invalid_title.
  ///
  /// In id, this message translates to:
  /// **'Data Tidak Valid'**
  String get transfer_error_invalid_title;

  /// No description provided for @transfer_error_invalid_description.
  ///
  /// In id, this message translates to:
  /// **'Proses pemindahan terputus sebelum semua data profil Anda selesai disalin ke perangkat ini.'**
  String get transfer_error_invalid_description;

  /// No description provided for @transfer_error_cleanup_title.
  ///
  /// In id, this message translates to:
  /// **'Data yang gagal sudah kami hapus dari perangkat ini.'**
  String get transfer_error_cleanup_title;

  /// No description provided for @transfer_error_cleanup_description.
  ///
  /// In id, this message translates to:
  /// **'Penyimpanan lokal perangkat tetap bersih dan aman.'**
  String get transfer_error_cleanup_description;

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

  /// No description provided for @settings_title.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get settings_title;

  /// No description provided for @settings_manageProfile.
  ///
  /// In id, this message translates to:
  /// **'Kelola profil'**
  String get settings_manageProfile;

  /// No description provided for @settings_activeStudent.
  ///
  /// In id, this message translates to:
  /// **'Pelajar Aktif'**
  String get settings_activeStudent;

  /// No description provided for @settings_account_title.
  ///
  /// In id, this message translates to:
  /// **'Akun'**
  String get settings_account_title;

  /// No description provided for @settings_account_subtitle.
  ///
  /// In id, this message translates to:
  /// **'Ubah nama pengguna & foto'**
  String get settings_account_subtitle;

  /// No description provided for @settings_theme_title.
  ///
  /// In id, this message translates to:
  /// **'Tema'**
  String get settings_theme_title;

  /// No description provided for @settings_theme_subtitleLight.
  ///
  /// In id, this message translates to:
  /// **'Mode terang (nyaman di mata)'**
  String get settings_theme_subtitleLight;

  /// No description provided for @settings_theme_subtitleDark.
  ///
  /// In id, this message translates to:
  /// **'Mode gelap (hemat baterai)'**
  String get settings_theme_subtitleDark;

  /// No description provided for @settings_theme_badgeLight.
  ///
  /// In id, this message translates to:
  /// **'Terang'**
  String get settings_theme_badgeLight;

  /// No description provided for @settings_theme_badgeDark.
  ///
  /// In id, this message translates to:
  /// **'Gelap'**
  String get settings_theme_badgeDark;

  /// No description provided for @settings_notif_title.
  ///
  /// In id, this message translates to:
  /// **'Notifikasi'**
  String get settings_notif_title;

  /// No description provided for @settings_notif_subtitle.
  ///
  /// In id, this message translates to:
  /// **'Pengingat belajar harian'**
  String get settings_notif_subtitle;

  /// No description provided for @settings_data_title.
  ///
  /// In id, this message translates to:
  /// **'Data & Penyimpanan'**
  String get settings_data_title;

  /// No description provided for @settings_data_subtitle.
  ///
  /// In id, this message translates to:
  /// **'Impor, ekspor, & cadangan profil'**
  String get settings_data_subtitle;

  /// No description provided for @account_joinedSince.
  ///
  /// In id, this message translates to:
  /// **'Bergabung sejak 2026.'**
  String get account_joinedSince;

  /// No description provided for @account_editProfile.
  ///
  /// In id, this message translates to:
  /// **'Edit Profil'**
  String get account_editProfile;

  /// No description provided for @account_editProfile_subtitle.
  ///
  /// In id, this message translates to:
  /// **'Ubah foto atau username.'**
  String get account_editProfile_subtitle;

  /// No description provided for @account_deleteProfile.
  ///
  /// In id, this message translates to:
  /// **'Hapus Profil'**
  String get account_deleteProfile;

  /// No description provided for @account_deleteProfile_subtitle.
  ///
  /// In id, this message translates to:
  /// **'Hapus akun dan semua data secara permanen.'**
  String get account_deleteProfile_subtitle;

  /// No description provided for @account_footer.
  ///
  /// In id, this message translates to:
  /// **'Basa • Sahabat Belajar Bahasa Anda'**
  String get account_footer;

  /// No description provided for @account_delete_dialogTitle.
  ///
  /// In id, this message translates to:
  /// **'Hapus profil ini?'**
  String get account_delete_dialogTitle;

  /// No description provided for @account_delete_dialogBody.
  ///
  /// In id, this message translates to:
  /// **'Semua data belajarmu akan dihapus secara permanen dan tidak dapat dikembalikan.'**
  String get account_delete_dialogBody;

  /// No description provided for @account_delete_confirmButton.
  ///
  /// In id, this message translates to:
  /// **'Hapus'**
  String get account_delete_confirmButton;

  /// No description provided for @editProfile_title.
  ///
  /// In id, this message translates to:
  /// **'Edit Profil'**
  String get editProfile_title;

  /// No description provided for @editProfile_subtitle.
  ///
  /// In id, this message translates to:
  /// **'Kelola informasi publik dan akun belajar kamu.'**
  String get editProfile_subtitle;

  /// No description provided for @editProfile_changePhoto.
  ///
  /// In id, this message translates to:
  /// **'Ganti Foto'**
  String get editProfile_changePhoto;

  /// No description provided for @editProfile_usernameLabel.
  ///
  /// In id, this message translates to:
  /// **'Username'**
  String get editProfile_usernameLabel;

  /// No description provided for @editProfile_usernameHint.
  ///
  /// In id, this message translates to:
  /// **'Dapat menggunakan huruf, angka, atau tanda titik.'**
  String get editProfile_usernameHint;

  /// No description provided for @editProfile_tipTitle.
  ///
  /// In id, this message translates to:
  /// **'Tips Komunitas Basa'**
  String get editProfile_tipTitle;

  /// No description provided for @editProfile_tipBody.
  ///
  /// In id, this message translates to:
  /// **'Username ini akan terlihat oleh teman sebaya pada papan peringkat mingguan.'**
  String get editProfile_tipBody;

  /// No description provided for @editProfile_saveButton.
  ///
  /// In id, this message translates to:
  /// **'Simpan Perubahan'**
  String get editProfile_saveButton;

  /// No description provided for @theme_title.
  ///
  /// In id, this message translates to:
  /// **'Tema'**
  String get theme_title;

  /// No description provided for @theme_subtitle.
  ///
  /// In id, this message translates to:
  /// **'Pilih tampilan yang paling nyaman untukmu.'**
  String get theme_subtitle;

  /// No description provided for @theme_light.
  ///
  /// In id, this message translates to:
  /// **'Mode Terang'**
  String get theme_light;

  /// No description provided for @theme_dark.
  ///
  /// In id, this message translates to:
  /// **'Mode Gelap'**
  String get theme_dark;

  /// No description provided for @data_sectionStorage.
  ///
  /// In id, this message translates to:
  /// **'PENGGUNAAN PENYIMPANAN'**
  String get data_sectionStorage;

  /// No description provided for @data_download.
  ///
  /// In id, this message translates to:
  /// **'Unduhan Kosakata'**
  String get data_download;

  /// No description provided for @data_downloadSubtitle.
  ///
  /// In id, this message translates to:
  /// **'{sizeStr} tersimpan offline'**
  String data_downloadSubtitle(String sizeStr);

  /// No description provided for @data_clear.
  ///
  /// In id, this message translates to:
  /// **'Bersihkan'**
  String get data_clear;

  /// No description provided for @data_sectionDataTransfer.
  ///
  /// In id, this message translates to:
  /// **'TRANSFER DATA'**
  String get data_sectionDataTransfer;

  /// No description provided for @data_dataTransfer.
  ///
  /// In id, this message translates to:
  /// **'Transfer Data'**
  String get data_dataTransfer;

  /// No description provided for @data_dataTransfer_subtitle.
  ///
  /// In id, this message translates to:
  /// **'Transfer profil ke perangkat baru'**
  String get data_dataTransfer_subtitle;

  /// No description provided for @data_sectionDanger.
  ///
  /// In id, this message translates to:
  /// **'TINDAKAN LANJUTAN'**
  String get data_sectionDanger;

  /// No description provided for @data_deleteData.
  ///
  /// In id, this message translates to:
  /// **'Hapus Data'**
  String get data_deleteData;

  /// No description provided for @data_deleteData_subtitle.
  ///
  /// In id, this message translates to:
  /// **'Hapus seluruh riwayat dan progres'**
  String get data_deleteData_subtitle;

  /// No description provided for @shareData_title.
  ///
  /// In id, this message translates to:
  /// **'Bagikan Data'**
  String get shareData_title;

  /// No description provided for @shareData_subtitle.
  ///
  /// In id, this message translates to:
  /// **'Masukkan IP dari perangkat penerima untuk mengirim data.'**
  String get shareData_subtitle;

  /// No description provided for @shareData_ipLabel.
  ///
  /// In id, this message translates to:
  /// **'Alamat IP Penerima'**
  String get shareData_ipLabel;

  /// No description provided for @shareData_ipPlaceholder.
  ///
  /// In id, this message translates to:
  /// **'Masukkan alamat IP...'**
  String get shareData_ipPlaceholder;

  /// No description provided for @shareData_startButton.
  ///
  /// In id, this message translates to:
  /// **'Mulai Transfer'**
  String get shareData_startButton;

  /// No description provided for @shareData_sending_overline.
  ///
  /// In id, this message translates to:
  /// **'DATA & PENYIMPANAN'**
  String get shareData_sending_overline;

  /// No description provided for @shareData_sending_title.
  ///
  /// In id, this message translates to:
  /// **'Sedang Mengirim Data'**
  String get shareData_sending_title;

  /// No description provided for @shareData_sending_status.
  ///
  /// In id, this message translates to:
  /// **'Mohon tunggu, data sedang diproses...'**
  String get shareData_sending_status;

  /// No description provided for @shareData_sending_note.
  ///
  /// In id, this message translates to:
  /// **'Jangan tutup aplikasi selama proses berlangsung.'**
  String get shareData_sending_note;

  /// No description provided for @shareData_failed_title.
  ///
  /// In id, this message translates to:
  /// **'Transfer gagal'**
  String get shareData_failed_title;

  /// No description provided for @shareData_failed_body.
  ///
  /// In id, this message translates to:
  /// **'Koneksi terputus atau kode sudah tidak berlaku. Coba lagi?'**
  String get shareData_failed_body;

  /// No description provided for @shareData_failed_no.
  ///
  /// In id, this message translates to:
  /// **'Tidak'**
  String get shareData_failed_no;

  /// No description provided for @deleteData_dialog_title.
  ///
  /// In id, this message translates to:
  /// **'Hapus semua data?'**
  String get deleteData_dialog_title;

  /// No description provided for @deleteData_dialog_body.
  ///
  /// In id, this message translates to:
  /// **'Tindakan ini tidak dapat dibatalkan. Ketik username kamu untuk mengonfirmasi.'**
  String get deleteData_dialog_body;

  /// No description provided for @deleteData_dialog_confirmButton.
  ///
  /// In id, this message translates to:
  /// **'Hapus Data'**
  String get deleteData_dialog_confirmButton;

  /// No description provided for @deleteData_success_title.
  ///
  /// In id, this message translates to:
  /// **'Data berhasil dihapus'**
  String get deleteData_success_title;

  /// No description provided for @deleteData_success_body.
  ///
  /// In id, this message translates to:
  /// **'Akunmu tetap ada. Kamu bisa mulai belajar dari awal kapan pun.'**
  String get deleteData_success_body;

  /// No description provided for @deleteData_success_homeButton.
  ///
  /// In id, this message translates to:
  /// **'Kembali ke Beranda'**
  String get deleteData_success_homeButton;

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
