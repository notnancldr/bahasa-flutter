class TransferValidationResult {
  final bool isValid;
  final String? username;
  final String? defaultLanguage;
  final String? errorMessage;

  const TransferValidationResult({
    required this.isValid,
    this.username,
    this.defaultLanguage,
    this.errorMessage,
  });
}

