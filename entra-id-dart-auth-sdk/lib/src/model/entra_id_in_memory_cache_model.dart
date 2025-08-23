/// Configuration for the in-memory token cache
class InMemoryCacheConfig {
  /// Maximum number of tokens to store
  final int maxTokens;

  /// How often to run cleanup (remove expired tokens)
  final Duration cleanupInterval;

  /// Whether to enable automatic cleanup
  final bool enableAutomaticCleanup;

  /// Creates a new instance of InMemoryCacheConfig
  InMemoryCacheConfig({
    this.maxTokens = 1000,
    this.cleanupInterval = const Duration(minutes: 5),
    this.enableAutomaticCleanup = true,
  }) {
    if (maxTokens <= 0) {
      throw ArgumentError('maxTokens must be greater than 0');
    }
  }
}
