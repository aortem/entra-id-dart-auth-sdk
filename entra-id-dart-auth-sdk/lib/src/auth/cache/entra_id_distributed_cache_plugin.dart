import 'dart:convert';
import 'package:logging/logging.dart';

/// EntraIdDistributedCachePlugin: Supports distributed token caching.
///
/// This class provides functionality to manage distributed caching for tokens
/// and metadata in the Aortem EntraId SDK. It simulates a distributed cache
/// using an in-memory storage and can be extended to support real-world
/// distributed systems like Redis.
///
/// Example:
/// ```dart
/// final cache = EntraIdDistributedCachePlugin(
///   connectionString: 'example_connection_string',
///   namespace: 'auth',
/// );
///
/// await cache.save('token', {'access_token': 'abc123'}, ttl: Duration(minutes: 5));
/// final token = await cache.retrieve('token');
/// print('Retrieved token: $token');
/// ```
class EntraIdDistributedCachePlugin {
  /// Connection string to connect to the distributed cache.
  final String connectionString;

  /// Namespace to isolate keys in the cache.
  final String _namespace;

  /// Logger for debugging cache operations.
  final _logger = Logger('EntraIdDistributedCachePlugin');

  /// In-memory simulation of a distributed cache.
  late Map<String, DistrubutionCacheEntry> _cacheMock;

  /// Constructor for initializing the cache plugin.
  ///
  /// The [connectionString] is mandatory and must not be empty.
  /// An optional [namespace] can be provided to segregate cache keys.
  EntraIdDistributedCachePlugin({
    required this.connectionString,
    String namespace = '',
  }) : _namespace = namespace.isNotEmpty ? '$namespace:' : '' {
    if (connectionString.isEmpty) {
      throw ArgumentError('Connection string cannot be empty.');
    }

    _cacheMock = {}; // Replace with actual distributed cache logic.
  }

  /// Save data to the distributed cache with an optional time-to-live (TTL).
  ///
  /// The [key] identifies the cached data, and [value] is the data to be stored.
  /// The optional [ttl] specifies the validity duration of the cached entry.
  Future<void> save(String key, dynamic value, {Duration? ttl}) async {
    final expiration = ttl != null ? DateTime.now().add(ttl) : DateTime(9999);
    _cacheMock['$_namespace$key'] = DistrubutionCacheEntry(
      jsonEncode(value),
      expiration,
    );
    _logger.info('Saved key: $_namespace$key with TTL: $ttl');
  }

  /// Retrieve data from the distributed cache.
  ///
  /// The [key] identifies the cached data. If the key is not found or the entry
  /// has expired, this method returns `null`.
  Future<dynamic> retrieve(String key) async {
    final entry = _cacheMock['$_namespace$key'];
    if (entry == null || entry.expiration.isBefore(DateTime.now())) {
      _cacheMock.remove('$_namespace$key'); // Clean up expired entry.
      _logger.info('Cache miss for key: $_namespace$key');
      return null;
    }
    _logger.info('Cache hit for key: $_namespace$key');
    return jsonDecode(entry.value);
  }

  /// Remove an entry from the distributed cache.
  ///
  /// The [key] identifies the entry to be removed.
  Future<void> remove(String key) async {
    _cacheMock.remove('$_namespace$key');
    _logger.info('Removed key: $_namespace$key');
  }

  /// Clear the entire distributed cache.
  Future<void> clear() async {
    _cacheMock.clear();
    _logger.info('Cleared all cache entries.');
  }
}

/// A class representing a cache entry with its value and expiration time.
class DistrubutionCacheEntry {
  /// The value of the cache entry.
  final String value;

  /// The expiration time of the cache entry.
  final DateTime expiration;

  /// Creates a cache entry with the given [value] and [expiration] time.
  DistrubutionCacheEntry(this.value, this.expiration);
}
