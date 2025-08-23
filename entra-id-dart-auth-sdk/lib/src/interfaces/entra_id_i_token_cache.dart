/// `AortemEntraIdITokenCache` defines the contract for token caching mechanisms
/// in the Aortem EntraId Dart SDK.
///
/// This interface ensures efficient and consistent token storage and retrieval,
/// supporting both in-memory and distributed caching strategies.
abstract class AortemEntraIdITokenCache {
  /// Saves a token in the cache.
  ///
  /// [key] - The identifier for the token.
  /// [tokenData] - The token data to store, typically containing access tokens,
  /// refresh tokens, expiration times, etc.
  Future<void> saveToken(String key, Map<String, dynamic> tokenData);

  /// Retrieves a token from the cache.
  ///
  /// [key] - The identifier for the token.
  /// Returns the token data or `null` if not found.
  Future<Map<String, dynamic>?> retrieveToken(String key);

  /// Removes a token from the cache.
  ///
  /// [key] - The identifier for the token.
  Future<void> removeToken(String key);

  /// Clears all tokens from the cache.
  Future<void> clearTokens();
}
