import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/cache/entra_id_in_memory_cache_client.dart';

void main() {
  group('InMemoryCacheClient', () {
    test('save/retrieve/remove/clear', () async {
      final cache = InMemoryCacheClient();

      await cache.save('k', 'v');
      expect(await cache.retrieve('k'), 'v');

      await cache.remove('k');
      expect(await cache.retrieve('k'), isNull);

      await cache.save('a', '1');
      await cache.save('b', '2');
      await cache.clear();
      expect(await cache.retrieve('a'), isNull);
      expect(await cache.retrieve('b'), isNull);

      cache.dispose();
    });

    test('ttl expiry', () async {
      final cache = InMemoryCacheClient(enableSweeper: false);
      await cache.save('temp', 'x', ttl: const Duration(milliseconds: 50));
      expect(await cache.retrieve('temp'), 'x');
      await Future.delayed(const Duration(milliseconds: 70));
      expect(await cache.retrieve('temp'), isNull);
      cache.dispose();
    });
  });
}
