import 'package:bahasa/features/settings/domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.username,
    required super.defaultLanguage,
    super.photoPath,
    super.updatedAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      username: json['username'] as String? ?? 'User',
      defaultLanguage: json['default_language'] as String? ?? 'en',
      photoPath: json['photo_path'] as String?,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
    );
  }

  factory UserProfileModel.fromEntity(UserProfile entity) {
    return UserProfileModel(
      username: entity.username,
      defaultLanguage: entity.defaultLanguage,
      photoPath: entity.photoPath,
      updatedAt: entity.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'default_language': defaultLanguage,
      'photo_path': photoPath,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
