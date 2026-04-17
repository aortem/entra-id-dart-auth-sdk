import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';

void main() {
  group('entra_id_dart_auth_sdk public exports', () {
    test('exposes the in-memory cache client from the package entrypoint', () async {
      final cache = InMemoryCacheClient(enableSweeper: false);

      await cache.save('access_token', 'token-value');
      expect(await cache.retrieve('access_token'), 'token-value');

      await cache.remove('access_token');
      expect(await cache.retrieve('access_token'), isNull);

      cache.dispose();
    });
  });
}
