import 'dart:convert';

import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/cache/entra_id_azure_json_cache.dart';
import 'package:entra_id_dart_auth_sdk/src/cache/entra_id_cache_kv_store.dart';
import 'package:entra_id_dart_auth_sdk/src/cache/entra_id_cache_options.dart';

class MockKVStore extends Mock implements EntraIdCacheKVStore {}

void main() {
  late EntraIdAzureJsonCache cache;
  late MockKVStore mockKvStore;

  setUp(() {
    mockKvStore = MockKVStore();
    // Create cache with custom constructor that accepts KV store
    cache = EntraIdAzureJsonCache.withStore(
      store: mockKvStore,
      options: EntraIdCacheOptions(namespace: 'azure_json_cache'),
    );
  });

  group('retrieve', () {
    test('should get data from the cache', () async {
      const testKey = 'testKey';
      final testData = {'key': 'value'};
      final jsonData = jsonEncode({
        'version': '1.0',
        'schema': '1.0',
        'timestamp': DateTime.now().toIso8601String(),
        'data': testData,
      });

      when(() => mockKvStore.get(testKey)).thenAnswer((_) async => jsonData);

      final result = await cache.retrieve(testKey, (json) => json);

      expect(result, equals(testData));
      verify(() => mockKvStore.get(testKey)).called(1);
    });

    test('should return null for non-existent key', () async {
      const testKey = 'nonExistentKey';

      when(() => mockKvStore.get(testKey)).thenAnswer((_) async => null);

      final result = await cache.retrieve(testKey, (json) => json);

      expect(result, isNull);
      verify(() => mockKvStore.get(testKey)).called(1);
    });
  });

  group('remove', () {
    test('should delete data from the cache', () async {
      const testKey = 'testKey';

      when(() => mockKvStore.remove(testKey)).thenAnswer((_) async {});

      await cache.remove(testKey);

      verify(() => mockKvStore.remove(testKey)).called(1);
    });
  });

  group('clear', () {
    test('should clear all data from the cache', () async {
      when(() => mockKvStore.clear()).thenAnswer((_) async {});

      await cache.clear();

      verify(() => mockKvStore.clear()).called(1);
    });
  });

  group('exportCache', () {
    test('should export the entire cache as JSON', () async {
      // Since getAllEntries() is implemented internally, we'll test the output format
      final result = await cache.exportCache();
      final decoded = jsonDecode(result) as Map<String, dynamic>;

      expect(decoded['version'], '1.0');
      expect(decoded['schema'], '1.0');
      expect(decoded['timestamp'], isNotNull);
      expect(decoded['entries'], isA<Map<String, dynamic>>());
    });
  });

  group('importCache', () {
    test('should import cache from a JSON string', () async {
      final importJson = jsonEncode({
        'version': '1.0',
        'schema': '1.0',
        'timestamp': DateTime.now().toIso8601String(),
        'entries': {'key1': 'value1'},
      });

      when(() => mockKvStore.clear()).thenAnswer((_) async {});
      when(() => mockKvStore.set('key1', any())).thenAnswer((_) async {});

      await cache.importCache(importJson);

      verify(() => mockKvStore.clear()).called(1);
      verify(() => mockKvStore.set('key1', any())).called(1);
    });
  });
}
