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
