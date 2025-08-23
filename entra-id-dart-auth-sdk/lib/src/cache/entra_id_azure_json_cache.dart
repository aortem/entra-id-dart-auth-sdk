import 'dart:convert';
import 'package:entra_id_dart_auth_sdk/src/exception/entra_id_azure_json_cache_exception.dart';
import 'package:ds_standard_features/ds_standard_features.dart';

import 'entra_id_cache_kv_store.dart';
import 'entra_id_cache_options.dart';

/// Provides JSON-based caching functionality for the Entra ID SDK
class EntraIdAzureJsonCache {
  final Logger _logger = Logger('EntraIdAzureJsonCache');

  /// The underlying key-value store
  final EntraIdCacheKVStore _kvStore;

  /// Cache version for compatibility
  static const String cacheVersion = '1.0';

  /// Cache schema version
  static const String schemaVersion = '1.0';

  /// Creates a new instance of EntraIdAzureJsonCache
  EntraIdAzureJsonCache({EntraIdCacheOptions? options})
    : _kvStore = EntraIdCacheKVStore(
        options ?? EntraIdCacheOptions(namespace: 'azure_json_cache'),
      ) {
    _logger.info('Initializing Azure JSON cache');
  }

  /// Factory constructor for testing that allows injecting a custom store
  factory EntraIdAzureJsonCache.withStore({
    required EntraIdCacheKVStore store,
    EntraIdCacheOptions? options,
  }) {
    return EntraIdAzureJsonCache._internal(
      store: store,
      options:
          options ?? EntraIdCacheOptions(namespace: 'azure_json_cache'),
    );
  }

  /// Internal constructor used by factory constructors
  EntraIdAzureJsonCache._internal({
    required EntraIdCacheKVStore store,
    required EntraIdCacheOptions options,
  }) : _kvStore = store {
    _logger.info('Initializing Azure JSON cache with custom store');
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
        'entries': await getAllEntries(),
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
  Future<Map<String, dynamic>> getAllEntries() async {
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
