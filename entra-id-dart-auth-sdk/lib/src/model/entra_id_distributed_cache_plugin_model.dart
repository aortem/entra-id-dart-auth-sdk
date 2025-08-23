/// A class representing a cache entry with its value and expiration time.
class DistributionCacheEntryModel {
  /// The value of the cache entry.
  final String value;

  /// The expiration time of the cache entry.
  final DateTime expiration;

  /// Creates a cache entry with the given [value] and [expiration] time.
  DistributionCacheEntryModel(this.value, this.expiration);
}
