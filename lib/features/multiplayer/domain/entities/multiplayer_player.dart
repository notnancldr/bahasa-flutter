/// Domain entity representing a connected player in a multiplayer quiz session.
class MultiplayerPlayer {
  /// Unique identifier of the player.
  final String id;

  /// Display name of the player.
  final String name;

  /// Whether this player is the room host (Pemberi Petunjuk).
  final bool isHost;

  /// Whether this player is ready in the lobby.
  final bool isReady;

  /// Avatar badge text (e.g. "P1" or "P2").
  final String badgeText;

  /// Creates a [MultiplayerPlayer].
  const MultiplayerPlayer({
    required this.id,
    required this.name,
    required this.isHost,
    this.isReady = true,
    required this.badgeText,
  });

  /// Role label key/type for presentation display.
  String get roleType => isHost ? 'host' : 'guesser';

  /// Serializes player to JSON map for network transmission.
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'isHost': isHost,
    'isReady': isReady,
    'badgeText': badgeText,
  };

  /// Deserializes player from JSON map.
  factory MultiplayerPlayer.fromJson(Map<String, dynamic> json) {
    return MultiplayerPlayer(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      isHost: json['isHost'] as bool? ?? false,
      isReady: json['isReady'] as bool? ?? true,
      badgeText:
          json['badgeText'] as String? ??
          (json['isHost'] == true ? 'P1' : 'P2'),
    );
  }
}
