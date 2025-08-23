/// An interface for implementing custom cache clients in the
/// Aortem EntraId Dart SDK.
///
/// This interface defines the contract for caching operations related
/// to token storage and metadata management, ensuring flexibility in
/// implementing different caching mechanisms (e.g., in-memory, database, or
/// distributed caching).
abstract class AortemEntraIdICacheClient {
  /// Stores a value in the cache with the given [key] and [value].
  /// The optional [ttl] (time-to-live) parameter allows setting an expiration time in seconds.
  Future<void> set(String key, String value, {Duration? ttl});

  /// Retrieves a value from the cache by its [key].
  /// Returns `null` if the key does not exist.
  Future<String?> get(String key);

  /// Removes an item from the cache by its [key].
  Future<void> delete(String key);

  /// Clears all cached data.
  Future<void> clear();
}
