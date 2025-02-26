import 'dart:convert';

import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_standard_features/ds_standard_features.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/core/aortem_entraid_client_credential_request.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('AortemEntraIdClientCredentialRequest', () {
    late MockHttpClient mockHttpClient;
    late AortemEntraIdClientCredentialRequest request;

    setUp(() {
      mockHttpClient = MockHttpClient();
      request = AortemEntraIdClientCredentialRequest(
        clientId: 'test-client-id',
        clientSecret: 'test-client-secret',
        authority: 'https://login.microsoftonline.com',
        tenantId: 'test-tenant-id',
        scopes: ['https://graph.microsoft.com/.default'],
      );
    });

    test('Acquire token - successful response', () async {
      // Mock a successful HTTP response
      final mockResponse = http.Response(
        jsonEncode({
          'token_type': 'Bearer',
          'expires_in': 3600,
          'access_token': 'mock-access-token',
        }),
        200,
      );

      when(() => mockHttpClient.post(
            any(),
            body: any(named: 'body'),
          )).thenAnswer((_) async => mockResponse);

      // Override the default HTTP client
    Client = mockHttpClient;

      // Act
      final tokenResponse = await request.acquireToken();

      // Assert
      expect(tokenResponse, isA<Map<String, dynamic>>());
      expect(tokenResponse['access_token'], equals('mock-access-token'));
    });

    test('Acquire token - error response', () async {
      // Mock an error HTTP response
      final mockResponse = http.Response(
        jsonEncode({
          'error': 'invalid_client',
          'error_description': 'Client authentication failed.',
        }),
        401,
      );

      when(() => mockHttpClient.post(
            any(),
            body: any(named: 'body'),
          )).thenAnswer((_) async => mockResponse);

      // Override the default HTTP client
      http.Client = mockHttpClient;

      // Act & Assert
      expect(
        () async => await request.acquireToken(),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Error acquiring token: Client authentication failed.'),
        )),
      );
    });

    test('Validate configuration - invalid authority', () {
      // Arrange
      final invalidRequest = AortemEntraIdClientCredentialRequest(
        clientId: 'test-client-id',
        clientSecret: 'test-client-secret',
        authority: 'http://insecure-authority.com', // Invalid (not HTTPS)
        tenantId: 'test-tenant-id',
        scopes: ['https://graph.microsoft.com/.default'],
      );

      // Act & Assert
      expect(
        () => invalidRequest.acquireToken(),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
