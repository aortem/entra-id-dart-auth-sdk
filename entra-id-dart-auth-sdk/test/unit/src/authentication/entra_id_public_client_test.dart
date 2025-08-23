import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/authentication/entra_id_public_client.dart';
import 'package:entra_id_dart_auth_sdk/src/config/entra_id_configuration.dart';

void main() {
  group('AortemEntraIdPublicClientApplication', () {
    late AortemEntraIdConfiguration config;

    setUp(() {
      // Reset singleton between tests to avoid shared state
      AortemEntraIdConfiguration.reset();

      config = AortemEntraIdConfiguration.initialize(
        clientId: 'test-client-id',
        tenantId: 'test-tenant-id',
        authority: 'https://login.microsoftonline.com/common',
        redirectUri: 'com.example.app://auth',
      );
    });

    test('should initialize with default parameters', () {
      final app = AortemEntraIdPublicClientApplication(
        configuration: config,
        redirectUri: config.redirectUri,
      );

      expect(app.browserType.toString(), equals('BrowserType.systemDefault'));
      expect(app.enableMemoryCache, isTrue);
      expect(app.usePkce, isTrue);
    });

    test('getApplicationMetadata returns correct metadata', () {
      final app = AortemEntraIdPublicClientApplication(
        configuration: config,
        redirectUri: config.redirectUri,
      );

      final metadata = app.getApplicationMetadata();

      expect(metadata['browserType'], equals('BrowserType.systemDefault'));
      expect(metadata['enableMemoryCache'], isTrue);
      expect(metadata['usePkce'], isTrue);
    });

    test('signOut completes successfully', () async {
      final app = AortemEntraIdPublicClientApplication(
        configuration: config,
        redirectUri: config.redirectUri,
      );

      await app.signOut(); // Should not throw
    });
  });
}
