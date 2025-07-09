import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';
// Replace with your actual package name

void main() {
  group('AortemEntraIdConfiguration', () {
    setUp(() {
      // Reset the configuration before each test
      AortemEntraIdConfiguration.reset();
    });

    test('should initialize with correct properties', () {
      // Arrange
      const clientId = 'clientId123';
      const tenantId = 'tenantId123';
      const authority = 'https://login.microsoftonline.com';
      const redirectUri = 'https://myapp.com/redirect';

      // Act
      final config = AortemEntraIdConfiguration.initialize(
        clientId: clientId,
        tenantId: tenantId,
        authority: authority,
        redirectUri: redirectUri,
      );

      // Assert
      expect(config.clientId, equals(clientId));
      expect(config.tenantId, equals(tenantId));
      expect(config.authority, equals(authority));
      expect(config.redirectUri, equals(redirectUri));
      expect(config.enableLogging, isFalse); // Default value
      expect(config.cacheExpirationInSeconds, equals(3600)); // Default value
    });

    test(
      'should use default values when optional parameters are not provided',
      () {
        // Arrange
        const clientId = 'clientId123';
        const tenantId = 'tenantId123';
        const authority = 'https://login.microsoftonline.com';
        const redirectUri = 'https://myapp.com/redirect';

        // Act
        final config = AortemEntraIdConfiguration.initialize(
          clientId: clientId,
          tenantId: tenantId,
          authority: authority,
          redirectUri: redirectUri,
        );

        // Assert
        expect(config.enableLogging, isFalse); // Default value
        expect(config.cacheExpirationInSeconds, equals(3600)); // Default value
      },
    );

    test('should initialize only once (singleton behavior)', () {
      // Arrange
      const clientId = 'clientId123';
      const tenantId = 'tenantId123';
      const authority = 'https://login.microsoftonline.com';
      const redirectUri = 'https://myapp.com/redirect';

      // Act
      final firstInstance = AortemEntraIdConfiguration.initialize(
        clientId: clientId,
        tenantId: tenantId,
        authority: authority,
        redirectUri: redirectUri,
      );
      final secondInstance = AortemEntraIdConfiguration.initialize(
        clientId: clientId,
        tenantId: tenantId,
        authority: authority,
        redirectUri: redirectUri,
      );

      // Assert
      expect(
        firstInstance,
        same(secondInstance),
      ); // Ensure both instances are the same
    });

    test('should reset the configuration', () {
      // Arrange
      const clientId = 'clientId123';
      const tenantId = 'tenantId123';
      const authority = 'https://login.microsoftonline.com';
      const redirectUri = 'https://myapp.com/redirect';

      // Act
      final config = AortemEntraIdConfiguration.initialize(
        clientId: clientId,
        tenantId: tenantId,
        authority: authority,
        redirectUri: redirectUri,
      );

      // Assert that the configuration is initialized
      expect(config.clientId, equals(clientId));

      // Reset the configuration
      AortemEntraIdConfiguration.reset();

      // Act again to reinitialize
      final newConfig = AortemEntraIdConfiguration.initialize(
        clientId: 'newClientId',
        tenantId: 'newTenantId',
        authority: 'https://newauthority.com',
        redirectUri: 'https://newapp.com/redirect',
      );

      // Assert that the configuration has been reset and reinitialized
      expect(newConfig.clientId, equals('newClientId'));
      expect(newConfig.tenantId, equals('newTenantId'));
    });
  });
}
