import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'dart:async';

import 'package:entra_id_dart_auth_sdk/src/cache/aortem_entra_id_cache_kv_store.dart'
    show AortemEntraIdCacheKVStore;
import 'package:entra_id_dart_auth_sdk/src/cache/aortem_entra_id_cache_options.dart'
    show AortemEntraIdCacheOptions;
import 'package:entra_id_dart_auth_sdk/src/enum/aortem_entra_id_cache_eviction_policy_enum.dart';
import 'package:entra_id_dart_auth_sdk/src/enum/aortem_entra_id_cache_storage_type_enum.dart';

void main() {
  late AortemEntraIdCacheKVStore cache;
  late AortemEntraIdCacheOptions options;

  setUp(() {
    options = AortemEntraIdCacheOptions(
      storageType: CacheStorageType.memory,
      maxItems: 10,
      namespace: 'testNamespace',
      defaultTtlSeconds: 5,
      evictionPolicy: CacheEvictionPolicy.lru,
      cleanupThreshold: 50,
    );

    cache = AortemEntraIdCacheKVStore(options);
  });

  tearDown(() {
    cache.dispose();
  });

  test('Should cache and retrieve value', () async {
    await cache.set('testKey', 'testValue');
    final cachedValue = await cache.get('testKey');
    expect(cachedValue, 'testValue');
  });

  test('Should expire cache after TTL', () async {
    await cache.set('testKey', 'testValue', ttlSeconds: 1);
    await Future.delayed(Duration(seconds: 2));
    final cachedValue = await cache.get('testKey');
    expect(cachedValue, isNull);
  });

  test('Should evict least recently used (LRU) items', () async {
    for (int i = 0; i < 12; i++) {
      await cache.set('key$i', 'value$i');
    }

    // Only 10 items should be cached, so the first two should be evicted
    expect(await cache.get('key0'), isNull);
    expect(await cache.get('key1'), isNull);
    expect(await cache.get('key2'), 'value2');
  });

  test('Should evict items in FIFO order', () async {
    cache = AortemEntraIdCacheKVStore(
      AortemEntraIdCacheOptions(
        storageType: CacheStorageType.memory,
        maxItems: 10,
        namespace: 'testNamespace',
        defaultTtlSeconds: 5,
        evictionPolicy: CacheEvictionPolicy.fifo,
        cleanupThreshold: 50,
      ),
    );

    for (int i = 0; i < 12; i++) {
      await cache.set('key$i', 'value$i');
    }

    // FIFO eviction, so the first two keys should be evicted
    expect(await cache.get('key0'), isNull);
    expect(await cache.get('key1'), isNull);
    expect(await cache.get('key2'), 'value2');
  });

  test('Should clear cache', () async {
    await cache.set('testKey', 'testValue');
    await cache.clear();
    final cachedValue = await cache.get('testKey');
    expect(cachedValue, isNull);
  });

  test('Should handle cache changes stream', () async {
    final changes = cache.changes;
    final completer = Completer<void>();

    // Listen to changes and complete the test after one change
    changes.listen((key) {
      if (key == 'testKey') {
        completer.complete();
      }
    });

    await cache.set('testKey', 'testValue');
    await completer.future;
  });
}
