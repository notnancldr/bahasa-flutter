/// Metadata properties of an `.euy` deck file on disk without schema parsing.
class EuyFileProperty {
  /// The local absolute path to the file.
  final String path;

  /// The file name including extension.
  final String name;

  /// Human-readable file size string (e.g. '12.4 KB').
  final String sizeFormatted;

  const EuyFileProperty({
    required this.path,
    required this.name,
    required this.sizeFormatted,
  });
}
