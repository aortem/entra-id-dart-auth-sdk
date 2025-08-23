/// Defines the cache eviction policy
enum CacheEvictionPolicy {
  /// Least Recently Used
  lru,

  /// First In First Out
  fifo,

  /// Time-based expiration
  timeBase,
}
