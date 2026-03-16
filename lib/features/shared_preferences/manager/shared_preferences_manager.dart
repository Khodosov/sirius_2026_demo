import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static const _keyString = 'saved_string';
  static const _keyNumber = 'saved_number';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool get isReady => _prefs != null;

  Future<void> saveString(String value) async {
    await _prefs?.setString(_keyString, value);
  }

  Future<void> saveNumber(int value) async {
    await _prefs?.setInt(_keyNumber, value);
  }

  String? getString() {
    return _prefs?.getString(_keyString);
  }

  int? getNumber() {
    return _prefs?.getInt(_keyNumber);
  }

  void dispose() {
    _prefs = null;
  }
}
