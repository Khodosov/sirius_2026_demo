import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageManager {
  static const _keyString = 'secure_string';
  static const _keyNumber = 'secure_number';

  final _storage = const FlutterSecureStorage();

  Future<void> saveString(String value) async {
    await _storage.write(key: _keyString, value: value);
    print('[SecureStorage] Saved string with key "$_keyString"');
  }

  Future<void> saveNumber(int value) async {
    await _storage.write(key: _keyNumber, value: value.toString());
    print('[SecureStorage] Saved number with key "$_keyNumber"');
  }

  Future<String?> getString() async {
    return _storage.read(key: _keyString);
  }

  Future<int?> getNumber() async {
    final value = await _storage.read(key: _keyNumber);
    return value != null ? int.tryParse(value) : null;
  }

  Future<Map<String, String>> getAll() async {
    return _storage.readAll();
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
    print('[SecureStorage] All keys deleted');
  }

  void dispose() {}
}
