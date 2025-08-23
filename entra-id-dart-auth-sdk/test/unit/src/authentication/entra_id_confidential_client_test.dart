import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/authentication/entra_id_confidential_client.dart';
import 'package:entra_id_dart_auth_sdk/src/enum/entra_id_confidential_client_enum.dart';

class MockConfidentialClientApp
    extends EntraIdConfidentialClientApplication {
  MockConfidentialClientApp()
    : super(
        clientId: 'mock-client',
        authority: 'https://login.microsoftonline.com/mock',
        credential: 'mock-secret',
      );

  Future<Map<String, dynamic>> acquireTokenWithSecret() async {
    return {'access_token': 'mock_token'};
  }
}

void main() {
  group('EntraIdConfidentialClientApplication', () {
    late EntraIdConfidentialClientApplication app;

    setUp(() {
      app = EntraIdConfidentialClientApplication(
        clientId: 'test-client-id',
        authority: 'https://login.microsoftonline.com/test',
        credential: 'test-secret',
        credentialType: CredentialType.secret,
      );
    });

    test('constructs correctly with default values', () {
      expect(app.clientId, equals('test-client-id'));
      expect(app.authority, equals('https://login.microsoftonline.com/test'));
      expect(app.credential, equals('test-secret'));
      expect(app.credentialType, equals(CredentialType.secret));
      expect(app.allowLegacyProtocols, isFalse);
    });

    test('throws if credential is empty during validation', () {
      final appWithEmptyCredential = EntraIdConfidentialClientApplication(
        clientId: 'test-client-id',
        authority: 'https://login.microsoftonline.com/test',
        credential: '',
      );

      expect(
        () => appWithEmptyCredential.validateConfiguration(),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('Credential cannot be empty'),
          ),
        ),
      );
    });

    test('throws if authority is not HTTPS', () {
      final appWithInvalidAuthority =
          EntraIdConfidentialClientApplication(
            clientId: 'test-client-id',
            authority: 'http://login.microsoftonline.com/test',
            credential: 'test-secret',
          );

      expect(
        () => appWithInvalidAuthority.validateConfiguration(),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('Authority must use HTTPS'),
          ),
        ),
      );
    });
  });
}
