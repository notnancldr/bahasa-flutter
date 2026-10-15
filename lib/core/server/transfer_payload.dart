import 'dart:convert';

/// Complete backup bundle used for transferring data between devices.
class TransferPayload {
  /// Schema version of the payload.
  final int version;

  /// Timestamp when the export was generated.
  final DateTime exportedAt;

  /// Profile data payload.
  final Map<String, dynamic> profile;

  /// App settings preferences (theme mode, notifications).
  final Map<String, dynamic> settings;

  /// Database tables from basa.sqlite and per-deck databases.
  final Map<String, dynamic> database;

  /// Creates a [TransferPayload] instance.
  const TransferPayload({
    this.version = 1,
    required this.exportedAt,
    required this.profile,
    required this.settings,
    required this.database,
  });

  /// Serializes this payload to a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'exportedAt': exportedAt.toIso8601String(),
      'profile': profile,
      'settings': settings,
      'database': database,
    };
  }

  /// Encodes this payload to a JSON string.
  String toJsonString() => jsonEncode(toJson());

  /// Deserializes a [TransferPayload] from a JSON map.
  factory TransferPayload.fromJson(Map<String, dynamic> json) {
    final version = json['version'] as int? ?? 1;
    final exportedAtStr = json['exportedAt'] as String?;
    final exportedAt = exportedAtStr != null
        ? DateTime.tryParse(exportedAtStr) ?? DateTime.now()
        : DateTime.now();
    final profile = json['profile'] as Map<String, dynamic>? ?? {};
    final settings = json['settings'] as Map<String, dynamic>? ?? {};
    final database = json['database'] as Map<String, dynamic>? ?? {};

    return TransferPayload(
      version: version,
      exportedAt: exportedAt,
      profile: profile,
      settings: settings,
      database: database,
    );
  }

  /// Parses a [TransferPayload] from a JSON string.
  factory TransferPayload.fromJsonString(String rawJson) {
    final decoded = jsonDecode(rawJson);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Root of payload must be a JSON object.');
    }
    return TransferPayload.fromJson(decoded);
  }
}
