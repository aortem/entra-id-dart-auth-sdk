import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/auth_requests/entra_id_refresh_token_request.dart'; // Adjust the import to your actual file

void main() {
  group('EntraIdRefreshTokenRequest', () {
    test('should throw an error on failed token refresh', () async {
      // Set up with incorrect parameters (e.g., invalid refresh token)
      final refreshToken = 'invalid_refresh_token';
      final clientId = 'your_client_id';
      final clientSecret = 'your_client_secret';
      final tokenEndpoint =
          'https://example.com/token'; // Replace with actual endpoint

      final refreshTokenRequest = EntraIdRefreshTokenRequest(
        refreshToken: refreshToken,
        clientId: clientId,
        clientSecret: clientSecret,
        tokenEndpoint: tokenEndpoint,
      );

      try {
        await refreshTokenRequest.refresh();
        fail('Expected exception not thrown');
      } catch (e) {
        expect(e, isA<Exception>());
        expect(e.toString(), contains('Failed to refresh token'));
      }
    });
  });
}
