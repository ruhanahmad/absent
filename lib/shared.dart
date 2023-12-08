import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {
  static SharedPreferences? _preferences;

  // Initialize shared preferences in the constructor
  PreferencesManager._privateConstructor();
  static final PreferencesManager instance = PreferencesManager._privateConstructor();

  Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Example method to get a stored preference
  String getUserName() {
    return _preferences!.getString('username') ?? '';
  }

  // Example method to set a preference
  Future<void> setUserName(String username) async {
    await _preferences!.setString('username', username);
  }

   Future<void> removeUserName() async {
    await _preferences!.remove('username');
  }
}


