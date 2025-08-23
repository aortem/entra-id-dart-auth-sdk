import 'dart:async';
import 'package:logging/logging.dart';
import 'entra_id_auth_cache_options.dart';

/// Represents a cached item with metadata
class CacheEntry {
  /// Creates a new instance of CacheEntry
  final dynamic value;

  /// The expiration time of the cache entry
  final DateTime expiresAt;

  /// The last time the cache entry was accessed
  final DateTime lastAccessed;

  /// Creates a new instance of CacheEntry
  CacheEntry({
    required this.value,
    required this.expiresAt,
    required this.lastAccessed,
  });

  /// Checks if the cache entry has expired
  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

/// A key-value store implementation for caching in the Entra ID SDK.
class EntraIdCacheKVStore {
  final Logger _logger = Logger('EntraIdCacheKVStore');

  /// Cache options
  final EntraIdCacheOptions options;

  /// Internal storage map
  final Map<String, CacheEntry> _cache = {};

  /// Stream controller for cache events
  final _changeController = StreamController<String>.broadcast();

  /// Creates a new instance of EntraIdCacheKVStore
  EntraIdCacheKVStore(this.options) {
    _logger.info(
      'Initializing cache store with ${options.storageType} storage type',
    );
    _startMaintenanceTimer();
  }

  /// Stream of cache change events
  Stream<String> get changes => _changeController.stream;

  /// Sets a value in the cache
  ///
  /// [key] The key to store the value under
  /// [value] The value to store
  /// [ttlSeconds] Optional TTL override for this specific entry
  Future<void> set(String key, dynamic value, {int? ttlSeconds}) async {
    _ensureCapacity();

    final expiresAt = DateTime.now().add(
      Duration(seconds: ttlSeconds ?? options.defaultTtlSeconds),
    );

    _cache[_namespaceKey(key)] = CacheEntry(
      value: value,
      expiresAt: expiresAt,
      lastAccessed: DateTime.now(),
    );

    _logger.fine('Cached value for key: $key');
    _changeController.add(key);
  }

  /// Gets a value from the cache
  ///
  /// Returns null if the key doesn't exist or the value has expired
  Future<dynamic> get(String key) async {
    final namespacedKey = _namespaceKey(key);
    final entry = _cache[namespacedKey];

    if (entry == null) {
      _logger.fine('Cache miss for key: $key');
      return null;
    }

    if (entry.isExpired) {
      _logger.fine('Cache entry expired for key: $key');
      _cache.remove(namespacedKey);
      return null;
    }

    // Update last accessed time for LRU
    _cache[namespacedKey] = CacheEntry(
      value: entry.value,
      expiresAt: entry.expiresAt,
      lastAccessed: DateTime.now(),
    );

    _logger.fine('Cache hit for key: $key');
    return entry.value;
  }

  /// Removes a value from the cache
  Future<void> remove(String key) async {
    _cache.remove(_namespaceKey(key));
    _logger.fine('Removed cache entry for key: $key');
    _changeController.add(key);
  }

  /// Clears all values from the cache
  Future<void> clear() async {
    _cache.clear();
    _logger.info('Cache cleared');
    _changeController.add('clear');
  }

  /// Checks if a key exists in the cache and is not expired
  Future<bool> containsKey(String key) async {
    final entry = _cache[_namespaceKey(key)];
    return entry != null && !entry.isExpired;
  }

  /// Gets the number of items in the cache
  int get length => _cache.length;

  /// Ensures the cache doesn't exceed maximum capacity
  void _ensureCapacity() {
    if (_cache.length >= options.maxItems) {
      _evictEntries();
    }
  }

  /// Evicts entries based on the configured eviction policy
  void _evictEntries() {
    if (_cache.isEmpty) return;

    switch (options.evictionPolicy) {
      case CacheEvictionPolicy.lru:
        _evictLRU();
        break;
      case CacheEvictionPolicy.fifo:
        _evictFIFO();
        break;
      case CacheEvictionPolicy.timeBase:
        _evictExpired();
        break;
    }
  }

  /// Evicts the least recently used entries
  void _evictLRU() {
    final sorted = _cache.entries.toList()
      ..sort((a, b) => a.value.lastAccessed.compareTo(b.value.lastAccessed));

    // Remove 10% of the oldest entries
    final removeCount = (_cache.length * 0.1).ceil();
    for (var i = 0; i < removeCount && i < sorted.length; i++) {
      _cache.remove(sorted[i].key);
    }
  }

  /// Evicts entries in FIFO order
  void _evictFIFO() {
    // Remove 10% of the entries
    final removeCount = (_cache.length * 0.1).ceil();
    final keys = _cache.keys.take(removeCount);
    keys.forEach(_cache.remove);
  }

  /// Evicts expired entries
  void _evictExpired() {
    _cache.removeWhere((_, entry) => entry.isExpired);
  }

  /// Prepends the namespace to the key
  String _namespaceKey(String key) => '${options.namespace}:$key';

  /// Starts the maintenance timer for regular cleanup
  void _startMaintenanceTimer() {
    Timer.periodic(Duration(minutes: 5), (_) {
      _performMaintenance();
    });
  }

  /// Performs maintenance tasks like cleaning up expired entries
  void _performMaintenance() {
    _evictExpired();

    if (_cache.length >= (options.maxItems * options.cleanupThreshold / 100)) {
      _evictEntries();
    }

    _logger.fine('Cache maintenance completed. Current size: ${_cache.length}');
  }

  /// Disposes of the cache store and its resources
  void dispose() {
    _changeController.close();
    _logger.info('Cache store disposed');
  }
}
