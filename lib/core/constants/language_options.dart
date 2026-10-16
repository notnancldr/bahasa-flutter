class LanguageOption {
  final String code;
  final String name;

  const LanguageOption({required this.code, required this.name});
}

const List<LanguageOption> kLanguageOptions = [
  LanguageOption(code: 'id', name: 'Bahasa Indonesia'),
  LanguageOption(code: 'en', name: 'English'),
  LanguageOption(code: 'es', name: 'Español'),
  LanguageOption(code: 'ja', name: '日本語'),
  LanguageOption(code: 'ko', name: '한국어'),
  LanguageOption(code: 'fr', name: 'Francais'),
];
