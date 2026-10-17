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
      'de': 'Jerman',
      'it': 'Italia',
      'ru': 'Rusia',
      'ar': 'Arab',
      'nl': 'Belanda',
      'pt': 'Portugis',
      'zh': 'Mandarin',
      'th': 'Thailand',
      'vi': 'Vietnam',
      'tr': 'Turki',
      'hi': 'Hindi',
      'sv': 'Swedia',
      'no': 'Norwegia',
      'da': 'Denmark',
      'fi': 'Finlandia',
      'pl': 'Polandia',
      'uk': 'Ukraina',
      'el': 'Yunani',
      'he': 'Ibrani',
      'ms': 'Melayu',
      'tl': 'Filipina',
      'cs': 'Ceko',
      'hu': 'Hongaria',
      'ro': 'Rumania',
      'bg': 'Bulgaria',
      'hr': 'Kroasia',
      'sk': 'Slowakia',
      'sl': 'Slovenia',
      'sw': 'Swahili',
      'fa': 'Persia',
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
  String get settings_language_alert_title => 'Ubah Bahasa Aplikasi & Deck';

  @override
  String get settings_language_alert_message =>
      'Mengubah bahasa di sini akan membuat deck dan penjelasan ke depannya dijelaskan serta diterjemahkan menggunakan bahasa yang dipilih.';

  @override
  String get settings_language_alert_confirm => 'Ubah Bahasa';

  @override
  String get settings_language_alert_cancel => 'Batal';

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
  String get shareData_or => 'atau';

  @override
  String get shareData_scanQrButton => 'Pindai Kode QR';

  @override
  String get shareData_scanner_title => 'Pindai QR Penerima';

  @override
  String get shareData_scanner_instruction =>
      'Arahkan kamera ke kode QR di perangkat penerima';

  @override
  String get shareData_scanner_permission_denied =>
      'Izin kamera diperlukan untuk memindai kode QR';

  @override
  String get shareData_scanner_error => 'Tidak dapat mengakses kamera';

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
  String deck_gen_limit_reached_title(String time) {
    return 'Batas harian AI Online tercapai (1 deck/hari). Reset dalam $time.';
  }

  @override
  String deck_gen_limit_countdown_button(String time) {
    return 'Buat Deck (Reset dalam $time)';
  }

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
  String deck_gen_cards_collected_progress(int count, int total) {
    return 'Terkumpul $count / $total kartu';
  }

  @override
  String get deck_gen_in_progress_badge => 'Membuat...';

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
  String get deck_compilation_title => 'Kompilasi Deck';

  @override
  String get deck_search_hint => 'Cari deck anda...';

  @override
  String get deck_select_all => 'Pilih semua';

  @override
  String get deck_deselect_all => 'Batal pilih semua';

  @override
  String deck_selected_count(int count) {
    return '$count deck terpilih';
  }

  @override
  String get deck_delete_button => 'Hapus';

  @override
  String get deck_delete_dialog_title => 'Hapus Deck Ini??';

  @override
  String get deck_delete_dialog_body =>
      'Tindakan ini tidak dapat dibatalkan. Ketik username kamu untuk mengonfirmasi.';

  @override
  String deck_delete_dialog_hint(String username) {
    return 'Ketik \"$username\"...';
  }

  @override
  String get deck_empty_search_title => 'Deck tidak ditemukan';

  @override
  String get deck_add_fab_tooltip => 'Tambah Deck';

  @override
  String get nav_home => 'Beranda';

  @override
  String get nav_deck => 'Deck';

  @override
  String get nav_settings => 'Pengaturan';

  @override
  String get deck_details_play_quiz => 'Mainkan\nQuiz';

  @override
  String get deck_details_play_flashcard => 'Mainkan\nFlash Card';

  @override
  String get deck_details_streak_label => 'Streak';

  @override
  String get deck_details_accuracy_label => 'Akurasi';

  @override
  String get deck_details_search_hint => 'Cari kartu...';

  @override
  String get deck_details_empty_cards => 'Kartu tidak ditemukan';

  @override
  String get deck_details_card_description_label => 'DESKRIPSI';

  @override
  String get deck_details_history_tooltip => 'Riwayat';

  @override
  String get deck_progress_streak_title => 'Waktu Aktif';

  @override
  String get deck_progress_accuracy_title => 'Accuracy';

  @override
  String get deck_progress_streaks_label => 'Streaks';

  @override
  String get deck_progress_accuracy_subtitle => 'Akurasi Bulan Ini';

  @override
  String deck_progress_comparison_vs_last_month(String diff, int lastMonth) {
    return '$diff% dibanding bulan lalu ($lastMonth%)';
  }

  @override
  String deck_progress_active_comparison_vs_last_month(
    int thisMonth,
    int lastMonth,
  ) {
    return '${thisMonth}m bulan ini (${lastMonth}m bulan lalu)';
  }

  @override
  String get deck_progress_weekly_streaks_title => 'Weekly Streaks';

  @override
  String get deck_progress_weekly_restarts_note =>
      '*This will be restarted every week';

  @override
  String get deck_progress_day_mon_short => 'Sen';

  @override
  String get deck_progress_day_tue_short => 'Sel';

  @override
  String get deck_progress_day_wed_short => 'Rab';

  @override
  String get deck_progress_day_thu_short => 'Kam';

  @override
  String get deck_progress_day_fri_short => 'Jum';

  @override
  String get deck_progress_day_sat_short => 'Sab';

  @override
  String get deck_progress_day_sun_short => 'Min';

  @override
  String get deck_progress_day_sun => 'Minggu';

  @override
  String get deck_progress_day_mon => 'Senin';

  @override
  String get deck_progress_day_tue => 'Selasa';

  @override
  String get deck_progress_day_wed => 'Rabu';

  @override
  String get deck_progress_day_thu => 'Kamis';

  @override
  String get deck_progress_day_fri => 'Jum\'at';

  @override
  String get deck_progress_day_sat => 'Sabtu';

  @override
  String get deck_progress_tab_month => 'Bulan';

  @override
  String get deck_progress_tab_year => 'Tahun';

  @override
  String get deck_progress_metric_card => 'Card';

  @override
  String get deck_progress_metric_accurate => 'Akurat';

  @override
  String get deck_progress_metric_active => 'Aktif';

  @override
  String get deck_progress_weakest_cards_title => '3 Kartu Paling Lemah';

  @override
  String get deck_progress_weakest_empty =>
      'Belum ada kartu yang dipelajari pada periode ini';

  @override
  String deck_progress_wrong_count(int count) {
    return '${count}x Salah';
  }

  @override
  String deck_progress_accurate_percent(int percent) {
    return '$percent% Akurat';
  }

  @override
  String get flashcard_title => 'Flashcard';

  @override
  String get flashcard_instruction =>
      'Perhatikan kata berikut lalu balik kartu untuk melihat arti:';

  @override
  String flashcard_card_progress(int current, int total) {
    return 'Kartu $current dari $total';
  }

  @override
  String get flashcard_question_label => 'Pertanyaan';

  @override
  String get flashcard_answer_label => 'Jawaban';

  @override
  String get flashcard_tap_to_flip => 'Ketuk untuk melihat arti';

  @override
  String get flashcard_flip_button => 'Balik Kartu';

  @override
  String get flashcard_not_memorized => 'Belum hafal';

  @override
  String get flashcard_memorized => 'Sudah hafal';

  @override
  String get flashcard_complete_title => 'Latihan Selesai';

  @override
  String flashcard_complete_cards_value(int count) {
    return '${count}Card';
  }

  @override
  String get flashcard_complete_memorized_label => 'Sudah Hafal';

  @override
  String get flashcard_complete_not_memorized_label => 'Belum Hafal';

  @override
  String flashcard_complete_active_time_value(int minutes, int seconds) {
    return '+${minutes}m ${seconds}d';
  }

  @override
  String get flashcard_complete_active_time_label => 'Waktu Aktif Sesi';

  @override
  String get flashcard_complete_finish_button => 'Selesai';

  @override
  String get quiz_title => 'Quiz';

  @override
  String get quiz_mc_instruction =>
      'Pilih arti yang sesuai untuk kata berikut:';

  @override
  String get quiz_context_instruction =>
      'Tebak kosakata yang tepat berdasarkan konteks ini:';

  @override
  String get quiz_jumble_instruction =>
      'Ketik atau susun terjemahan untuk kata ini:';

  @override
  String get quiz_jumble_placeholder => 'Tarik kata yang anda pilih ke sini';

  @override
  String get quiz_check_answer_button => 'Periksa Jawaban';

  @override
  String get quiz_feedback_correct_title => 'Jawaban Tepat Sekali';

  @override
  String get quiz_feedback_wrong_title => 'Jawaban yang benar adalah';

  @override
  String get quiz_continue_button => 'Lanjut';

  @override
  String quiz_complete_score_value(int correct, int total) {
    return '$correct / $total';
  }

  @override
  String get quiz_complete_correct_label => 'Jawaban Tepat';

  @override
  String get deck_history_title => 'Riwayat Aktifitas';

  @override
  String get deck_history_period_week => 'Minggu ini';

  @override
  String get deck_history_period_month => 'Bulan ini';

  @override
  String get deck_history_period_year => 'Tahun ini';

  @override
  String get deck_history_summary_week => 'Ringkasan Minggu ini';

  @override
  String get deck_history_summary_month => 'Ringkasan Bulan ini';

  @override
  String get deck_history_summary_year => 'Ringkasan Tahun ini';

  @override
  String get deck_history_total_activities => 'Total Aktivitas';

  @override
  String get deck_history_study_time => 'Waktu Belajar';

  @override
  String get deck_history_avg_accuracy => 'Rata-Rata Akurasi';

  @override
  String deck_history_sessions_count(int count) {
    return '$count sesi';
  }

  @override
  String get deck_history_activities_title => 'Aktifitas Belajar';

  @override
  String deck_history_activities_count(int count) {
    return '$count aktifitas';
  }

  @override
  String get deck_history_empty_title => 'Belum Ada Aktivitas';

  @override
  String get deck_history_empty_subtitle =>
      'Selesaikan sesi flashcard atau kuis untuk melihat riwayat belajarmu di sini.';

  @override
  String get deck_history_quiz_label => 'Kuis kata';

  @override
  String get deck_history_flashcard_label => 'Flashcard';

  @override
  String deck_history_score_badge(int correct, int total) {
    return '$correct / $total Benar';
  }

  @override
  String deck_history_minutes_badge(int minutes) {
    return '$minutes Menit';
  }

  @override
  String deck_history_seconds_badge(int seconds) {
    return '$seconds Dtk';
  }

  @override
  String get deck_history_sheet_correct_answers => 'Jawaban Tepat';

  @override
  String get deck_history_sheet_session_duration => 'Durasi Sesi';

  @override
  String get deck_history_sheet_accuracy => 'Akurasi';

  @override
  String get deck_history_sheet_cards_studied => 'Kartu yang di pelajari';

  @override
  String get deck_history_sheet_mastered => 'Hafal';

  @override
  String get deck_history_sheet_needs_review => 'Perlu diulang';

  @override
  String get deck_history_sheet_close => 'Tutup rincian';

  @override
  String get deck_history_time_today => 'Hari ini';

  @override
  String get deck_history_time_yesterday => 'Kemarin';

  @override
  String get nav_multiplayer => 'Laga';

  @override
  String get multiplayer_title => 'Bermain bersama';

  @override
  String get multiplayer_banner_title => 'Latihan bersama teman';

  @override
  String get multiplayer_banner_desc =>
      'Belajar kooperatif 2 pemain di jaringan Wi-Fi yang sama tanpa kuota internet.';

  @override
  String get multiplayer_create_room => 'Buat Ruangan Baru';

  @override
  String get multiplayer_create_room_desc =>
      'Jadikan perangkat anda sebagai host';

  @override
  String get multiplayer_join_room => 'Gabung ruangan';

  @override
  String get multiplayer_join_room_desc => 'Gabung keruangan yang sudah ada';

  @override
  String get multiplayer_room_title => 'Ruangan';

  @override
  String get multiplayer_room_ip_label => 'ALAMAT PERANGKAT INI';

  @override
  String get multiplayer_room_scan_label => 'atau pindai kode ini';

  @override
  String get multiplayer_room_waiting => 'Menunggu data dari perangkat lain...';

  @override
  String get multiplayer_room_wifi_note =>
      'Pastikan kedua perangkat terhubung ke jaringan Wi-Fi yang sama.';

  @override
  String get multiplayer_join_scan_qr => 'Ketuk untuk pindai QR Host';

  @override
  String get multiplayer_join_or_scan => 'atau lakukan scan qr code';

  @override
  String get multiplayer_join_ip_placeholder => 'Masukan IP Address Host....';

  @override
  String get multiplayer_join_button => 'Gabung Ruangan';

  @override
  String get multiplayer_lobby_title => 'Lobi latihan';

  @override
  String multiplayer_lobby_connected_count(int current, int total) {
    return 'Pemain Terhubung ($current/$total)';
  }

  @override
  String get multiplayer_lobby_role_host => 'Pemberi Petunjuk';

  @override
  String get multiplayer_lobby_role_guesser => 'Penebak';

  @override
  String get multiplayer_lobby_ready => 'Siap';

  @override
  String get multiplayer_lobby_start_button => 'Pilih Deck';

  @override
  String get multiplayer_lobby_waiting_host => 'Menunggu Host memilih deck...';

  @override
  String get multiplayer_select_deck_title => 'Pilih Deck';

  @override
  String get multiplayer_select_deck_search => 'Cari deck anda...';

  @override
  String get multiplayer_game_title => 'Latihan bersama';

  @override
  String multiplayer_host_elaborate_prompt(String name) {
    return 'Jelaskan Kepada $name terkait kata yang diatas';
  }

  @override
  String multiplayer_guesser_listen_prompt(String name) {
    return 'Dengarkan penjelasan dari $name';
  }

  @override
  String multiplayer_guesser_waiting_title(String name) {
    return 'Menunggu Jawaban Dari $name....';
  }

  @override
  String multiplayer_guesser_waiting_desc(String name) {
    return '$name (Pemberi Petunjuk) Sedang Memilih Jawaban Dari Sistem. Tetap Rileks Dan Bersiaplah!';
  }

  @override
  String get multiplayer_score_plus => '+1';

  @override
  String get multiplayer_score_minus => '-1';

  @override
  String get multiplayer_score_zero => '+0';

  @override
  String get multiplayer_score_label => 'Poin';

  @override
  String get multiplayer_score_total => 'Total Skor Kalian Saat Ini:';

  @override
  String multiplayer_score_points(int score) {
    return '$score Poin';
  }

  @override
  String get multiplayer_continue_button => 'Lanjutkan Soal';

  @override
  String get multiplayer_complete_title => 'Latihan Bersama Selesai';

  @override
  String multiplayer_complete_correct_count(int correct, int total) {
    return '$correct / $total';
  }

  @override
  String get multiplayer_complete_correct_label => 'Jawaban Tepat';

  @override
  String get multiplayer_complete_time_label => 'Waktu Aktif Sesi';

  @override
  String get multiplayer_back_button => 'Kembali';

  @override
  String get multiplayer_history_title => 'Riwayat Latihan Bersama';

  @override
  String get multiplayer_leave_confirm_title => 'Keluar dari Ruangan?';

  @override
  String get multiplayer_leave_confirm_desc =>
      'Sesi latihan akan dihentikan untuk kedua pemain.';

  @override
  String get multiplayer_leave_confirm_yes => 'Keluar';

  @override
  String get multiplayer_leave_confirm_no => 'Batal';

  @override
  String get ai_mode_choose_title => 'Pilih mode pemrosesan AI';

  @override
  String get ai_mode_choose_subtitle =>
      'Tentukan bagaimana AI BASA membuat kartu kosakata untuk Anda. Pilihan ini dapat diubah kapan saja di Pengaturan.';

  @override
  String get ai_mode_feature_header => 'Fitur';

  @override
  String get ai_mode_online_header => 'Online';

  @override
  String get ai_mode_local_header => 'Local';

  @override
  String get ai_feature_unlimited_generation => 'Generate deck tanpa batasan';

  @override
  String get ai_feature_offline_use =>
      'Dapat digunakan tanpa internet (offline)';

  @override
  String get ai_feature_private_storage =>
      'Data tersimpan aman di perangkat (privat)';

  @override
  String get ai_feature_faster_process => 'Proses generate lebih cepat';

  @override
  String get ai_feature_broader_context =>
      'Konteks data kosakata lebih luas & dinamis';

  @override
  String get ai_feature_more_accurate => 'Hasil kosakata lebih akurat';

  @override
  String get ai_feature_daily_limit => 'Batas 1 deck per hari';

  @override
  String get ai_feature_requires_internet => 'Memerlukan koneksi internet';

  @override
  String get ai_feature_data_training => 'Data digunakan untuk melatih AI';

  @override
  String get ai_button_start_download => 'Mulai Download (2.59GB)';

  @override
  String get ai_button_continue_online => 'lanjut menggunakan model online';

  @override
  String get ai_download_progress_title => 'Download AI local Berlangsung...';

  @override
  String get ai_download_continue_in_background =>
      'Lanjutkan di Latar Belakang';

  @override
  String get ai_download_retry => 'Coba Unduh Lagi';

  @override
  String get ai_download_error_title => 'Download Gagal';

  @override
  String get ai_download_complete_title => 'Download AI Berhasil';

  @override
  String get ai_download_complete_subtitle =>
      'Profilmu sudah siap digunakan. Mari lanjutkan perjalanan belajarmu dengan tenang.';

  @override
  String get ai_download_complete_button => 'Selesai';

  @override
  String get settings_ai_title => 'Mode Pemrosesan AI';

  @override
  String get settings_ai_subtitle => 'Atur model pemrosesan AI dan API Gemini';

  @override
  String get settings_gemini_api_key => 'Kunci API Gemini';

  @override
  String get settings_gemini_api_key_desc =>
      'Dibutuhkan untuk pembuatan AI Online';

  @override
  String get settings_gemini_api_key_hint => 'Masukkan kunci API Gemini...';

  @override
  String get settings_gemini_guide => 'Panduan Pengaturan API Gemini';

  @override
  String get settings_local_model_status => 'Status Model Lokal';

  @override
  String settings_local_model_downloaded(String size) {
    return 'Sudah Diunduh ($size)';
  }

  @override
  String get settings_local_model_not_downloaded => 'Belum Diunduh';

  @override
  String get settings_download_local_model => 'Unduh Model Lokal (2.59GB)';

  @override
  String get settings_delete_local_model => 'Hapus Model Lokal';

  @override
  String get deck_gen_online_daily_limit_reached =>
      'Batas pembuatan deck online tercapai (maksimum 1 deck per hari). Silakan gunakan AI Lokal atau coba lagi besok.';

  @override
  String get settings_cancel_download => 'Batal';

  @override
  String get settings_delete_local_model_confirm_title =>
      'Hapus Model AI Lokal?';

  @override
  String get settings_delete_local_model_confirm_desc =>
      'Tindakan ini akan menghapus file model 2.59 GB dari penyimpanan perangkat. Anda dapat mengunduhnya kembali kapan saja.';

  @override
  String get settings_local_model_downloading =>
      'Sedang mengunduh model AI lokal...';

  @override
  String get end_of_translation => '';
}
