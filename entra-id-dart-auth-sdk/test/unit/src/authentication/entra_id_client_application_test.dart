import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart'
    show AortemEntraIdClientApplication;
import 'package:entra_id_dart_auth_sdk/src/enum/entra_id_client_application_eum.dart';
import 'package:entra_id_dart_auth_sdk/src/config/entra_id_configuration.dart';

class TestClientApplication extends AortemEntraIdClientApplication {
  TestClientApplication(super.configuration);

  @override
  Future<Map<String, dynamic>> acquireToken() async {
    return {'access_token': 'fake_token'};
  }

  @override
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    return {'access_token': 'refreshed_token'};
  }

  @override
  void validateConfiguration() {
    // Assume config is always valid in this test subclass
  }
}

void main() {
  group('AortemEntraIdClientApplication', () {
    late AortemEntraIdConfiguration config;
    late TestClientApplication app;

    setUp(() {
      config = AortemEntraIdConfiguration.initialize(
        clientId: 'test-client-id',
        authority: 'https://login.microsoftonline.com/common',
        tenantId: 'common',
        redirectUri: 'https://localhost/auth',
      );

      app = TestClientApplication(config);
    });

    tearDown(() async {
      await app.dispose();
      AortemEntraIdConfiguration.reset(); // reset the singleton after each test
    });

    test('initial status is ready after construction', () {
      expect(app.status, ClientApplicationStatus.ready);
    });

    test('returns correct metadata', () {
      final metadata = app.getApplicationMetadata();

      expect(metadata['clientId'], equals('test-client-id'));
      expect(
        metadata['authority'],
        equals('https://login.microsoftonline.com/common'),
      );
      expect(metadata['tenantId'], equals('common'));
      expect(metadata['redirectUri'], equals('https://localhost/auth'));
    });

    test('acquireTokenSilently returns null when cache is empty', () async {
      final result = await app.acquireTokenSilently(['user.read']);
      expect(result, isNull);
    });

    test('clearCache completes without error', () async {
      await app.clearCache(); // Should not throw
    });
  });
}
