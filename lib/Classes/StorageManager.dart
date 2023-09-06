import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageManager {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  StorageManager();
  Future<void> storeObject(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> getObject(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> deleteObject(String key) async {
    await _storage.delete(key: key);
  }
}
