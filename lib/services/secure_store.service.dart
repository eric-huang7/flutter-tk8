import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStoreService {
  final FlutterSecureStorage _store;

  SecureStoreService([FlutterSecureStorage store])
      : _store = store ?? const FlutterSecureStorage();

  Future<String> getSecureValueForKey(String key) {
    return _store.read(key: key);
  }

  Future<void> setSecureValue(String key, String value) async {
    await _store.write(key: key, value: value);
  }

  Future<void> deleteValueForKey(String key) async {
    await _store.delete(key: key);
  }
}
