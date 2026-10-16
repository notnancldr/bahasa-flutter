class NotificationState {
  final bool isEnabled;
  final bool isLoading;
  final bool isApplied;
  final String? errorMessage;

  const NotificationState({
    this.isEnabled = true,
    this.isLoading = false,
    this.isApplied = false,
    this.errorMessage,
  });

  NotificationState copyWith({
    bool? isEnabled,
    bool? isLoading,
    bool? isApplied,
    String? errorMessage,
  }) {
    return NotificationState(
      isEnabled: isEnabled ?? this.isEnabled,
      isLoading: isLoading ?? this.isLoading,
      isApplied: isApplied ?? this.isApplied,
      errorMessage: errorMessage,
    );
  }
}
