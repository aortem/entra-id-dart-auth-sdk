import 'dart:developer';

import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:entra_id_dart_auth_sdk/src/auth/aortem_entra_id_username_password_request.dart';

import 'dart:convert';

import 'package:http/testing.dart';

void main() {
  group('AortemEntraIdUsernamePasswordRequest', () {
    test('should successfully acquire tokens', () async {
      final mockClient = MockClient((request) async {
        if (request.url.path.contains('/oauth2/v2.0/token')) {
          return http.Response(
            jsonEncode({
              'access_token': 'test_access_token',
              'refresh_token': 'test_refresh_token',
              'id_token': 'test_id_token',
            }),
            200,
          );
        }
        return http.Response('Not Found', 404);
      });

      final authRequest = AortemEntraIdUsernamePasswordRequest(
        clientId: 'test-client-id',
        clientSecret: 'test-client-secret',
        tenantId: 'test-tenant-id',
        authority: 'https://login.microsoftonline.com',
      );

      log('MockClient initialized: $mockClient');
      final tokens = await authRequest.acquireToken(
        'user@example.com',
        'password',
      );
      expect(tokens['access_token'], 'test_access_token');
      expect(tokens['refresh_token'], 'test_refresh_token');
      expect(tokens['id_token'], 'test_id_token');
    });

    test('should throw ArgumentError for empty username or password', () {
      final authRequest = AortemEntraIdUsernamePasswordRequest(
        clientId: 'test-client-id',
        clientSecret: 'test-client-secret',
        tenantId: 'test-tenant-id',
        authority: 'https://login.microsoftonline.com',
      );

      expect(
        () => authRequest.acquireToken('', 'password'),
        throwsA(isA<ArgumentError>()),
      );

      expect(
        () => authRequest.acquireToken('user@example.com', ''),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should throw Exception for invalid credentials', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'error': 'invalid_grant',
            'error_description': 'Invalid username or password.',
          }),
          400,
        );
      });

      final authRequest = AortemEntraIdUsernamePasswordRequest(
        clientId: 'test-client-id',
        clientSecret: 'test-client-secret',
        tenantId: 'test-tenant-id',
        authority: 'https://login.microsoftonline.com',
      );

      log('MockClient initialized: $mockClient');
      expect(
        () async => await authRequest.acquireToken(
          'user@example.com',
          'wrong-password',
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
