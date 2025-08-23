import 'package:logging/logging.dart';

/// Defines the available storage types for caching
enum CacheStorageType {
  /// In-memory storage (volatile)
  memory,

  /// Persistent storage
  persistent,

  /// Distributed cache storage
  distributed,
}

/// Defines the cache eviction policy
enum CacheEvictionPolicy {
  /// Least Recently Used
  lru,

  /// First In First Out
  fifo,

  /// Time-based expiration
  timeBase,
}

/// Configuration options for the Entra ID cache implementation.
class EntraIdCacheOptions {
  final Logger _logger = Logger('EntraIdCacheOptions');

  /// The type of storage to use for caching
  final CacheStorageType storageType;

  /// Maximum number of items to store in cache
  final int maxItems;

  /// Default time-to-live for cached items in seconds
  final int defaultTtlSeconds;

  /// Whether to encrypt cached data
  final bool enableEncryption;

  /// The eviction policy to use when cache is full
  final CacheEvictionPolicy evictionPolicy;

  /// Whether to persist cache across sessions
  final bool persistAcrossSessions;

  /// Size threshold for cache cleanup (percentage, 0-100)
  final int cleanupThreshold;

  /// Namespace for partitioning cache data
  final String namespace;

  /// Creates a new instance of EntraIdCacheOptions
  EntraIdCacheOptions({
    this.storageType = CacheStorageType.memory,
    this.maxItems = 1000,
    this.defaultTtlSeconds = 3600, // 1 hour
    this.enableEncryption = false,
    this.evictionPolicy = CacheEvictionPolicy.lru,
    this.persistAcrossSessions = false,
    this.cleanupThreshold = 90, // 90% full
    this.namespace = 'default',
  }) {
    _validateOptions();
    _logger.info('Initialized cache options with storage type: $storageType');
  }

  /// Creates cache options from JSON configuration
  factory EntraIdCacheOptions.fromJson(Map<String, dynamic> json) {
    return EntraIdCacheOptions(
      storageType: CacheStorageType.values.firstWhere(
        (e) =>
            e.toString() ==
            'CacheStorageType.${json['storageType'] ?? 'memory'}',
      ),
      maxItems: json['maxItems'] as int? ?? 1000,
      defaultTtlSeconds: json['defaultTtlSeconds'] as int? ?? 3600,
      enableEncryption: json['enableEncryption'] as bool? ?? false,
      evictionPolicy: CacheEvictionPolicy.values.firstWhere(
        (e) =>
            e.toString() ==
            'CacheEvictionPolicy.${json['evictionPolicy'] ?? 'lru'}',
      ),
      persistAcrossSessions: json['persistAcrossSessions'] as bool? ?? false,
      cleanupThreshold: json['cleanupThreshold'] as int? ?? 90,
      namespace: json['namespace'] as String? ?? 'default',
    );
  }

  /// Converts cache options to JSON
  Map<String, dynamic> toJson() {
    return {
      'storageType': storageType.toString().split('.').last,
      'maxItems': maxItems,
      'defaultTtlSeconds': defaultTtlSeconds,
      'enableEncryption': enableEncryption,
      'evictionPolicy': evictionPolicy.toString().split('.').last,
      'persistAcrossSessions': persistAcrossSessions,
      'cleanupThreshold': cleanupThreshold,
      'namespace': namespace,
    };
  }

  /// Validates the cache options configuration
  void _validateOptions() {
    if (maxItems <= 0) {
      throw ArgumentError('maxItems must be greater than 0');
    }
    if (defaultTtlSeconds <= 0) {
      throw ArgumentError('defaultTtlSeconds must be greater than 0');
    }
    if (cleanupThreshold <= 0 || cleanupThreshold > 100) {
      throw ArgumentError('cleanupThreshold must be between 1 and 100');
    }
    if (namespace.isEmpty) {
      throw ArgumentError('namespace cannot be empty');
    }

    _logger.fine('Cache options validated successfully');
  }

  /// Creates a copy of the options with updated values
  EntraIdCacheOptions copyWith({
    CacheStorageType? storageType,
    int? maxItems,
    int? defaultTtlSeconds,
    bool? enableEncryption,
    CacheEvictionPolicy? evictionPolicy,
    bool? persistAcrossSessions,
    int? cleanupThreshold,
    String? namespace,
  }) {
    return EntraIdCacheOptions(
      storageType: storageType ?? this.storageType,
      maxItems: maxItems ?? this.maxItems,
      defaultTtlSeconds: defaultTtlSeconds ?? this.defaultTtlSeconds,
      enableEncryption: enableEncryption ?? this.enableEncryption,
      evictionPolicy: evictionPolicy ?? this.evictionPolicy,
      persistAcrossSessions:
          persistAcrossSessions ?? this.persistAcrossSessions,
      cleanupThreshold: cleanupThreshold ?? this.cleanupThreshold,
      namespace: namespace ?? this.namespace,
    );
  }
}
