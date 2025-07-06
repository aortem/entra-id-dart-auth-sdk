import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/config/aortem_entra_id_proxy_status.dart';

import 'package:ds_standard_features/ds_standard_features.dart' as http;

// Mock class for http.Client
class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('AortemEntraIdProxyStatus', () {
    late AortemEntraIdProxyStatus proxyStatus;

    setUp(() {
      proxyStatus = AortemEntraIdProxyStatus(
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
      // This test checks for exception handling (mocked failure)
      final badProxyStatus = AortemEntraIdProxyStatus(
        proxyUrl: 'invalid.proxy',
        port: 9999,
        username: 'fake',
        password: 'fake',
      );

      expect(() => badProxyStatus.validateProxy(), throwsA(isA<Exception>()));
    });

    test('validateProxy fails when no username/password is provided', () async {
      final badProxyStatus = AortemEntraIdProxyStatus(
        proxyUrl: 'localhost',
        port: 8080,
      );

      expect(() => badProxyStatus.validateProxy(), throwsA(isA<Exception>()));
    });

    test('applyProxySettings does not throw', () async {
      await proxyStatus.applyProxySettings(); // Just to ensure it completes
    });
  });
}
