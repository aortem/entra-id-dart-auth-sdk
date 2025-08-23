import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/core/entra_id_ipublic_client_application.dart';

void main() {
  group('AortemEntraIdPublicClientApp Tests', () {
    late AortemEntraIdPublicClientApp publicClientApp;

    setUp(() {
      publicClientApp = AortemEntraIdPublicClientApp(
        clientId: 'test-client-id',
        authority: 'https://login.microsoftonline.com/test-tenant-id',
        redirectUri: 'https://myapp.com/redirect',
      );
    });

    test('Interactive Token Acquisition', () async {
      final scopes = ['user.read'];

      final tokenResponse = await publicClientApp.acquireTokenInteractively(
        scopes,
      );

      expect(tokenResponse['access_token'], 'mocked_access_token');
      expect(tokenResponse['refresh_token'], 'mocked_refresh_token');
      expect(tokenResponse['id_token'], 'mocked_id_token');
      expect(tokenResponse['expires_in'], 3600);
    });

    test('Device Code Token Acquisition', () async {
      final scopes = ['user.read'];

      final tokenResponse = await publicClientApp.acquireTokenByDeviceCode(
        scopes,
      );

      expect(tokenResponse['access_token'], 'mocked_access_token');
      expect(tokenResponse['refresh_token'], 'mocked_refresh_token');
      expect(tokenResponse['id_token'], 'mocked_id_token');
      expect(tokenResponse['expires_in'], 3600);
    });

    test('Clear Cache', () async {
      await publicClientApp.clearCache();
      // In the actual implementation, you could check the internal cache state or other behaviors.
      // For now, we are only ensuring no errors occur when clearing cache.
      expect(true, true);
    });
  });
}
