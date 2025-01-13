import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/auth/cache/distributed_cache_plugin.dart';



void main() {
  group('AortemEntraIdDistributedCachePlugin Tests', () {
    late AortemEntraIdDistributedCachePlugin cache;

    setUp(() {
      cache = AortemEntraIdDistributedCachePlugin(
        connectionString: 'test_connection',
        namespace: 'test',
      );
    });

    test('Save and Retrieve Data', () async {
      await cache.save('key1', 'value1');
      final result = await cache.retrieve('key1');
      expect(result, equals('value1'));
    });

    test('Retrieve Expired Data', () async {
      await cache.save('key2', 'value2', ttl: Duration(seconds: 1));
      await Future.delayed(Duration(seconds: 2));
      final result = await cache.retrieve('key2');
      expect(result, isNull);
    });

    test('Remove Data', () async {
      await cache.save('key3', 'value3');
      await cache.remove('key3');
      final result = await cache.retrieve('key3');
      expect(result, isNull);
    });

    test('Clear All Data', () async {
      await cache.save('key4', 'value4');
      await cache.save('key5', 'value5');
      await cache.clear();
      final result1 = await cache.retrieve('key4');
      final result2 = await cache.retrieve('key5');
      expect(result1, isNull);
      expect(result2, isNull);
    });

    test('Namespace Isolation', () async {
      final cache2 = AortemEntraIdDistributedCachePlugin(
        connectionString: 'test_connection',
        namespace: 'other',
      );

      await cache.save('key6', 'value6');
      final result1 = await cache.retrieve('key6');
      final result2 = await cache2.retrieve('key6');
      expect(result1, equals('value6'));
      expect(result2, isNull);
    });
  });
}
