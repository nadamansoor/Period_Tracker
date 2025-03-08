import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile.dart';

class ProfileProvider {
  static const String _profileKey = 'user_profile'; 

  static Future<void> saveProfile(Profile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, jsonEncode(profile.toMap()));
  }

  static Future<Profile?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileData = prefs.getString(_profileKey);
    if (profileData != null) {
      return Profile.fromMap(jsonDecode(profileData));
    }
    return null;
  }

  static Future<void> deleteProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileKey);
  }
}