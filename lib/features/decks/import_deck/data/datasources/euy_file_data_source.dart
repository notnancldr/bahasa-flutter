import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../models/euy_deck_model.dart';

/// Data source responsible for accessing and reading `.euy` files on disk.
abstract class EuyFileDataSource {
  /// Reads and parses an `.euy` file at [filePath].
  Future<EuyDeckModel> readEuyFile(String filePath);

  /// Retrieves the file size formatted string for [filePath].
  Future<String> getFileSizeFormatted(String filePath);

  /// Prompts the user to pick an `.euy` file using the system file picker.
  /// Returns the chosen file path, or null if cancelled.
  Future<String?> pickEuyFile();
}

class EuyFileDataSourceImpl implements EuyFileDataSource {
  final Future<String?> Function()? _filePickerProvider;
  final Future<Directory> Function()? _tempDirProvider;

  const EuyFileDataSourceImpl([
    this._filePickerProvider,
    this._tempDirProvider,
  ]);

  @override
  Future<String?> pickEuyFile() async {
    if (_filePickerProvider != null) {
      return _filePickerProvider();
    }

    final result = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['euy'],
    );

    if (result == null) return null;

    // If local file path exists and is accessible, use it directly
    if (result.path != null && result.path!.isNotEmpty) {
      final localFile = File(result.path!);
      if (await localFile.exists()) {
        return result.path;
      }
    }

    // On Android SAF (or content:// URIs), result.path is null.
    // Read the file bytes directly through PlatformFile and cache to app storage.
    final bytes = await result.readAsBytes();
    final tempDir = _tempDirProvider != null
        ? await _tempDirProvider()
        : await getTemporaryDirectory();

    final cachedFile = File('${tempDir.path}/${result.name}');
    await cachedFile.writeAsBytes(bytes);
    return cachedFile.path;
  }

  @override
  Future<EuyDeckModel> readEuyFile(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw FileSystemException('File does not exist', filePath);
    }

    final content = await file.readAsString();
    final dynamic decoded;
    try {
      decoded = jsonDecode(content);
    } catch (e) {
      throw const FormatException('Invalid JSON syntax');
    }

    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Root of .euy must be a JSON object');
    }

    return EuyDeckModel.fromJson(decoded);
  }

  @override
  Future<String> getFileSizeFormatted(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) return '0 B';

    final bytes = await file.length();
    return formatBytes(bytes);
  }

  /// Helper converting byte count to human-readable string.
  static String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
