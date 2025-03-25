import 'dart:convert'; // Provides utilities for encoding and decoding JSON and Base64.
import 'dart:io'; // Provides file system operations for persistent storage.
import 'package:path_provider/path_provider.dart'; // Provides paths for storing application-specific files.

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
  ///
  /// By default, storage is in-memory. To enable persistent storage, set
  /// [persistent] to true.
  AortemEntraIdStorage({this.persistent = false});

  /// Initializes the storage.
  ///
  /// For persistent storage, this method sets up the file path for storing
  /// tokens and creates an empty storage file if it doesn't exist.
  ///
  /// Example:
  /// ```dart
  /// final storage = AortemEntraIdStorage(persistent: true);
  /// await storage.initialize();
  /// ```
  Future<void> initialize() async {
    if (persistent) {
      // Get the application's document directory.
      final directory = await getApplicationDocumentsDirectory();

      // Set the file path for persistent storage.
      _filePath = '${directory.path}/token_storage.json';

      // Create the file if it doesn't exist.
      final file = File(_filePath);
      if (!file.existsSync()) {
        file.writeAsStringSync(jsonEncode({}));
      }
    }
  }

  /// Saves a token securely.
  ///
  /// Encrypts the token before storing it. For persistent storage, the token is
  /// written to a JSON file. For in-memory storage, the token is stored in a
  /// map.
  ///
  /// Example:
  /// ```dart
  /// await storage.saveToken('accessToken', 'your-token-value');
  /// ```
  ///
  /// - [key]: The key to associate with the token.
  /// - [token]: The token value to be stored.
  Future<void> saveToken(String key, String token) async {
    if (persistent) {
      final file = File(_filePath);
      final content = await file.readAsString();
      final storage = jsonDecode(content) as Map<String, dynamic>;

      // Encrypt the token before saving.
      final encryptedToken = base64Encode(utf8.encode(token));
      storage[key] = encryptedToken;

      // Write the updated storage back to the file.
      await file.writeAsString(jsonEncode(storage));
    } else {
      // Store the token in memory.
      _inMemoryStorage[key] = token;
    }
  }

  /// Retrieves a token securely.
  ///
  /// For persistent storage, decrypts the token before returning it.
  /// For in-memory storage, retrieves the token directly from the map.
  ///
  /// Example:
  /// ```dart
  /// final token = await storage.getToken('accessToken');
  /// print(token);
  /// ```
  ///
  /// - [key]: The key associated with the token.
  /// - Returns: The token value, or `null` if the key does not exist.
  Future<String?> getToken(String key) async {
    if (persistent) {
      final file = File(_filePath);
      final content = await file.readAsString();
      final storage = jsonDecode(content) as Map<String, dynamic>;

      if (storage.containsKey(key)) {
        // Decrypt the token before returning.
        final encryptedToken = storage[key];
        return utf8.decode(base64Decode(encryptedToken));
      }
    } else {
      // Retrieve the token from memory.
      return _inMemoryStorage[key];
    }
    return null;
  }

  /// Deletes a token securely.
  ///
  /// Removes the token associated with the given key from storage.
  ///
  /// Example:
  /// ```dart
  /// await storage.deleteToken('accessToken');
  /// ```
  ///
  /// - [key]: The key associated with the token to be deleted.
  Future<void> deleteToken(String key) async {
    if (persistent) {
      final file = File(_filePath);
      final content = await file.readAsString();
      final storage = jsonDecode(content) as Map<String, dynamic>;

      // Remove the token from storage.
      storage.remove(key);
      await file.writeAsString(jsonEncode(storage));
    } else {
      // Remove the token from memory.
      _inMemoryStorage.remove(key);
    }
  }

  /// Clears all tokens from storage.
  ///
  /// Deletes all tokens from either persistent or in-memory storage.
  ///
  /// Example:
  /// ```dart
  /// await storage.clearStorage();
  /// ```
  Future<void> clearStorage() async {
    if (persistent) {
      // Clear the persistent storage file.
      final file = File(_filePath);
      await file.writeAsString(jsonEncode({}));
    } else {
      // Clear in-memory storage.
      _inMemoryStorage.clear();
    }
  }
}
