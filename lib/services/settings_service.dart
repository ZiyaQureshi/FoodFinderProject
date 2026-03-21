import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static Future<String> getDisplayName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('displayName') ?? 'Student';
  }

  static Future<void> setDisplayName(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('displayName', value.trim());
  }

  static Future<String> getMatcherProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('matcherProfile') ?? 'Budget-conscious foodie';
  }

  static Future<void> setMatcherProfile(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('matcherProfile', value.trim());
  }
}
