import 'dart:convert';
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/auth_requests/entra_id_username_password_request.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

void main() {
  group('EntraIdUsernamePasswordRequest', () {
    late EntraIdUsernamePasswordRequest request;

    setUp(() {
      request = EntraIdUsernamePasswordRequest(
        clientId: 'test-client-id',
        clientSecret: 'test-client-secret',
        tenantId: 'test-tenant-id',
        authority: 'https://login.microsoftonline.com',
      );
    });

    test('throws ArgumentError when username or password is empty', () {
      expect(
        () => request.acquireToken('', 'password'),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => request.acquireToken('user@example.com', ''),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('returns token map on successful response', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'access_token': 'test_access_token',
            'refresh_token': 'test_refresh_token',
            'id_token': 'test_id_token',
          }),
          200,
        );
      });

      final tokens = await request.acquireToken(
        'user@example.com',
        'password123',
        client: mockClient,
      );
      expect(tokens['access_token'], equals('test_access_token'));
      expect(tokens['refresh_token'], equals('test_refresh_token'));
      expect(tokens['id_token'], equals('test_id_token'));
    });

    test('throws Exception on failure response', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'error': 'invalid_grant',
            'error_description': 'Invalid credentials.',
          }),
          400,
        );
      });

      expect(
        () async => await request.acquireToken(
          'user@example.com',
          'wrongpass',
          client: mockClient,
        ),
        throwsA(
          predicate(
            (e) =>
                e is Exception && e.toString().contains('Invalid credentials.'),
          ),
        ),
      );
    });
  });
}
