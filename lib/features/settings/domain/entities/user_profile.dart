/// Domain entity representing a user profile.
class UserProfile {
  final String username;
  final String? photoPath;
  final DateTime? updatedAt;

  const UserProfile({
    required this.username,
    this.photoPath,
    this.updatedAt,
  });

  UserProfile copyWith({
    String? username,
    String? photoPath,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      username: username ?? this.username,
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
          photoPath == other.photoPath &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode => Object.hash(username, photoPath, updatedAt);
}

