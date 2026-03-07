import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/config/entra_id_proxy_status.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

void main() {
  group('EntraIdProxyStatus', () {
    late EntraIdProxyStatus proxyStatus;

    setUp(() {
      proxyStatus = EntraIdProxyStatus(
        proxyUrl: 'localhost',
        port: 8080,
        username: 'user',
        password: 'pass',
      );
    });

    test('initializes with required parameters', () {
      expect(proxyStatus.proxyUrl, equals('localhost'));
      expect(proxyStatus.port, equals(8080));
      expect(proxyStatus.username, equals('user'));
      expect(proxyStatus.password, equals('pass'));
    });

    test('validateProxy throws exception on failure', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      final badProxyStatus = EntraIdProxyStatus(
        proxyUrl: 'invalid.proxy',
        port: 9999,
        username: 'fake',
        password: 'fake',
        client: mockClient,
      );

      expect(() => badProxyStatus.validateProxy(), throwsA(isA<Exception>()));
    });

    test('validateProxy fails when no username/password is provided', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      final badProxyStatus = EntraIdProxyStatus(
        proxyUrl: 'localhost',
        port: 8080,
        client: mockClient,
      );

      expect(() => badProxyStatus.validateProxy(), throwsA(isA<Exception>()));
    });

    test('applyProxySettings does not throw', () async {
      await proxyStatus.applyProxySettings(); // Just to ensure it completes
    });
  });
}
