
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/auth/auth_entra_id_confidential_client_application.dart';

void main() {
  group('AortemEntraIdConfidentialClientApplication', () {
    test('Should throw error if clientId is missing', () {
      expect(
        () => AortemEntraIdConfidentialClientApplication(
          clientId: '',
          authority: 'https://valid-authority.com',
          clientSecret: 'some-secret',
        ),
        throwsA(predicate((e) => e is ArgumentError && e.message == 'Client ID is required.')),
      );
    });

    test('Should throw error if authority is missing', () {
      expect(
        () => AortemEntraIdConfidentialClientApplication(
          clientId: 'some-client-id',
          authority: '',
          clientSecret: 'some-secret',
        ),
        throwsA(predicate((e) => e is ArgumentError && e.message == 'Authority is required.')),
      );
    });

    test('Should throw error if authority is not HTTPS', () {
      expect(
        () => AortemEntraIdConfidentialClientApplication(
          clientId: 'some-client-id',
          authority: 'http://invalid-authority.com',
          clientSecret: 'some-secret',
        ),
        throwsA(predicate((e) => e is ArgumentError && e.message == 'Authority must be a valid HTTPS URL.')),
      );
    });

    test('Should throw error if neither clientSecret nor clientAssertion is provided', () {
      expect(
        () => AortemEntraIdConfidentialClientApplication(
          clientId: 'some-client-id',
          authority: 'https://valid-authority.com',
        ),
        throwsA(predicate((e) => e is ArgumentError && e.message == 'Either clientSecret or clientAssertion must be provided.')),
      );
    });

    test('Should initialize successfully with valid parameters', () {
      final app = AortemEntraIdConfidentialClientApplication(
        clientId: 'valid-client-id',
        authority: 'https://valid-authority.com',
        clientSecret: 'valid-secret',
      );

      expect(app.clientId, 'valid-client-id');
      expect(app.authority, 'https://valid-authority.com');
      expect(app.clientSecret, 'valid-secret');
      expect(app.clientAssertion, isNull);
    });

    test('Should acquire token successfully (mock test)', () async {
      final app = AortemEntraIdConfidentialClientApplication(
        clientId: 'valid-client-id',
        authority: 'https://valid-authority.com',
        clientSecret: 'valid-secret',
      );

      final token = await app.acquireToken();
      expect(token, 'mock-access-token');
    });

    test('Should throw error on invalid configuration during token acquisition', () async {
      final app = AortemEntraIdConfidentialClientApplication(
        clientId: '',
        authority: 'https://valid-authority.com',
        clientSecret: 'valid-secret',
      );

      expect(
        () async => await app.acquireToken(),
        throwsA(predicate((e) => e is ArgumentError && e.message == 'Client ID is required.')),
      );
    });
  });
}
