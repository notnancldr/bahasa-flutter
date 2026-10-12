import 'dart:convert';

import 'package:bahasa/core/errors/settings_error.dart';
import 'package:bahasa/features/settings/data/models/user_profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ProfileLocalDataSource {
  Future<UserProfileModel> getProfile();
  Future<UserProfileModel> saveProfile(UserProfileModel profile);
  Future<String?> pickProfilePhoto();
  Future<void> clearProfile();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  static const _profileKey = 'app_user_profile';
  final SharedPreferences? _prefs;

  ProfileLocalDataSourceImpl({this._prefs});

  Future<SharedPreferences> _getPrefs() async {
    return _prefs ?? await SharedPreferences.getInstance();
  }

  @override
  Future<UserProfileModel> getProfile() async {
    final prefs = await _getPrefs();
    final raw = prefs.getString(_profileKey);
    if (raw == null) {
      // Default fallback profile if not yet explicitly saved
      return const UserProfileModel(username: 'User');
    }

    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return UserProfileModel.fromJson(map);
    } catch (_) {
      throw const ProfileNotFoundFailure();
    }
  }

  @override
  Future<UserProfileModel> saveProfile(UserProfileModel profile) async {
    final prefs = await _getPrefs();
    final map = profile.toJson();
    final encoded = jsonEncode(map);
    final success = await prefs.setString(_profileKey, encoded);
    if (!success) {
      throw const StorageOperationFailure('Failed to save profile.');
    }
    return profile;
  }

  @override
  Future<String?> pickProfilePhoto() async {
    // Abstraction for mobile file access:
    // In real device flow, this integrates with file/image picker.
    // Default fallback returns a valid simulated file path.
    return '/storage/emulated/0/DCIM/profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
  }

  @override
  Future<void> clearProfile() async {
    final prefs = await _getPrefs();
    await prefs.remove(_profileKey);
  }
}
