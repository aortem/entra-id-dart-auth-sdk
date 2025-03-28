import 'dart:convert';
import 'package:logging/logging.dart';
import '../aortem_entra_id_auth_cache_kvstore.dart';
import '../aortem_entra_id_auth_cache_options.dart';

/// Exception thrown for JSON cache operations
/// Exception thrown for errors related to JSON cache operations.
/// This exception is used to handle issues that occur while storing,
/// retrieving, or managing cached JSON data.
class JsonCacheException implements Exception {
  /// The error message describing the issue.
  final String message;

  /// An optional error code to categorize the error.
  final String? code;

  /// Additional details about the error, such as debug information or stack trace.
  final dynamic details;

  /// Creates a new instance of [JsonCacheException].
  ///
  /// - [message]: A required description of the error.
  /// - [code]: An optional identifier for the error type.
  /// - [details]: Optional extra details related to the error, such as a stack trace.
  JsonCacheException(this.message, {this.code, this.details});

  /// Returns a string representation of the exception, including the error message and optional code.
  @override
  String toString() => 'JsonCacheException: $message (Code: $code)';
}

/// Provides JSON-based caching functionality for the Entra ID SDK
class AortemEntraIdAzureJsonCache {
  final Logger _logger = Logger('AortemEntraIdAzureJsonCache');

  /// The underlying key-value store
  final AortemEntraIdCacheKVStore _kvStore;

  /// Cache version for compatibility
  static const String cacheVersion = '1.0';

  /// Cache schema version
  static const String schemaVersion = '1.0';

  /// Creates a new instance of AortemEntraIdAzureJsonCache
  AortemEntraIdAzureJsonCache({AortemEntraIdCacheOptions? options})
    : _kvStore = AortemEntraIdCacheKVStore(
        options ?? AortemEntraIdCacheOptions(namespace: 'azure_json_cache'),
      ) {
    _logger.info('Initializing Azure JSON cache');
  }

  /// Saves data to the cache in JSON format
  Future<void> save(String key, dynamic data) async {
    try {
      final jsonData = _wrapData(data);
      final jsonString = jsonEncode(jsonData);
      await _kvStore.set(key, jsonString);
      _logger.fine('Saved JSON data for key: $key');
    } catch (e) {
      _logger.severe('Failed to save JSON data', e);
      throw JsonCacheException(
        'Failed to save JSON data',
        code: 'save_failed',
        details: e,
      );
    }
  }

  /// Retrieves and deserializes JSON data from the cache
  Future<T?> retrieve<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final jsonString = await _kvStore.get(key);
      if (jsonString == null) {
        _logger.fine('No data found for key: $key');
        return null;
      }

      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      final unwrappedData = _unwrapData(jsonData);

      if (unwrappedData == null) {
        return null;
      }

      return fromJson(unwrappedData as Map<String, dynamic>);
    } catch (e) {
      _logger.severe('Failed to retrieve JSON data', e);
      throw JsonCacheException(
        'Failed to retrieve JSON data',
        code: 'retrieve_failed',
        details: e,
      );
    }
  }

  /// Removes data from the cache
  Future<void> remove(String key) async {
    try {
      await _kvStore.remove(key);
      _logger.fine('Removed data for key: $key');
    } catch (e) {
      _logger.severe('Failed to remove data', e);
      throw JsonCacheException(
        'Failed to remove data',
        code: 'remove_failed',
        details: e,
      );
    }
  }

  /// Clears all data from the cache
  Future<void> clear() async {
    try {
      await _kvStore.clear();
      _logger.info('Cache cleared');
    } catch (e) {
      _logger.severe('Failed to clear cache', e);
      throw JsonCacheException(
        'Failed to clear cache',
        code: 'clear_failed',
        details: e,
      );
    }
  }

  /// Wraps data with metadata for storage
  Map<String, dynamic> _wrapData(dynamic data) {
    return {
      'version': cacheVersion,
      'schema': schemaVersion,
      'timestamp': DateTime.now().toIso8601String(),
      'data': data,
    };
  }

  /// Unwraps data and validates metadata
  dynamic _unwrapData(Map<String, dynamic> wrappedData) {
    // Validate cache version
    if (wrappedData['version'] != cacheVersion) {
      _logger.warning('Cache version mismatch');
      return null;
    }

    // Validate schema version
    if (wrappedData['schema'] != schemaVersion) {
      _logger.warning('Schema version mismatch');
      return null;
    }

    return wrappedData['data'];
  }

  /// Exports the entire cache as a JSON string
  Future<String> exportCache() async {
    try {
      final exportData = {
        'version': cacheVersion,
        'schema': schemaVersion,
        'timestamp': DateTime.now().toIso8601String(),
        'entries': await _getAllEntries(),
      };

      return jsonEncode(exportData);
    } catch (e) {
      _logger.severe('Failed to export cache', e);
      throw JsonCacheException(
        'Failed to export cache',
        code: 'export_failed',
        details: e,
      );
    }
  }

  /// Imports cache data from a JSON string
  Future<void> importCache(String jsonString) async {
    try {
      final importData = jsonDecode(jsonString) as Map<String, dynamic>;

      // Validate import data
      if (importData['version'] != cacheVersion) {
        throw JsonCacheException(
          'Invalid cache version',
          code: 'invalid_version',
        );
      }

      // Clear existing cache
      await clear();

      // Import entries
      final entries = importData['entries'] as Map<String, dynamic>;
      for (var entry in entries.entries) {
        await save(entry.key, entry.value);
      }

      _logger.info('Cache import completed');
    } catch (e) {
      _logger.severe('Failed to import cache', e);
      throw JsonCacheException(
        'Failed to import cache',
        code: 'import_failed',
        details: e,
      );
    }
  }

  /// Gets all cache entries
  Future<Map<String, dynamic>> _getAllEntries() async {
    // Note: This is a simplified implementation.
    // In a real implementation, you would need to handle pagination
    // and large data sets appropriately.
    final entries = <String, dynamic>{};
    // Implementation would depend on the underlying storage mechanism
    return entries;
  }

  /// Disposes of the cache resources
  void dispose() {
    _kvStore.dispose();
    _logger.info('Azure JSON cache disposed');
  }
}
