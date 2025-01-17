import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// AortemEntraIdStorage: Manages token storage for Aortem EntraId SDK.
class AortemEntraIdStorage {
  final bool persistent;
  final Map<String, String> _inMemoryStorage = {};
  late String _filePath;

  AortemEntraIdStorage({this.persistent = false});

  /// Initialize the storage.
  Future<void> initialize() async {
    if (persistent) {
      final directory = await getApplicationDocumentsDirectory();
      _filePath = '${directory.path}/token_storage.json';

      // Create the file if it doesn't exist
      final file = File(_filePath);
      if (!file.existsSync()) {
        file.writeAsStringSync(jsonEncode({}));
      }
    }
  }

  /// Save a token securely.
  Future<void> saveToken(String key, String token) async {
    if (persistent) {
      final file = File(_filePath);
      final content = await file.readAsString();
      final storage = jsonDecode(content) as Map<String, dynamic>;

      // Encrypt the token before saving
      final encryptedToken = base64Encode(utf8.encode(token));
      storage[key] = encryptedToken;

      await file.writeAsString(jsonEncode(storage));
    } else {
      _inMemoryStorage[key] = token;
    }
  }

  /// Retrieve a token securely.
  Future<String?> getToken(String key) async {
    if (persistent) {
      final file = File(_filePath);
      final content = await file.readAsString();
      final storage = jsonDecode(content) as Map<String, dynamic>;

      if (storage.containsKey(key)) {
        final encryptedToken = storage[key];
        return utf8.decode(base64Decode(encryptedToken));
      }
    } else {
      return _inMemoryStorage[key];
    }
    return null;
  }

  /// Delete a token securely.
  Future<void> deleteToken(String key) async {
    if (persistent) {
      final file = File(_filePath);
      final content = await file.readAsString();
      final storage = jsonDecode(content) as Map<String, dynamic>;

      storage.remove(key);
      await file.writeAsString(jsonEncode(storage));
    } else {
      _inMemoryStorage.remove(key);
    }
  }

  /// Clear all tokens from storage.
  Future<void> clearStorage() async {
    if (persistent) {
      final file = File(_filePath);
      await file.writeAsString(jsonEncode({}));
    } else {
      _inMemoryStorage.clear();
    }
  }
}
