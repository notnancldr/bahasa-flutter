/// Domain entity representing a user profile.
class UserProfile {
  final String username;
  final String defaultLanguage;
  final String? photoPath;
  final DateTime? updatedAt;

  const UserProfile({
    required this.username,
    required this.defaultLanguage,
    this.photoPath,
    this.updatedAt,
  });

  UserProfile copyWith({
    String? username,
    String? defaultLanguage,
    String? photoPath,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      username: username ?? this.username,
      defaultLanguage: defaultLanguage ?? this.defaultLanguage,
      photoPath: photoPath ?? this.photoPath,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfile &&
          runtimeType == other.runtimeType &&
          username == other.username &&
          defaultLanguage == other.defaultLanguage &&
          photoPath == other.photoPath &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      Object.hash(username, defaultLanguage, photoPath, updatedAt);
}
