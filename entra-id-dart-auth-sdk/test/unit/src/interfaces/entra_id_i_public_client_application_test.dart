import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';

void main() {
  group('EntraIdPublicClientApp', () {
    late EntraIdPublicClientApp app;

    setUp(() {
      app = EntraIdPublicClientApp(
        clientId: 'test-client-id',
        authority: 'https://login.microsoftonline.com',
        redirectUri: 'http://localhost',
      );
    });

    test('acquireTokenInteractively should return token data', () async {
      final scopes = ['user.read'];
      final token = await app.acquireTokenInteractively(scopes);

      expect(token, contains('access_token'));
      expect(token, contains('refresh_token'));
      expect(token, contains('id_token'));
      expect(token, contains('expires_in'));
      expect(token['access_token'], isNotEmpty);
    });

    test('acquireTokenByDeviceCode should return token data', () async {
      final scopes = ['user.read'];
      final token = await app.acquireTokenByDeviceCode(scopes);

      expect(token, contains('access_token'));
      expect(token, contains('refresh_token'));
      expect(token, contains('id_token'));
      expect(token, contains('expires_in'));
      expect(token['access_token'], isNotEmpty);
    });

    test('clearCache should complete without errors', () async {
      try {
        await app.clearCache();
      } catch (e) {
        fail('clearCache threw an exception: $e');
      }
    });
  });
}
