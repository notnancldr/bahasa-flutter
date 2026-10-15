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
