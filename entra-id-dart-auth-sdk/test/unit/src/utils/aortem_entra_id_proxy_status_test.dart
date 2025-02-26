import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/utils/aortem_entra_id_proxy_status.dart';


import 'package:ds_standard_features/ds_standard_features.dart' as http;

import 'package:http/testing.dart';

void main() {
  group('AortemEntraIdProxyStatus', () {
    test('should successfully validate a reachable proxy', () async {
      final mockClient = MockClient((request) async {
        if (request.url.host == 'proxy.example.com' && request.url.port == 8080) {
          return http.Response('OK', 200);
        }
        return http.Response('Not Found', 404);
      });

      final proxyStatus = AortemEntraIdProxyStatus(
        proxyUrl: 'proxy.example.com',
        port: 8080,
      );

      final isValid = await proxyStatus.validateProxy();
      expect(isValid, true);
    });

    test('should throw an exception for unreachable proxy', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      final proxyStatus = AortemEntraIdProxyStatus(
        proxyUrl: 'proxy.example.com',
        port: 8080,
      );

      expect(
        () async => await proxyStatus.validateProxy(),
        throwsA(isA<Exception>()),
      );
    });

    test('should throw an exception for invalid proxy URL', () async {
      final proxyStatus = AortemEntraIdProxyStatus(
        proxyUrl: 'invalid_proxy',
        port: 8080,
      );

      expect(
        () async => await proxyStatus.validateProxy(),
        throwsA(isA<FormatException>()),
      );
    });

    test('should handle proxy authentication', () async {
      final mockClient = MockClient((request) async {
        if (request.url.host == 'proxy.example.com' &&
            request.url.port == 8080 &&
            request.headers['Proxy-Authorization'] == 'Basic dXNlcjpwYXNzd29yZA==') {
          return http.Response('OK', 200);
        }
        return http.Response('Unauthorized', 401);
      });

      final proxyStatus = AortemEntraIdProxyStatus(
        proxyUrl: 'proxy.example.com',
        port: 8080,
        username: 'user',
        password: 'password',
      );

      final isValid = await proxyStatus.validateProxy();
      expect(isValid, true);
    });
  });
}
