/// An interface for implementing custom cache clients in the
/// Aortem EntraId Dart SDK.
///
/// This interface defines the contract for caching operations related
/// to token storage and metadata management, ensuring flexibility in
/// implementing different caching mechanisms (e.g., in-memory, database, or
/// distributed caching).
/// EntraIdICacheClient: contract for SDK caching.
/// Methods must align with parent contract: save/retrieve/remove/clear.
abstract class EntraIdICacheClient {
  /// Save a value for [key]. Optional [ttl] sets expiry.
  Future<void> save(String key, String value, {Duration? ttl});

  /// Retrieve cached value for [key], or null if missing/expired.
  Future<String?> retrieve(String key);

  /// Remove a specific [key] from cache.
  Future<void> remove(String key);

  /// Clear all cached entries.
  Future<void> clear();
}
