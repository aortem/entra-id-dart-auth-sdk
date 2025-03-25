import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/auth/auth_entra_id_confidential_client_application.dart';
import 'package:entra_id_dart_auth_sdk/src/auth/auth_entra_id_configuration.dart';

void main() {
  group('AortemEntraIdConfidentialClientApplication Tests', () {
    late AortemEntraIdConfiguration configuration;

    setUp(() {
      configuration = AortemEntraIdConfiguration(
        clientId: 'test-client-id',
        tenantId: 'test-tenant-id',
        authority: 'https://login.microsoftonline.com/test-tenant',
      );
    });

    test(
      'should initialize successfully with valid configuration and secret',
      () {
        expect(
          () => AortemEntraIdConfidentialClientApplication(
            configuration: configuration,
            credential: 'test-secret',
            credentialType: CredentialType.secret,
          ),
          returnsNormally,
        );
      },
    );

    test('should throw an error if credential is empty', () {
      expect(
        () => AortemEntraIdConfidentialClientApplication(
          configuration: configuration,
          credential: '',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should throw an error if authority is invalid', () {
      final invalidConfiguration = AortemEntraIdConfiguration(
        clientId: 'test-client-id',
        tenantId: 'test-tenant-id',
        authority: 'http://invalid-url.com',
      );

      expect(
        () => AortemEntraIdConfidentialClientApplication(
          configuration: invalidConfiguration,
          credential: 'test-secret',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should return application metadata correctly', () {
      final app = AortemEntraIdConfidentialClientApplication(
        configuration: configuration,
        credential: 'test-secret',
      );

      final metadata = app.getApplicationMetadata();
      expect(metadata['clientId'], equals('test-client-id'));
      expect(
        metadata['authority'],
        equals('https://login.microsoftonline.com/test-tenant'),
      );
      expect(
        metadata['credentialType'],
        equals(CredentialType.secret.toString()),
      );
    });
  });
}
