import 'package:bahasa/features/settings/domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.username,
    super.photoPath,
    super.updatedAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      username: json['username'] as String? ?? 'User',
      photoPath: json['photo_path'] as String?,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
    );
  }

  factory UserProfileModel.fromEntity(UserProfile entity) {
    return UserProfileModel(
      username: entity.username,
      photoPath: entity.photoPath,
      updatedAt: entity.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'photo_path': photoPath,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
