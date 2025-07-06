import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';
import 'package:logging/logging.dart';

void main() {
  Logger.root.level = Level.OFF; // Suppress logs during tests

  group('AortemEntraIdCacheOptions', () {
    test('uses default values when instantiated without parameters', () {
      final options = AortemEntraIdCacheOptions();

      expect(options.storageType, CacheStorageType.memory);
      expect(options.maxItems, 1000);
      expect(options.defaultTtlSeconds, 3600);
      expect(options.enableEncryption, false);
      expect(options.evictionPolicy, CacheEvictionPolicy.lru);
      expect(options.persistAcrossSessions, false);
      expect(options.cleanupThreshold, 90);
      expect(options.namespace, 'default');
    });

    test('correctly parses from JSON', () {
      final json = {
        'storageType': 'persistent',
        'maxItems': 500,
        'defaultTtlSeconds': 1800,
        'enableEncryption': true,
        'evictionPolicy': 'fifo',
        'persistAcrossSessions': true,
        'cleanupThreshold': 75,
        'namespace': 'custom',
      };

      final options = AortemEntraIdCacheOptions.fromJson(json);

      expect(options.storageType, CacheStorageType.persistent);
      expect(options.maxItems, 500);
      expect(options.defaultTtlSeconds, 1800);
      expect(options.enableEncryption, true);
      expect(options.evictionPolicy, CacheEvictionPolicy.fifo);
      expect(options.persistAcrossSessions, true);
      expect(options.cleanupThreshold, 75);
      expect(options.namespace, 'custom');
    });

    test('converts to JSON correctly', () {
      final options = AortemEntraIdCacheOptions(
        storageType: CacheStorageType.distributed,
        maxItems: 999,
        defaultTtlSeconds: 1234,
        enableEncryption: true,
        evictionPolicy: CacheEvictionPolicy.timeBase,
        persistAcrossSessions: true,
        cleanupThreshold: 60,
        namespace: 'ns1',
      );

      final json = options.toJson();

      expect(json['storageType'], 'distributed');
      expect(json['maxItems'], 999);
      expect(json['defaultTtlSeconds'], 1234);
      expect(json['enableEncryption'], true);
      expect(json['evictionPolicy'], 'timeBase');
      expect(json['persistAcrossSessions'], true);
      expect(json['cleanupThreshold'], 60);
      expect(json['namespace'], 'ns1');
    });

    test('throws error for invalid maxItems', () {
      expect(
        () => AortemEntraIdCacheOptions(maxItems: 0),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws error for invalid defaultTtlSeconds', () {
      expect(
        () => AortemEntraIdCacheOptions(defaultTtlSeconds: 0),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws error for invalid cleanupThreshold', () {
      expect(
        () => AortemEntraIdCacheOptions(cleanupThreshold: 0),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => AortemEntraIdCacheOptions(cleanupThreshold: 101),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws error for empty namespace', () {
      expect(
        () => AortemEntraIdCacheOptions(namespace: ''),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('copyWith returns new instance with updated values', () {
      final original = AortemEntraIdCacheOptions();
      final updated = original.copyWith(
        maxItems: 2000,
        evictionPolicy: CacheEvictionPolicy.fifo,
        namespace: 'updated',
      );

      expect(updated.maxItems, 2000);
      expect(updated.evictionPolicy, CacheEvictionPolicy.fifo);
      expect(updated.namespace, 'updated');

      // Original should remain unchanged
      expect(original.maxItems, 1000);
      expect(original.evictionPolicy, CacheEvictionPolicy.lru);
      expect(original.namespace, 'default');
    });
  });
}
