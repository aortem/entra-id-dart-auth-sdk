import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';

void main() {
  group('AortemEntraIdSerializedAppMetadataEntity', () {
    late AortemEntraIdSerializedAppMetadataEntity appMetadata;

    setUp(() {
      appMetadata = AortemEntraIdSerializedAppMetadataEntity(
        clientId: 'test-client-id',
        environment: AppEnvironment.development,
        displayName: 'Test App',
        version: '1.0.0',
        authenticationType: AuthenticationType.singleTenant,
        redirectUris: ['https://example.com/callback'],
        authority: 'https://login.microsoftonline.com',
        isConfidentialClient: true,
        allowedIssuers: ['https://issuer1.com'],
        defaultScopes: ['openid', 'profile'],
        capabilities: ['capability1'],
      );
    });

    test('should validate entity correctly', () {
      expect(appMetadata.clientId, 'test-client-id');
      expect(appMetadata.displayName, 'Test App');
      expect(appMetadata.version, '1.0.0');
      expect(appMetadata.authenticationType, AuthenticationType.singleTenant);
      expect(appMetadata.redirectUris, ['https://example.com/callback']);
      expect(appMetadata.isConfidentialClient, true);
      expect(appMetadata.allowedIssuers, ['https://issuer1.com']);
      expect(appMetadata.defaultScopes, ['openid', 'profile']);
      expect(appMetadata.capabilities, ['capability1']);
    });

    test('should throw exception for invalid clientId', () {
      expect(
        () => AortemEntraIdSerializedAppMetadataEntity(
          clientId: '',
          environment: AppEnvironment.production,
          displayName: 'Test App',
          version: '1.0.0',
          authenticationType: AuthenticationType.singleTenant,
          redirectUris: ['https://example.com/callback'],
          authority: 'https://login.microsoftonline.com',
          isConfidentialClient: true,
          allowedIssuers: ['https://issuer1.com'],
          defaultScopes: ['openid', 'profile'],
          capabilities: ['capability1'],
        ),
        throwsA(
          isA<AppMetadataEntityException>().having(
            (e) => e.message,
            'message',
            'Client ID cannot be empty',
          ),
        ),
      );
    });

    test('should get properties correctly', () {
      final property = appMetadata.getProperty<String>(
        'someKey',
        defaultValue: 'defaultValue',
      );
      expect(property, 'defaultValue');
    });

    test('should return true for allowed issuer', () {
      expect(appMetadata.isIssuerAllowed('https://issuer1.com'), isTrue);
      expect(
        appMetadata.isIssuerAllowed('https://invalid-issuer.com'),
        isFalse,
      );
    });

    test('should return correct copy with updated fields', () {
      final updatedAppMetadata = appMetadata.copyWith(
        displayName: 'Updated Test App',
        version: '2.0.0',
      );
      expect(updatedAppMetadata.displayName, 'Updated Test App');
      expect(updatedAppMetadata.version, '2.0.0');
    });
  });
}
