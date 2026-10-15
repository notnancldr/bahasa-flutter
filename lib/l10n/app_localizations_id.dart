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
  String get transfer_error_invalid_title => 'Data Tidak Valid';

  @override
  String get transfer_error_invalid_description =>
      'Proses pemindahan terputus sebelum semua data profil Anda selesai disalin ke perangkat ini.';

  @override
  String get transfer_error_cleanup_title =>
      'Data yang gagal sudah kami hapus dari perangkat ini.';

  @override
  String get transfer_error_cleanup_description =>
      'Penyimpanan lokal perangkat tetap bersih dan aman.';

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
  String get settings_title => 'Pengaturan';

  @override
  String get settings_manageProfile => 'Kelola profil';

  @override
  String get settings_activeStudent => 'Pelajar Aktif';

  @override
  String get settings_account_title => 'Akun';

  @override
  String get settings_account_subtitle => 'Ubah nama pengguna & foto';

  @override
  String get settings_theme_title => 'Tema';

  @override
  String get settings_theme_subtitleLight => 'Mode terang (nyaman di mata)';

  @override
  String get settings_theme_subtitleDark => 'Mode gelap (hemat baterai)';

  @override
  String get settings_theme_badgeLight => 'Terang';

  @override
  String get settings_theme_badgeDark => 'Gelap';

  @override
  String get settings_language_title => 'Bahasa';

  @override
  String get settings_language_subtitle => 'Pilih bahasa utama aplikasi';

  @override
  String get settings_notif_title => 'Notifikasi';

  @override
  String get settings_notif_subtitle => 'Pengingat belajar harian';

  @override
  String get settings_data_title => 'Data & Penyimpanan';

  @override
  String get settings_data_subtitle => 'Penyimpanan kosakata dan transfer data';

  @override
  String get account_joinedSince => 'Bergabung sejak 2026.';

  @override
  String get account_editProfile => 'Edit Profil';

  @override
  String get account_editProfile_subtitle => 'Ubah foto atau username.';

  @override
  String get account_deleteProfile => 'Hapus Profil';

  @override
  String get account_deleteProfile_subtitle =>
      'Hapus akun dan semua data secara permanen.';

  @override
  String get account_footer => 'Basa • Sahabat Belajar Bahasa Anda';

  @override
  String get account_delete_dialogTitle => 'Hapus profil ini?';

  @override
  String get account_delete_dialogBody =>
      'Semua data belajarmu akan dihapus secara permanen dan tidak dapat dikembalikan.';

  @override
  String get account_delete_confirmButton => 'Hapus';

  @override
  String get editProfile_title => 'Edit Profil';

  @override
  String get editProfile_subtitle =>
      'Kelola informasi publik dan akun belajar kamu.';

  @override
  String get editProfile_changePhoto => 'Ganti Foto';

  @override
  String get editProfile_usernameLabel => 'Username';

  @override
  String get editProfile_usernameHint =>
      'Dapat menggunakan huruf, angka, atau tanda titik.';

  @override
  String get editProfile_tipTitle => 'Tips Komunitas Basa';

  @override
  String get editProfile_tipBody =>
      'Username ini akan terlihat oleh teman sebaya pada papan peringkat mingguan.';

  @override
  String get editProfile_saveButton => 'Simpan Perubahan';

  @override
  String get theme_title => 'Tema';

  @override
  String get theme_subtitle => 'Pilih tampilan yang paling nyaman untukmu.';

  @override
  String get theme_light => 'Mode Terang';

  @override
  String get theme_dark => 'Mode Gelap';

  @override
  String get data_sectionStorage => 'PENGGUNAAN PENYIMPANAN';

  @override
  String get data_download => 'Unduhan Kosakata';

  @override
  String data_downloadSubtitle(String sizeStr) {
    return '$sizeStr tersimpan offline';
  }

  @override
  String get data_clear => 'Bersihkan';

  @override
  String get data_sectionDataTransfer => 'TRANSFER DATA';

  @override
  String get data_dataTransfer => 'Transfer Data';

  @override
  String get data_dataTransfer_subtitle => 'Transfer profil ke perangkat baru';

  @override
  String get data_sectionDanger => 'TINDAKAN LANJUTAN';

  @override
  String get data_deleteData => 'Hapus Data';

  @override
  String get data_deleteData_subtitle => 'Hapus seluruh riwayat dan progres';

  @override
  String get shareData_title => 'Bagikan Data';

  @override
  String get shareData_subtitle =>
      'Masukkan IP dari perangkat penerima untuk mengirim data.';

  @override
  String get shareData_ipLabel => 'Alamat IP Penerima';

  @override
  String get shareData_ipPlaceholder => 'Masukkan alamat IP...';

  @override
  String get shareData_startButton => 'Mulai Transfer';

  @override
  String get shareData_sending_overline => 'DATA & PENYIMPANAN';

  @override
  String get shareData_sending_title => 'Sedang Mengirim Data';

  @override
  String get shareData_sending_status =>
      'Mohon tunggu, data sedang diproses...';

  @override
  String get shareData_sending_note =>
      'Jangan tutup aplikasi selama proses berlangsung.';

  @override
  String get shareData_failed_title => 'Transfer gagal';

  @override
  String get shareData_failed_body =>
      'Koneksi terputus atau kode sudah tidak berlaku. Coba lagi?';

  @override
  String get shareData_failed_no => 'Tidak';

  @override
  String get deleteData_dialog_title => 'Hapus semua data?';

  @override
  String get deleteData_dialog_body =>
      'Tindakan ini tidak dapat dibatalkan. Ketik username kamu untuk mengonfirmasi.';

  @override
  String get deleteData_dialog_confirmButton => 'Hapus Data';

  @override
  String get deleteData_success_title => 'Data berhasil dihapus';

  @override
  String get deleteData_success_body =>
      'Akunmu tetap ada. Kamu bisa mulai belajar dari awal kapan pun.';

  @override
  String get deleteData_success_homeButton => 'Kembali ke Beranda';

  @override
  String get home_consecutiveDays => 'Hari Beruntun';

  @override
  String get home_emptyDeckTitle => 'Kamu belum punya deck!';

  @override
  String get home_createDeckButton => 'Buat Deck';

  @override
  String get home_rarelyStudied => 'Jarang Dipelajari';

  @override
  String get home_reviewButton => 'Ulas';

  @override
  String home_lastStudiedDaysAgo(int days) {
    return 'Terakhir dipelajari $days hari lalu.';
  }

  @override
  String get home_recentActivityTitle => 'Aktivitas Terakhir';

  @override
  String home_recentActivitySubtitle(int cards, int time, String unit) {
    String _temp0 = intl.Intl.pluralLogic(
      cards,
      locale: localeName,
      other: '$cards kartu',
    );
    String _temp1 = intl.Intl.selectLogic(unit, {
      'hoursAgo': '$time jam lalu',
      'yesterday': 'Kemarin',
      'daysAgo': '$time hari lalu',
      'other': '$time',
    });
    return '$_temp0 • $_temp1';
  }

  @override
  String home_cardsCount(int count) {
    return '$count kartu';
  }

  @override
  String home_timeHoursAgo(int hours) {
    return '$hours jam lalu';
  }

  @override
  String get home_timeYesterday => 'Kemarin';

  @override
  String home_timeDaysAgo(int days) {
    return '$days hari lalu';
  }

  @override
  String get deck_method_title => 'Tambah Deck Baru';

  @override
  String get deck_method_subtitle => 'Pilih cara kamu ingin membuat deck.';

  @override
  String get deck_method_generate_title => 'Generate Deck';

  @override
  String get deck_method_generate_subtitle => 'Buat deck baru secara otomatis.';

  @override
  String get deck_method_generate_cta => 'Mulai';

  @override
  String get deck_method_import_title => 'Impor Deck';

  @override
  String get deck_method_import_subtitle =>
      'Gunakan berkas .euy yang sudah ada.';

  @override
  String get deck_method_import_cta => 'Pilih Berkas';

  @override
  String get deck_gen_appbar_title => 'Generate Deck';

  @override
  String get deck_gen_name_title => 'Beri nama deck-mu';

  @override
  String get deck_gen_name_desc => 'Nama ini akan muncul di daftar deck kamu.';

  @override
  String get deck_gen_name_label => 'Nama Deck';

  @override
  String get deck_gen_name_hint => 'Contoh: Kosakata Dasar Jepang...';

  @override
  String get deck_gen_country_title => 'Pilih Negara';

  @override
  String get deck_gen_country_desc =>
      'Konten deck akan disesuaikan dengan negara ini.';

  @override
  String get deck_gen_country_search => 'Cari Negara';

  @override
  String get deck_gen_diff_title => 'Pilih Level Kesulitan';

  @override
  String get deck_gen_diff_desc =>
      'Ini membantu menyesuaikan tingkat kesulitan kartu.';

  @override
  String get deck_gen_diff_beginner => 'Pemula';

  @override
  String get deck_gen_diff_intermediate => 'Menengah';

  @override
  String get deck_gen_diff_expert => 'Mahir';

  @override
  String get deck_gen_desc_title => 'Tambahkan deskripsi';

  @override
  String get deck_gen_desc_subtitle =>
      'Ceritakan sedikit tentang fokus belajarmu di deck ini.';

  @override
  String get deck_gen_desc_hint =>
      'Contoh: Fokus pada kosakata sehari-hari untuk percakapan santai...';

  @override
  String get deck_gen_review_title => 'Periksa sebelum membuat';

  @override
  String get deck_gen_review_desc => 'Pastikan detail berikut sudah sesuai.';

  @override
  String get deck_gen_review_change => 'Ubah';

  @override
  String get deck_gen_create_button => 'Buat Deck';

  @override
  String get deck_gen_cancel_button => 'Batal';

  @override
  String get deck_gen_progress_header => 'Membuat Deck';

  @override
  String get deck_gen_progress_title => 'Sedang menyiapkan deck-mu...';

  @override
  String get deck_gen_progress_subtitle =>
      'Kamu akan diberi tahu begitu selesai.';

  @override
  String get deck_run_in_background => 'Jalankan di Latar Belakang';

  @override
  String get deck_gen_error_title => 'Pembuatan deck gagal';

  @override
  String get deck_gen_error_subtitle =>
      'Terjadi kendala saat menyiapkan deck-mu. Tidak ada data yang tersimpan sebagian.';

  @override
  String get deck_back_to_home => 'Kembali Ke Halaman Utama';

  @override
  String get deck_import_appbar_title => 'Impor Deck';

  @override
  String get deck_import_title => 'Pilih berkas deck';

  @override
  String get deck_import_subtitle =>
      'Pilih berkas .euy dari penyimpanan perangkatmu.';

  @override
  String get deck_import_empty_title => 'Belum ada berkas dipilih';

  @override
  String get deck_import_empty_format => 'Format yang didukung: .euy';

  @override
  String get deck_import_pick_button => 'Pilih dari Penyimpanan';

  @override
  String get deck_import_change_file => 'Ganti Berkas';

  @override
  String get deck_import_verifying_title => 'Memeriksa berkas...';

  @override
  String get deck_import_verifying_subtitle =>
      'Memastikan format dan isi berkas sudah sesuai.';

  @override
  String get deck_import_importing_title => 'Meng-Impor Deck';

  @override
  String get deck_import_invalid_title => 'Berkas tidak valid';

  @override
  String get deck_import_invalid_subtitle =>
      'Berkas yang kamu pilih rusak atau bukan format .euy yang dikenali.';

  @override
  String get deck_import_pick_another => 'Pilih Berkas Lain';

  @override
  String get deck_import_ready_title => 'Deck sudah siap!';

  @override
  String get deck_import_ready_subtitle =>
      'Periksa detail berikut sebelum melanjutkan.';

  @override
  String get deck_card_count_label => 'Jumlah Kartu';

  @override
  String get deck_file_size_label => 'Ukuran Berkas';

  @override
  String get deck_continue => 'Lanjutkan';

  @override
  String get deck_page_placeholder => 'Deck';

  @override
  String get end_of_translation => '';
}
