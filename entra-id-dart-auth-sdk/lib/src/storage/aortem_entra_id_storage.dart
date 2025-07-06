import 'dart:convert'; // Provides utilities for encoding and decoding JSON and Base64.
import 'dart:io'; // Provides file system operations for persistent storage.

/// AortemEntraIdStorage: Manages token storage for Aortem EntraId SDK.
///
/// This class provides secure storage for tokens used in the SDK. It supports
/// both in-memory and persistent storage options. Tokens are encrypted when
/// stored persistently to ensure security.
class AortemEntraIdStorage {
  /// Indicates whether the storage is persistent (true) or in-memory (false).
  final bool persistent;

  /// In-memory storage for tokens (used when `persistent` is false).
  final Map<String, String> _inMemoryStorage = {};

  /// File path for persistent token storage.
  late String _filePath;

  /// Creates an instance of `AortemEntraIdStorage`.
  AortemEntraIdStorage({this.persistent = false}) {
    if (persistent) {
      _initializeFilePath();
    }
  }

  /// Initializes the file path for storage.
  void _initializeFilePath() {
    final directory = Directory.current; // Uses the current working directory.
    _filePath = '${directory.path}/token_storage.json';
    final file = File(_filePath);
    if (!file.existsSync()) {
      file.writeAsStringSync(jsonEncode({}));
    }
  }

  /// Saves a token securely.
  Future<void> saveToken(String key, String token) async {
    if (persistent) {
      final file = File(_filePath);
      final content = file.existsSync() ? await file.readAsString() : '{}';
      final storage = jsonDecode(content) as Map<String, dynamic>;
      storage[key] = base64Encode(utf8.encode(token));
      await file.writeAsString(jsonEncode(storage));
    } else {
      _inMemoryStorage[key] = token;
    }
  }

  /// Retrieves a token securely.
  Future<String?> getToken(String key) async {
    if (persistent) {
      final file = File(_filePath);
      if (!file.existsSync()) return null;
      final content = await file.readAsString();
      final storage = jsonDecode(content) as Map<String, dynamic>;
      if (storage.containsKey(key)) {
        return utf8.decode(base64Decode(storage[key]));
      }
    } else {
      return _inMemoryStorage[key];
    }
    return null;
  }

  /// Deletes a token securely.
  Future<void> deleteToken(String key) async {
    if (persistent) {
      final file = File(_filePath);
      if (!file.existsSync()) return;
      final content = await file.readAsString();
      final storage = jsonDecode(content) as Map<String, dynamic>;
      storage.remove(key);
      await file.writeAsString(jsonEncode(storage));
    } else {
      _inMemoryStorage.remove(key);
    }
  }

  /// Clears all tokens from storage.
  Future<void> clearStorage() async {
    if (persistent) {
      final file = File(_filePath);
      if (file.existsSync()) {
        await file.writeAsString(jsonEncode({}));
      }
    } else {
      _inMemoryStorage.clear();
    }
  }
}
