// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Basa';

  @override
  String get welcome_startUsing => 'Mulai Gunakan';

  @override
  String get welcome_description =>
      'Pilih cara Anda memulai pembelajaran hari ini.';

  @override
  String get welcome_newProfile_title => 'Buat Profil Baru';

  @override
  String get welcome_newProfile_description =>
      'Mulai dari awal dengan profil baru.';

  @override
  String get welcome_transfer_title => 'Pindahkan Profil Lama';

  @override
  String get welcome_transfer_description =>
      'Pindahkan profil dari perangkat lama Anda.';

  @override
  String get welcome_nextButton => 'Mulai Sekarang';

  @override
  String get newProfile_title => 'Registrasi Profil';

  @override
  String get newProfile_step_username_title => 'Masukkan Username';

  @override
  String get newProfile_step_username_description =>
      'Nama ini akan digunakan sebagai tampilan akun belajar Anda di perangkat ini';

  @override
  String get newProfile_step_username_fieldName => 'Username';

  @override
  String get newProfile_step_username_fieldPlaceholder =>
      'Masukkan username...';

  @override
  String get newProfile_step_username_fieldHint =>
      'Dapat menggunakan huruf, angka, atau tanda titik.';

  @override
  String get newProfile_step_language_title => 'Pilih Bahasa Utama';

  @override
  String get newProfile_step_language_description =>
      'Bahasa ini akan digunakan sebagai bahasa utama navigasi dan pengantar latihan.';

  @override
  String get newProfile_step_language_search => 'Cari bahasa...';

  @override
  String get newProfile_nextButton => 'Lanjutkan';

  @override
  String get newProfile_saveButton => 'Simpan';

  @override
  String get newProfile_complete_title => 'Profil Berhasil Dibuat';

  @override
  String get newProfile_complete_description =>
      'Profilmu sudah siap digunakan. Mari lanjutkan pengalaman belajarmu dengan tenang.';

  @override
  String get securityFootnote =>
      'Profil Anda tersimpan aman di perangkat ini tanpa kata sandi';

  @override
  String get transfer_listening_title => 'Menunggu Perangkat Lain';

  @override
  String get transfer_listening_description =>
      'Buka [NAMA_APLIKASI :v] di perangkat lama, lalu masukkan alamat berikut untuk memulai pemindahan profil.';

  @override
  String get transfer_listening_address => 'Alamat Perangkat Ini';

  @override
  String get transfer_listening_aboveQr => 'atau pindai kode ini';

  @override
  String get transfer_listening_belowQr =>
      'Menunggu data dari perangkat lain...';

  @override
  String get transfer_listening_note =>
      'Pastikan kedua perangkat terhubung ke jaringan Wi-Fi yang sama.';

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
  String get process_preparing => 'Menyiapkan';

  @override
  String get process_gettingReady => 'Mempersiapkan semuanya';

  @override
  String get process_process => 'Memproses';

  @override
  String get process_loading => 'Memuat';

  @override
  String get back => 'Kembali';

  @override
  String get cancel => 'Batal';

  @override
  String get done => 'Selesai';

  @override
  String get tryAgain => 'Coba Lagi';

  @override
  String get copy => 'Salin';

  @override
  String get paste => 'tempel';

  @override
  String get copied => 'Disalin!';

  @override
  String get pasted => 'Dikutip!';

  @override
  String languageName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'id': 'Indonesia',
      'en': 'Inggris',
      'es': 'Spanyol',
      'ja': 'Jepang',
      'ko': 'Korea',
      'fr': 'Prancis',
      'ru': 'Rusia',
      'ar': 'Arab',
      'de': 'Jerman',
      'pt': 'Portugis',
      'zh': 'Mandarin',
      'hi': 'Hindi',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String step(int first, int second) {
    return '$first dari $second';
  }

  @override
  String get end_of_translation => '';
}
