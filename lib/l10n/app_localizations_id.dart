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
  String get welcome_sync_title => 'Sinkronisasi Profil';

  @override
  String get welcome_sync_description =>
      'Pindahkan profil dari perangkat lama.';

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
  String get securityFootnote =>
      'Profil Anda tersimpan aman di perangkat ini tanpa kata sandi';

  @override
  String step(int first, int second) {
    return '$first of $second';
  }

  @override
  String get end_of_translation => '';
}
