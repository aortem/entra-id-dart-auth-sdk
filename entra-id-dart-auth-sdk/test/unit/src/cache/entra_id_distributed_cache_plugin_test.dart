import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';

void main() {
  group('EntraIdDistributedCachePlugin', () {
    late EntraIdDistributedCachePlugin cache;

    setUp(() {
      cache = EntraIdDistributedCachePlugin(
        connectionString: 'mock://connection',
        namespace: 'test',
      );
    });

    test('should save and retrieve a value', () async {
      await cache.save('myKey', {'name': 'Usman'});
      final result = await cache.retrieve('myKey');

      expect(result, isA<Map>());
      expect(result['name'], equals('Usman'));
    });

    test('should return null for expired value', () async {
      await cache.save(
          'tempKey',
          {
            'data': 'expired',
          },
          ttl: Duration(milliseconds: 10));
      await Future.delayed(Duration(milliseconds: 15));

      final result = await cache.retrieve('tempKey');
      expect(result, isNull);
    });

    test('should remove a key from the cache', () async {
      await cache.save('removeMe', 'bye');
      await cache.remove('removeMe');

      final result = await cache.retrieve('removeMe');
      expect(result, isNull);
    });

    test('should clear all entries', () async {
      await cache.save('one', 1);
      await cache.save('two', 2);
      await cache.clear();

      final result1 = await cache.retrieve('one');
      final result2 = await cache.retrieve('two');

      expect(result1, isNull);
      expect(result2, isNull);
    });

    test('should apply namespace to keys', () async {
      await cache.save('user', {'id': '123'});

      // Internally it's saved as "test:user"
      final result = await cache.retrieve('user');
      expect(result['id'], equals('123'));
    });

    test('throws error on empty connection string', () {
      expect(
        () => EntraIdDistributedCachePlugin(connectionString: ''),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
