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

  /// No description provided for @settings_language_title.
  ///
  /// In id, this message translates to:
  /// **'Bahasa'**
  String get settings_language_title;

  /// No description provided for @settings_language_subtitle.
  ///
  /// In id, this message translates to:
  /// **'Pilih bahasa utama aplikasi'**
  String get settings_language_subtitle;

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
  /// **'Penyimpanan kosakata dan transfer data'**
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

  /// No description provided for @shareData_or.
  ///
  /// In id, this message translates to:
  /// **'atau'**
  String get shareData_or;

  /// No description provided for @shareData_scanQrButton.
  ///
  /// In id, this message translates to:
  /// **'Pindai Kode QR'**
  String get shareData_scanQrButton;

  /// No description provided for @shareData_scanner_title.
  ///
  /// In id, this message translates to:
  /// **'Pindai QR Penerima'**
  String get shareData_scanner_title;

  /// No description provided for @shareData_scanner_instruction.
  ///
  /// In id, this message translates to:
  /// **'Arahkan kamera ke kode QR di perangkat penerima'**
  String get shareData_scanner_instruction;

  /// No description provided for @shareData_scanner_permission_denied.
  ///
  /// In id, this message translates to:
  /// **'Izin kamera diperlukan untuk memindai kode QR'**
  String get shareData_scanner_permission_denied;

  /// No description provided for @shareData_scanner_error.
  ///
  /// In id, this message translates to:
  /// **'Tidak dapat mengakses kamera'**
  String get shareData_scanner_error;

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

  /// No description provided for @home_consecutiveDays.
  ///
  /// In id, this message translates to:
  /// **'Hari Beruntun'**
  String get home_consecutiveDays;

  /// No description provided for @home_emptyDeckTitle.
  ///
  /// In id, this message translates to:
  /// **'Kamu belum punya deck!'**
  String get home_emptyDeckTitle;

  /// No description provided for @home_createDeckButton.
  ///
  /// In id, this message translates to:
  /// **'Buat Deck'**
  String get home_createDeckButton;

  /// No description provided for @home_rarelyStudied.
  ///
  /// In id, this message translates to:
  /// **'Jarang Dipelajari'**
  String get home_rarelyStudied;

  /// No description provided for @home_reviewButton.
  ///
  /// In id, this message translates to:
  /// **'Ulas'**
  String get home_reviewButton;

  /// No description provided for @home_lastStudiedDaysAgo.
  ///
  /// In id, this message translates to:
  /// **'Terakhir dipelajari {days} hari lalu.'**
  String home_lastStudiedDaysAgo(int days);

  /// No description provided for @home_recentActivityTitle.
  ///
  /// In id, this message translates to:
  /// **'Aktivitas Terakhir'**
  String get home_recentActivityTitle;

  /// Subtitle for recent activity item showing card count and time description
  ///
  /// In id, this message translates to:
  /// **'{cards, plural, other{{cards} kartu}} • {unit, select, hoursAgo{{time} jam lalu} yesterday{Kemarin} daysAgo{{time} hari lalu} other{{time}}}'**
  String home_recentActivitySubtitle(int cards, int time, String unit);

  /// No description provided for @home_cardsCount.
  ///
  /// In id, this message translates to:
  /// **'{count} kartu'**
  String home_cardsCount(int count);

  /// No description provided for @home_timeHoursAgo.
  ///
  /// In id, this message translates to:
  /// **'{hours} jam lalu'**
  String home_timeHoursAgo(int hours);

  /// No description provided for @home_timeYesterday.
  ///
  /// In id, this message translates to:
  /// **'Kemarin'**
  String get home_timeYesterday;

  /// No description provided for @home_timeDaysAgo.
  ///
  /// In id, this message translates to:
  /// **'{days} hari lalu'**
  String home_timeDaysAgo(int days);

  /// No description provided for @deck_method_title.
  ///
  /// In id, this message translates to:
  /// **'Tambah Deck Baru'**
  String get deck_method_title;

  /// No description provided for @deck_method_subtitle.
  ///
  /// In id, this message translates to:
  /// **'Pilih cara kamu ingin membuat deck.'**
  String get deck_method_subtitle;

  /// No description provided for @deck_method_generate_title.
  ///
  /// In id, this message translates to:
  /// **'Generate Deck'**
  String get deck_method_generate_title;

  /// No description provided for @deck_method_generate_subtitle.
  ///
  /// In id, this message translates to:
  /// **'Buat deck baru secara otomatis.'**
  String get deck_method_generate_subtitle;

  /// No description provided for @deck_method_generate_cta.
  ///
  /// In id, this message translates to:
  /// **'Mulai'**
  String get deck_method_generate_cta;

  /// No description provided for @deck_method_import_title.
  ///
  /// In id, this message translates to:
  /// **'Impor Deck'**
  String get deck_method_import_title;

  /// No description provided for @deck_method_import_subtitle.
  ///
  /// In id, this message translates to:
  /// **'Gunakan berkas .euy yang sudah ada.'**
  String get deck_method_import_subtitle;

  /// No description provided for @deck_method_import_cta.
  ///
  /// In id, this message translates to:
  /// **'Pilih Berkas'**
  String get deck_method_import_cta;

  /// No description provided for @deck_gen_appbar_title.
  ///
  /// In id, this message translates to:
  /// **'Generate Deck'**
  String get deck_gen_appbar_title;

  /// No description provided for @deck_gen_name_title.
  ///
  /// In id, this message translates to:
  /// **'Beri nama deck-mu'**
  String get deck_gen_name_title;

  /// No description provided for @deck_gen_name_desc.
  ///
  /// In id, this message translates to:
  /// **'Nama ini akan muncul di daftar deck kamu.'**
  String get deck_gen_name_desc;

  /// No description provided for @deck_gen_name_label.
  ///
  /// In id, this message translates to:
  /// **'Nama Deck'**
  String get deck_gen_name_label;

  /// No description provided for @deck_gen_name_hint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: Kosakata Dasar Jepang...'**
  String get deck_gen_name_hint;

  /// No description provided for @deck_gen_country_title.
  ///
  /// In id, this message translates to:
  /// **'Pilih Negara'**
  String get deck_gen_country_title;

  /// No description provided for @deck_gen_country_desc.
  ///
  /// In id, this message translates to:
  /// **'Konten deck akan disesuaikan dengan negara ini.'**
  String get deck_gen_country_desc;

  /// No description provided for @deck_gen_country_search.
  ///
  /// In id, this message translates to:
  /// **'Cari Negara'**
  String get deck_gen_country_search;

  /// No description provided for @deck_gen_diff_title.
  ///
  /// In id, this message translates to:
  /// **'Pilih Level Kesulitan'**
  String get deck_gen_diff_title;

  /// No description provided for @deck_gen_diff_desc.
  ///
  /// In id, this message translates to:
  /// **'Ini membantu menyesuaikan tingkat kesulitan kartu.'**
  String get deck_gen_diff_desc;

  /// No description provided for @deck_gen_diff_beginner.
  ///
  /// In id, this message translates to:
  /// **'Pemula'**
  String get deck_gen_diff_beginner;

  /// No description provided for @deck_gen_diff_intermediate.
  ///
  /// In id, this message translates to:
  /// **'Menengah'**
  String get deck_gen_diff_intermediate;

  /// No description provided for @deck_gen_diff_expert.
  ///
  /// In id, this message translates to:
  /// **'Mahir'**
  String get deck_gen_diff_expert;

  /// No description provided for @deck_gen_desc_title.
  ///
  /// In id, this message translates to:
  /// **'Tambahkan deskripsi'**
  String get deck_gen_desc_title;

  /// No description provided for @deck_gen_desc_subtitle.
  ///
  /// In id, this message translates to:
  /// **'Ceritakan sedikit tentang fokus belajarmu di deck ini.'**
  String get deck_gen_desc_subtitle;

  /// No description provided for @deck_gen_desc_hint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: Fokus pada kosakata sehari-hari untuk percakapan santai...'**
  String get deck_gen_desc_hint;

  /// No description provided for @deck_gen_review_title.
  ///
  /// In id, this message translates to:
  /// **'Periksa sebelum membuat'**
  String get deck_gen_review_title;

  /// No description provided for @deck_gen_review_desc.
  ///
  /// In id, this message translates to:
  /// **'Pastikan detail berikut sudah sesuai.'**
  String get deck_gen_review_desc;

  /// No description provided for @deck_gen_review_change.
  ///
  /// In id, this message translates to:
  /// **'Ubah'**
  String get deck_gen_review_change;

  /// No description provided for @deck_gen_create_button.
  ///
  /// In id, this message translates to:
  /// **'Buat Deck'**
  String get deck_gen_create_button;

  /// No description provided for @deck_gen_cancel_button.
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get deck_gen_cancel_button;

  /// No description provided for @deck_gen_progress_header.
  ///
  /// In id, this message translates to:
  /// **'Membuat Deck'**
  String get deck_gen_progress_header;

  /// No description provided for @deck_gen_progress_title.
  ///
  /// In id, this message translates to:
  /// **'Sedang menyiapkan deck-mu...'**
  String get deck_gen_progress_title;

  /// No description provided for @deck_gen_progress_subtitle.
  ///
  /// In id, this message translates to:
  /// **'Kamu akan diberi tahu begitu selesai.'**
  String get deck_gen_progress_subtitle;

  /// No description provided for @deck_run_in_background.
  ///
  /// In id, this message translates to:
  /// **'Jalankan di Latar Belakang'**
  String get deck_run_in_background;

  /// No description provided for @deck_gen_error_title.
  ///
  /// In id, this message translates to:
  /// **'Pembuatan deck gagal'**
  String get deck_gen_error_title;

  /// No description provided for @deck_gen_error_subtitle.
  ///
  /// In id, this message translates to:
  /// **'Terjadi kendala saat menyiapkan deck-mu. Tidak ada data yang tersimpan sebagian.'**
  String get deck_gen_error_subtitle;

  /// No description provided for @deck_back_to_home.
  ///
  /// In id, this message translates to:
  /// **'Kembali Ke Halaman Utama'**
  String get deck_back_to_home;

  /// No description provided for @deck_import_appbar_title.
  ///
  /// In id, this message translates to:
  /// **'Impor Deck'**
  String get deck_import_appbar_title;

  /// No description provided for @deck_import_title.
  ///
  /// In id, this message translates to:
  /// **'Pilih berkas deck'**
  String get deck_import_title;

  /// No description provided for @deck_import_subtitle.
  ///
  /// In id, this message translates to:
  /// **'Pilih berkas .euy dari penyimpanan perangkatmu.'**
  String get deck_import_subtitle;

  /// No description provided for @deck_import_empty_title.
  ///
  /// In id, this message translates to:
  /// **'Belum ada berkas dipilih'**
  String get deck_import_empty_title;

  /// No description provided for @deck_import_empty_format.
  ///
  /// In id, this message translates to:
  /// **'Format yang didukung: .euy'**
  String get deck_import_empty_format;

  /// No description provided for @deck_import_pick_button.
  ///
  /// In id, this message translates to:
  /// **'Pilih dari Penyimpanan'**
  String get deck_import_pick_button;

  /// No description provided for @deck_import_change_file.
  ///
  /// In id, this message translates to:
  /// **'Ganti Berkas'**
  String get deck_import_change_file;

  /// No description provided for @deck_import_verifying_title.
  ///
  /// In id, this message translates to:
  /// **'Memeriksa berkas...'**
  String get deck_import_verifying_title;

  /// No description provided for @deck_import_verifying_subtitle.
  ///
  /// In id, this message translates to:
  /// **'Memastikan format dan isi berkas sudah sesuai.'**
  String get deck_import_verifying_subtitle;

  /// No description provided for @deck_import_importing_title.
  ///
  /// In id, this message translates to:
  /// **'Meng-Impor Deck'**
  String get deck_import_importing_title;

  /// No description provided for @deck_import_invalid_title.
  ///
  /// In id, this message translates to:
  /// **'Berkas tidak valid'**
  String get deck_import_invalid_title;

  /// No description provided for @deck_import_invalid_subtitle.
  ///
  /// In id, this message translates to:
  /// **'Berkas yang kamu pilih rusak atau bukan format .euy yang dikenali.'**
  String get deck_import_invalid_subtitle;

  /// No description provided for @deck_import_pick_another.
  ///
  /// In id, this message translates to:
  /// **'Pilih Berkas Lain'**
  String get deck_import_pick_another;

  /// No description provided for @deck_import_ready_title.
  ///
  /// In id, this message translates to:
  /// **'Deck sudah siap!'**
  String get deck_import_ready_title;

  /// No description provided for @deck_import_ready_subtitle.
  ///
  /// In id, this message translates to:
  /// **'Periksa detail berikut sebelum melanjutkan.'**
  String get deck_import_ready_subtitle;

  /// No description provided for @deck_card_count_label.
  ///
  /// In id, this message translates to:
  /// **'Jumlah Kartu'**
  String get deck_card_count_label;

  /// No description provided for @deck_file_size_label.
  ///
  /// In id, this message translates to:
  /// **'Ukuran Berkas'**
  String get deck_file_size_label;

  /// No description provided for @deck_continue.
  ///
  /// In id, this message translates to:
  /// **'Lanjutkan'**
  String get deck_continue;

  /// No description provided for @deck_page_placeholder.
  ///
  /// In id, this message translates to:
  /// **'Deck'**
  String get deck_page_placeholder;

  /// Header title for the Deck Compilation page
  ///
  /// In id, this message translates to:
  /// **'Kompilasi Deck'**
  String get deck_compilation_title;

  /// Placeholder hint text in the deck search bar
  ///
  /// In id, this message translates to:
  /// **'Cari deck anda...'**
  String get deck_search_hint;

  /// Button label to select all decks in selection mode
  ///
  /// In id, this message translates to:
  /// **'Pilih semua'**
  String get deck_select_all;

  /// Button label to deselect all decks in selection mode
  ///
  /// In id, this message translates to:
  /// **'Batal pilih semua'**
  String get deck_deselect_all;

  /// Label showing the number of selected decks in the bottom bar
  ///
  /// In id, this message translates to:
  /// **'{count} deck terpilih'**
  String deck_selected_count(int count);

  /// Button label to delete selected decks
  ///
  /// In id, this message translates to:
  /// **'Hapus'**
  String get deck_delete_button;

  /// Title of the delete confirmation dialog on the deck page
  ///
  /// In id, this message translates to:
  /// **'Hapus Deck Ini??'**
  String get deck_delete_dialog_title;

  /// Body description of the delete confirmation dialog on the deck page
  ///
  /// In id, this message translates to:
  /// **'Tindakan ini tidak dapat dibatalkan. Ketik username kamu untuk mengonfirmasi.'**
  String get deck_delete_dialog_body;

  /// Hint text inside the username verification text field when deleting decks
  ///
  /// In id, this message translates to:
  /// **'Ketik \"{username}\"...'**
  String deck_delete_dialog_hint(String username);

  /// Message displayed when no decks match the search query
  ///
  /// In id, this message translates to:
  /// **'Deck tidak ditemukan'**
  String get deck_empty_search_title;

  /// Tooltip and semantic label for the floating add deck button
  ///
  /// In id, this message translates to:
  /// **'Tambah Deck'**
  String get deck_add_fab_tooltip;

  /// Bottom navigation bar item for Home screen
  ///
  /// In id, this message translates to:
  /// **'Beranda'**
  String get nav_home;

  /// Bottom navigation bar item for Deck screen
  ///
  /// In id, this message translates to:
  /// **'Deck'**
  String get nav_deck;

  /// Bottom navigation bar item for Settings screen
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get nav_settings;

  /// Button label to start the Quiz game from Deck Details page
  ///
  /// In id, this message translates to:
  /// **'Mainkan\nQuiz'**
  String get deck_details_play_quiz;

  /// Button label to start the Flash Card game from Deck Details page
  ///
  /// In id, this message translates to:
  /// **'Mainkan\nFlash Card'**
  String get deck_details_play_flashcard;

  /// Label under the streak count on Deck Details page
  ///
  /// In id, this message translates to:
  /// **'Streak'**
  String get deck_details_streak_label;

  /// Label under the accuracy percentage on Deck Details page
  ///
  /// In id, this message translates to:
  /// **'Akurasi'**
  String get deck_details_accuracy_label;

  /// Hint text for searching cards on Deck Details page
  ///
  /// In id, this message translates to:
  /// **'Cari kartu...'**
  String get deck_details_search_hint;

  /// Empty state text when no cards match the search query on Deck Details page
  ///
  /// In id, this message translates to:
  /// **'Kartu tidak ditemukan'**
  String get deck_details_empty_cards;

  /// Section header label for card description in the Card Detail bottom sheet
  ///
  /// In id, this message translates to:
  /// **'DESKRIPSI'**
  String get deck_details_card_description_label;

  /// Tooltip for the top-right history icon button
  ///
  /// In id, this message translates to:
  /// **'Riwayat'**
  String get deck_details_history_tooltip;

  /// AppBar title for the Active Time / Streak progress page
  ///
  /// In id, this message translates to:
  /// **'Waktu Aktif'**
  String get deck_progress_streak_title;

  /// AppBar title for the Accuracy progress page
  ///
  /// In id, this message translates to:
  /// **'Accuracy'**
  String get deck_progress_accuracy_title;

  /// Hero subtitle label under the streak count on the Streak progress page
  ///
  /// In id, this message translates to:
  /// **'Streaks'**
  String get deck_progress_streaks_label;

  /// Hero subtitle label under the accuracy percentage on the Accuracy progress page
  ///
  /// In id, this message translates to:
  /// **'Akurasi Bulan Ini'**
  String get deck_progress_accuracy_subtitle;

  /// Comparison text between this month and last month accuracy
  ///
  /// In id, this message translates to:
  /// **'{diff}% dibanding bulan lalu ({lastMonth}%)'**
  String deck_progress_comparison_vs_last_month(String diff, int lastMonth);

  /// Comparison text between this month and last month active time in minutes
  ///
  /// In id, this message translates to:
  /// **'{thisMonth}m bulan ini ({lastMonth}m bulan lalu)'**
  String deck_progress_active_comparison_vs_last_month(
    int thisMonth,
    int lastMonth,
  );

  /// Card title for the Weekly Streaks box
  ///
  /// In id, this message translates to:
  /// **'Weekly Streaks'**
  String get deck_progress_weekly_streaks_title;

  /// Footnote inside the Weekly Streaks card
  ///
  /// In id, this message translates to:
  /// **'*This will be restarted every week'**
  String get deck_progress_weekly_restarts_note;

  /// Short label for Monday
  ///
  /// In id, this message translates to:
  /// **'Sen'**
  String get deck_progress_day_mon_short;

  /// Short label for Tuesday
  ///
  /// In id, this message translates to:
  /// **'Sel'**
  String get deck_progress_day_tue_short;

  /// Short label for Wednesday
  ///
  /// In id, this message translates to:
  /// **'Rab'**
  String get deck_progress_day_wed_short;

  /// Short label for Thursday
  ///
  /// In id, this message translates to:
  /// **'Kam'**
  String get deck_progress_day_thu_short;

  /// Short label for Friday
  ///
  /// In id, this message translates to:
  /// **'Jum'**
  String get deck_progress_day_fri_short;

  /// Short label for Saturday
  ///
  /// In id, this message translates to:
  /// **'Sab'**
  String get deck_progress_day_sat_short;

  /// Short label for Sunday
  ///
  /// In id, this message translates to:
  /// **'Min'**
  String get deck_progress_day_sun_short;

  /// Calendar column header for Sunday
  ///
  /// In id, this message translates to:
  /// **'Minggu'**
  String get deck_progress_day_sun;

  /// Calendar column header for Monday
  ///
  /// In id, this message translates to:
  /// **'Senin'**
  String get deck_progress_day_mon;

  /// Calendar column header for Tuesday
  ///
  /// In id, this message translates to:
  /// **'Selasa'**
  String get deck_progress_day_tue;

  /// Calendar column header for Wednesday
  ///
  /// In id, this message translates to:
  /// **'Rabu'**
  String get deck_progress_day_wed;

  /// Calendar column header for Thursday
  ///
  /// In id, this message translates to:
  /// **'Kamis'**
  String get deck_progress_day_thu;

  /// Calendar column header for Friday
  ///
  /// In id, this message translates to:
  /// **'Jum\'at'**
  String get deck_progress_day_fri;

  /// Calendar column header for Saturday
  ///
  /// In id, this message translates to:
  /// **'Sabtu'**
  String get deck_progress_day_sat;

  /// Segmented toggle tab label for Monthly bar chart view
  ///
  /// In id, this message translates to:
  /// **'Bulan'**
  String get deck_progress_tab_month;

  /// Segmented toggle tab label for Yearly/Calendar heatmap view
  ///
  /// In id, this message translates to:
  /// **'Tahun'**
  String get deck_progress_tab_year;

  /// Metric box label for practiced card count in Period Detail bottom sheet
  ///
  /// In id, this message translates to:
  /// **'Card'**
  String get deck_progress_metric_card;

  /// Metric box label for accuracy rate in Period Detail bottom sheet
  ///
  /// In id, this message translates to:
  /// **'Akurat'**
  String get deck_progress_metric_accurate;

  /// Metric box label for active duration in Period Detail bottom sheet
  ///
  /// In id, this message translates to:
  /// **'Aktif'**
  String get deck_progress_metric_active;

  /// Section header for Top 3 Weakest Cards in Period Detail bottom sheet
  ///
  /// In id, this message translates to:
  /// **'3 Kartu Paling Lemah'**
  String get deck_progress_weakest_cards_title;

  /// Empty state text when no weakest cards exist for the selected period
  ///
  /// In id, this message translates to:
  /// **'Belum ada kartu yang dipelajari pada periode ini'**
  String get deck_progress_weakest_empty;

  /// Label showing how many times a card was answered incorrectly
  ///
  /// In id, this message translates to:
  /// **'{count}x Salah'**
  String deck_progress_wrong_count(int count);

  /// Label showing the accuracy percentage of a card
  ///
  /// In id, this message translates to:
  /// **'{percent}% Akurat'**
  String deck_progress_accurate_percent(int percent);

  /// Header title for the Flashcard game screen
  ///
  /// In id, this message translates to:
  /// **'Flashcard'**
  String get flashcard_title;

  /// Instruction text displayed above the flashcard
  ///
  /// In id, this message translates to:
  /// **'Perhatikan kata berikut lalu balik kartu untuk melihat arti:'**
  String get flashcard_instruction;

  /// Badge showing the current flashcard index out of total cards
  ///
  /// In id, this message translates to:
  /// **'Kartu {current} dari {total}'**
  String flashcard_card_progress(int current, int total);

  /// Label at the top of the unflipped flashcard
  ///
  /// In id, this message translates to:
  /// **'Pertanyaan'**
  String get flashcard_question_label;

  /// Label at the top of the flipped flashcard
  ///
  /// In id, this message translates to:
  /// **'Jawaban'**
  String get flashcard_answer_label;

  /// Hint text at the bottom of the unflipped flashcard
  ///
  /// In id, this message translates to:
  /// **'Ketuk untuk melihat arti'**
  String get flashcard_tap_to_flip;

  /// Primary button label to flip the flashcard
  ///
  /// In id, this message translates to:
  /// **'Balik Kartu'**
  String get flashcard_flip_button;

  /// Self-assessment button label when the user has not memorized the card
  ///
  /// In id, this message translates to:
  /// **'Belum hafal'**
  String get flashcard_not_memorized;

  /// Self-assessment button label when the user has memorized the card
  ///
  /// In id, this message translates to:
  /// **'Sudah hafal'**
  String get flashcard_memorized;

  /// Title shown on the completion summary screen for Flashcard and Quiz games
  ///
  /// In id, this message translates to:
  /// **'Latihan Selesai'**
  String get flashcard_complete_title;

  /// Stat value showing the number of cards memorized or not memorized
  ///
  /// In id, this message translates to:
  /// **'{count}Card'**
  String flashcard_complete_cards_value(int count);

  /// Stat label for memorized cards count on Flashcard completion screen
  ///
  /// In id, this message translates to:
  /// **'Sudah Hafal'**
  String get flashcard_complete_memorized_label;

  /// Stat label for not memorized cards count on Flashcard completion screen
  ///
  /// In id, this message translates to:
  /// **'Belum Hafal'**
  String get flashcard_complete_not_memorized_label;

  /// Formatted session active time in minutes and seconds
  ///
  /// In id, this message translates to:
  /// **'+{minutes}m {seconds}d'**
  String flashcard_complete_active_time_value(int minutes, int seconds);

  /// Stat label for session active time on completion screen
  ///
  /// In id, this message translates to:
  /// **'Waktu Aktif Sesi'**
  String get flashcard_complete_active_time_label;

  /// Button label to finish the session and return to Deck Details
  ///
  /// In id, this message translates to:
  /// **'Selesai'**
  String get flashcard_complete_finish_button;

  /// Header title for the Quiz game screen
  ///
  /// In id, this message translates to:
  /// **'Quiz'**
  String get quiz_title;

  /// Instruction prompt for Multiple Choice translation questions in Quiz
  ///
  /// In id, this message translates to:
  /// **'Pilih arti yang sesuai untuk kata berikut:'**
  String get quiz_mc_instruction;

  /// Instruction prompt for Jumble Words arrangement questions in Quiz
  ///
  /// In id, this message translates to:
  /// **'Ketik atau susun terjemahan untuk kata ini:'**
  String get quiz_jumble_instruction;

  /// Placeholder text inside the empty Jumble Words answer box
  ///
  /// In id, this message translates to:
  /// **'Tarik kata yang anda pilih ke sini'**
  String get quiz_jumble_placeholder;

  /// Primary button label to check the selected answer in Quiz
  ///
  /// In id, this message translates to:
  /// **'Periksa Jawaban'**
  String get quiz_check_answer_button;

  /// Title inside the Correct Answer feedback sheet
  ///
  /// In id, this message translates to:
  /// **'Jawaban Tepat Sekali'**
  String get quiz_feedback_correct_title;

  /// Subtitle inside the Wrong Answer feedback sheet preceding the correct answer pill
  ///
  /// In id, this message translates to:
  /// **'Jawaban yang benar adalah'**
  String get quiz_feedback_wrong_title;

  /// Button label inside the Quiz feedback sheet to proceed to the next question
  ///
  /// In id, this message translates to:
  /// **'Lanjut'**
  String get quiz_continue_button;

  /// Score ratio shown on the Quiz completion summary screen
  ///
  /// In id, this message translates to:
  /// **'{correct} / {total}'**
  String quiz_complete_score_value(int correct, int total);

  /// Label under the score ratio on the Quiz completion summary screen
  ///
  /// In id, this message translates to:
  /// **'Jawaban Tepat'**
  String get quiz_complete_correct_label;

  /// Page title for the Deck History page
  ///
  /// In id, this message translates to:
  /// **'Riwayat Aktifitas'**
  String get deck_history_title;

  /// Label for current week period toggle
  ///
  /// In id, this message translates to:
  /// **'Minggu ini'**
  String get deck_history_period_week;

  /// Label for current month period toggle
  ///
  /// In id, this message translates to:
  /// **'Bulan ini'**
  String get deck_history_period_month;

  /// Label for current year period toggle
  ///
  /// In id, this message translates to:
  /// **'Tahun ini'**
  String get deck_history_period_year;

  /// Heading for week summary section
  ///
  /// In id, this message translates to:
  /// **'Ringkasan Minggu ini'**
  String get deck_history_summary_week;

  /// Heading for month summary section
  ///
  /// In id, this message translates to:
  /// **'Ringkasan Bulan ini'**
  String get deck_history_summary_month;

  /// Heading for year summary section
  ///
  /// In id, this message translates to:
  /// **'Ringkasan Tahun ini'**
  String get deck_history_summary_year;

  /// Caption for total activities count in summary section
  ///
  /// In id, this message translates to:
  /// **'Total Aktivitas'**
  String get deck_history_total_activities;

  /// Caption for total study duration in summary section
  ///
  /// In id, this message translates to:
  /// **'Waktu Belajar'**
  String get deck_history_study_time;

  /// Caption for average accuracy percentage in summary section
  ///
  /// In id, this message translates to:
  /// **'Rata-Rata Akurasi'**
  String get deck_history_avg_accuracy;

  /// Formatted sessions count value
  ///
  /// In id, this message translates to:
  /// **'{count} sesi'**
  String deck_history_sessions_count(int count);

  /// Header title for the learning activity list section
  ///
  /// In id, this message translates to:
  /// **'Aktifitas Belajar'**
  String get deck_history_activities_title;

  /// Counter displayed next to study activities title
  ///
  /// In id, this message translates to:
  /// **'{count} aktifitas'**
  String deck_history_activities_count(int count);

  /// Empty state title when no activities were completed in the period
  ///
  /// In id, this message translates to:
  /// **'Belum Ada Aktivitas'**
  String get deck_history_empty_title;

  /// Empty state subtitle instructions
  ///
  /// In id, this message translates to:
  /// **'Selesaikan sesi flashcard atau kuis untuk melihat riwayat belajarmu di sini.'**
  String get deck_history_empty_subtitle;

  /// Title for quiz study session items
  ///
  /// In id, this message translates to:
  /// **'Kuis kata'**
  String get deck_history_quiz_label;

  /// Title for flashcard study session items
  ///
  /// In id, this message translates to:
  /// **'Flashcard'**
  String get deck_history_flashcard_label;

  /// Score badge on history item card
  ///
  /// In id, this message translates to:
  /// **'{correct} / {total} Benar'**
  String deck_history_score_badge(int correct, int total);

  /// Duration badge on history item card in minutes
  ///
  /// In id, this message translates to:
  /// **'{minutes} Menit'**
  String deck_history_minutes_badge(int minutes);

  /// Duration badge on history item card in seconds
  ///
  /// In id, this message translates to:
  /// **'{seconds} Dtk'**
  String deck_history_seconds_badge(int seconds);

  /// Stat label for correct answers count in session detail sheet
  ///
  /// In id, this message translates to:
  /// **'Jawaban Tepat'**
  String get deck_history_sheet_correct_answers;

  /// Stat label for session duration in session detail sheet
  ///
  /// In id, this message translates to:
  /// **'Durasi Sesi'**
  String get deck_history_sheet_session_duration;

  /// Stat label for accuracy percentage in session detail sheet
  ///
  /// In id, this message translates to:
  /// **'Akurasi'**
  String get deck_history_sheet_accuracy;

  /// Section title for list of practiced cards in session detail sheet
  ///
  /// In id, this message translates to:
  /// **'Kartu yang di pelajari'**
  String get deck_history_sheet_cards_studied;

  /// Badge for cards answered correctly in session detail sheet
  ///
  /// In id, this message translates to:
  /// **'Hafal'**
  String get deck_history_sheet_mastered;

  /// Badge for cards answered incorrectly in session detail sheet
  ///
  /// In id, this message translates to:
  /// **'Perlu diulang'**
  String get deck_history_sheet_needs_review;

  /// Primary action button to dismiss session detail bottom sheet
  ///
  /// In id, this message translates to:
  /// **'Tutup rincian'**
  String get deck_history_sheet_close;

  /// Relative date prefix for today
  ///
  /// In id, this message translates to:
  /// **'Hari ini'**
  String get deck_history_time_today;

  /// Relative date prefix for yesterday
  ///
  /// In id, this message translates to:
  /// **'Kemarin'**
  String get deck_history_time_yesterday;

  /// Multiplayer bottom navigation tab label
  ///
  /// In id, this message translates to:
  /// **'Multiplayer'**
  String get nav_multiplayer;

  /// Multiplayer page title
  ///
  /// In id, this message translates to:
  /// **'Bermain bersama'**
  String get multiplayer_title;

  /// Multiplayer hero banner title
  ///
  /// In id, this message translates to:
  /// **'Latihan bersama teman'**
  String get multiplayer_banner_title;

  /// Multiplayer hero banner description
  ///
  /// In id, this message translates to:
  /// **'Belajar kooperatif 2 pemain di jaringan Wi-Fi yang sama tanpa kuota internet.'**
  String get multiplayer_banner_desc;

  /// Button to create a room as host
  ///
  /// In id, this message translates to:
  /// **'Buat Ruangan Baru'**
  String get multiplayer_create_room;

  /// Subtitle for create room option
  ///
  /// In id, this message translates to:
  /// **'Jadikan perangkat anda sebagai host'**
  String get multiplayer_create_room_desc;

  /// Button to join existing room
  ///
  /// In id, this message translates to:
  /// **'Gabung ruangan'**
  String get multiplayer_join_room;

  /// Subtitle for join room option
  ///
  /// In id, this message translates to:
  /// **'Gabung keruangan yang sudah ada'**
  String get multiplayer_join_room_desc;

  /// Room page title
  ///
  /// In id, this message translates to:
  /// **'Ruangan'**
  String get multiplayer_room_title;

  /// Label above host IP address
  ///
  /// In id, this message translates to:
  /// **'ALAMAT PERANGKAT INI'**
  String get multiplayer_room_ip_label;

  /// Chip label above QR code
  ///
  /// In id, this message translates to:
  /// **'atau pindai kode ini'**
  String get multiplayer_room_scan_label;

  /// Host waiting status under QR code
  ///
  /// In id, this message translates to:
  /// **'Menunggu data dari perangkat lain...'**
  String get multiplayer_room_waiting;

  /// Advisory text regarding Wi-Fi connection
  ///
  /// In id, this message translates to:
  /// **'Pastikan kedua perangkat terhubung ke jaringan Wi-Fi yang sama.'**
  String get multiplayer_room_wifi_note;

  /// Guesser QR scanner box label
  ///
  /// In id, this message translates to:
  /// **'Ketuk untuk pindai QR Host'**
  String get multiplayer_join_scan_qr;

  /// Divider text between QR scan and IP input
  ///
  /// In id, this message translates to:
  /// **'atau lakukan scan qr code'**
  String get multiplayer_join_or_scan;

  /// Hint text for host IP input field
  ///
  /// In id, this message translates to:
  /// **'Masukan IP Address Host....'**
  String get multiplayer_join_ip_placeholder;

  /// Primary action button to join room
  ///
  /// In id, this message translates to:
  /// **'Gabung Ruangan'**
  String get multiplayer_join_button;

  /// Title for practice lobby screen
  ///
  /// In id, this message translates to:
  /// **'Lobi latihan'**
  String get multiplayer_lobby_title;

  /// Count of connected players in lobby
  ///
  /// In id, this message translates to:
  /// **'Pemain Terhubung ({current}/{total})'**
  String multiplayer_lobby_connected_count(int current, int total);

  /// Host player role title
  ///
  /// In id, this message translates to:
  /// **'Pemberi Petunjuk'**
  String get multiplayer_lobby_role_host;

  /// Guesser player role title
  ///
  /// In id, this message translates to:
  /// **'Penebak'**
  String get multiplayer_lobby_role_guesser;

  /// Ready status badge
  ///
  /// In id, this message translates to:
  /// **'Siap'**
  String get multiplayer_lobby_ready;

  /// Button for host to proceed to deck selection
  ///
  /// In id, this message translates to:
  /// **'Pilih Deck'**
  String get multiplayer_lobby_start_button;

  /// Guesser status while host chooses deck
  ///
  /// In id, this message translates to:
  /// **'Menunggu Host memilih deck...'**
  String get multiplayer_lobby_waiting_host;

  /// Deck selection page title
  ///
  /// In id, this message translates to:
  /// **'Pilih Deck'**
  String get multiplayer_select_deck_title;

  /// Placeholder for deck search bar
  ///
  /// In id, this message translates to:
  /// **'Cari deck anda...'**
  String get multiplayer_select_deck_search;

  /// Title for multiplayer quiz page
  ///
  /// In id, this message translates to:
  /// **'Latihan bersama'**
  String get multiplayer_game_title;

  /// Host instruction to explain word to guesser
  ///
  /// In id, this message translates to:
  /// **'Jelaskan Kepada {name} terkait kata yang diatas'**
  String multiplayer_host_elaborate_prompt(String name);

  /// Guesser instruction box header
  ///
  /// In id, this message translates to:
  /// **'Dengarkan penjelasan dari {name}'**
  String multiplayer_guesser_listen_prompt(String name);

  /// Guesser waiting title while host answers
  ///
  /// In id, this message translates to:
  /// **'Menunggu Jawaban Dari {name}....'**
  String multiplayer_guesser_waiting_title(String name);

  /// Guesser waiting description while host answers
  ///
  /// In id, this message translates to:
  /// **'{name} (Pemberi Petunjuk) Sedang Memilih Jawaban Dari Sistem. Tetap Rileks Dan Bersiaplah!'**
  String multiplayer_guesser_waiting_desc(String name);

  /// Plus one point indicator
  ///
  /// In id, this message translates to:
  /// **'+1'**
  String get multiplayer_score_plus;

  /// Minus one point indicator
  ///
  /// In id, this message translates to:
  /// **'-1'**
  String get multiplayer_score_minus;

  /// Zero score delta indicator
  ///
  /// In id, this message translates to:
  /// **'+0'**
  String get multiplayer_score_zero;

  /// Points label
  ///
  /// In id, this message translates to:
  /// **'Poin'**
  String get multiplayer_score_label;

  /// Total score heading
  ///
  /// In id, this message translates to:
  /// **'Total Skor Kalian Saat Ini:'**
  String get multiplayer_score_total;

  /// Points format with score count
  ///
  /// In id, this message translates to:
  /// **'{score} Poin'**
  String multiplayer_score_points(int score);

  /// Button to advance to next question
  ///
  /// In id, this message translates to:
  /// **'Lanjutkan Soal'**
  String get multiplayer_continue_button;

  /// Completion screen title
  ///
  /// In id, this message translates to:
  /// **'Latihan Bersama Selesai'**
  String get multiplayer_complete_title;

  /// Correct ratio on complete screen
  ///
  /// In id, this message translates to:
  /// **'{correct} / {total}'**
  String multiplayer_complete_correct_count(int correct, int total);

  /// Label under correct answers count
  ///
  /// In id, this message translates to:
  /// **'Jawaban Tepat'**
  String get multiplayer_complete_correct_label;

  /// Label under session duration
  ///
  /// In id, this message translates to:
  /// **'Waktu Aktif Sesi'**
  String get multiplayer_complete_time_label;

  /// Button to return to main page
  ///
  /// In id, this message translates to:
  /// **'Kembali'**
  String get multiplayer_back_button;

  /// Title for multiplayer history page
  ///
  /// In id, this message translates to:
  /// **'Riwayat Latihan Bersama'**
  String get multiplayer_history_title;

  /// Dialog title confirming room exit
  ///
  /// In id, this message translates to:
  /// **'Keluar dari Ruangan?'**
  String get multiplayer_leave_confirm_title;

  /// Dialog body explaining consequences of leaving
  ///
  /// In id, this message translates to:
  /// **'Sesi latihan akan dihentikan untuk kedua pemain.'**
  String get multiplayer_leave_confirm_desc;

  /// Confirm button to leave room
  ///
  /// In id, this message translates to:
  /// **'Keluar'**
  String get multiplayer_leave_confirm_yes;

  /// Cancel button to stay in room
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get multiplayer_leave_confirm_no;

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
