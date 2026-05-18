import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:entra_id_dart_auth_sdk/src/authentication/entra_id_confidential_client.dart';
import 'package:entra_id_dart_auth_sdk/src/enum/entra_id_confidential_client_enum.dart';

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
      expect(app.scopes, equals(['https://graph.microsoft.com/.default']));
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
      final appWithInvalidAuthority = EntraIdConfidentialClientApplication(
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

    test('uses custom scopes for secret flow', () async {
      final mockClient = MockClient((req) async {
        final body = req.bodyFields;
        expect(body['scope'], equals('https://management.azure.com/.default'));
        return http.Response(
          '{"access_token":"secret-token","token_type":"Bearer"}',
          200,
        );
      });

      app = EntraIdConfidentialClientApplication(
        clientId: 'test-client-id',
        authority: 'https://login.microsoftonline.com/test',
        credential: 'test-secret',
        credentialType: CredentialType.secret,
        scopes: ['https://management.azure.com/.default'],
        httpClient: mockClient,
      );

      final token = await app.acquireToken();

      expect(token['access_token'], equals('secret-token'));
    });

    test('sends client assertion type for assertion flow', () async {
      final mockClient = MockClient((req) async {
        final body = req.bodyFields;
        expect(body['client_assertion'], equals('federated-jwt'));
        expect(
          body['client_assertion_type'],
          equals('urn:ietf:params:oauth:client-assertion-type:jwt-bearer'),
        );
        return http.Response(
          '{"access_token":"assertion-token","token_type":"Bearer"}',
          200,
        );
      });

      app = EntraIdConfidentialClientApplication(
        clientId: 'test-client-id',
        authority: 'https://login.microsoftonline.com/test',
        credential: 'federated-jwt',
        credentialType: CredentialType.assertion,
        scopes: ['https://management.azure.com/.default'],
        httpClient: mockClient,
      );

      final token = await app.acquireToken();

      expect(token['access_token'], equals('assertion-token'));
    });

    test('throws unsupported error for certificate flow', () {
      app = EntraIdConfidentialClientApplication(
        clientId: 'test-client-id',
        authority: 'https://login.microsoftonline.com/test',
        credential: 'certificate-material',
        credentialType: CredentialType.certificate,
      );

      expect(app.acquireToken(), throwsA(isA<UnsupportedError>()));
    });
  });
}
