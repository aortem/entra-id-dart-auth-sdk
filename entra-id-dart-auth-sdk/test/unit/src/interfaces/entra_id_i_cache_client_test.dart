import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';

/// A simple in-memory implementation of EntraIdICacheClient for testing.
class InMemoryCacheClient implements EntraIdICacheClient {
  final Map<String, String> _cache = {};

  @override
  Future<void> set(String key, String value, {Duration? ttl}) async {
    _cache[key] = value;
  }

  @override
  Future<String?> get(String key) async {
    return _cache[key];
  }

  @override
  Future<void> delete(String key) async {
    _cache.remove(key);
  }

  @override
  Future<void> clear() async {
    _cache.clear();
  }
}

void main() {
  group('InMemoryCacheClient', () {
    late EntraIdICacheClient cacheClient;

    setUp(() {
      cacheClient = InMemoryCacheClient();
    });

    test('set should store the cache data correctly', () async {
      await cacheClient.set('key1', 'value1');
      final value = await cacheClient.get('key1');
      expect(value, equals('value1'));
    });

    test('get should return null for non-existing key', () async {
      final value = await cacheClient.get('non_existing_key');
      expect(value, isNull);
    });

    test('delete should remove the item from the cache', () async {
      await cacheClient.set('key1', 'value1');
      await cacheClient.delete('key1');
      final value = await cacheClient.get('key1');
      expect(value, isNull);
    });

    test('clear should remove all items from the cache', () async {
      await cacheClient.set('key1', 'value1');
      await cacheClient.set('key2', 'value2');
      await cacheClient.clear();

      final value1 = await cacheClient.get('key1');
      final value2 = await cacheClient.get('key2');
      expect(value1, isNull);
      expect(value2, isNull);
    });

    test('set with ttl should store the value correctly', () async {
      await cacheClient.set('key1', 'value1', ttl: Duration(seconds: 5));
      final value = await cacheClient.get('key1');
      expect(value, equals('value1'));
    });
  });
}
