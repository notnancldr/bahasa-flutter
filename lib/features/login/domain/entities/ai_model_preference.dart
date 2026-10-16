/// Enum representing the AI model processing mode selected by the user.
enum AiModelType {
  online,
  local;

  /// Parses an [AiModelType] from a stored string value.
  static AiModelType fromStorage(String? value) {
    if (value == 'local') return AiModelType.local;
    return AiModelType.online;
  }

  /// Converts this [AiModelType] to a storage string.
  String toStorage() => name;
}

/// Download lifecycle status for the local Gemma 4 model.
enum ModelDownloadStatus { idle, downloading, completed, failed }

/// Progress state entity for local model downloading.
class ModelDownloadProgress {
  /// Total bytes downloaded so far.
  final int downloadedBytes;

  /// Expected total bytes to download (e.g. 2.59GB = 2,781,102,080 bytes).
  final int totalBytes;

  /// Status of the download.
  final ModelDownloadStatus status;

  /// Optional error message if download failed.
  final String? errorMessage;

  const ModelDownloadProgress({
    required this.downloadedBytes,
    required this.totalBytes,
    required this.status,
    this.errorMessage,
  });

  /// Initial idle state.
  const ModelDownloadProgress.idle()
    : downloadedBytes = 0,
      totalBytes = 2781102080,
      status = ModelDownloadStatus.idle,
      errorMessage = null;

  /// Completed state.
  const ModelDownloadProgress.completed()
    : downloadedBytes = 2781102080,
      totalBytes = 2781102080,
      status = ModelDownloadStatus.completed,
      errorMessage = null;

  /// Percentage progress from 0.0 to 1.0.
  double get progressFraction {
    if (totalBytes <= 0) return 0.0;
    return (downloadedBytes / totalBytes).clamp(0.0, 1.0);
  }

  /// Percentage integer (0 to 100).
  int get percentage => (progressFraction * 100).round();

  /// Formatted downloaded / total string (e.g. "90MB/2.59GB").
  String get formattedProgress {
    final downloadedMb = (downloadedBytes / (1024 * 1024)).toStringAsFixed(0);
    final totalGb = (totalBytes / (1024 * 1024 * 1024)).toStringAsFixed(2);
    return '${downloadedMb}MB/${totalGb}GB';
  }
}
