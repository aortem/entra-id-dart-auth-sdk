import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart';

import 'dart:convert';

import 'package:entra_id_dart_auth_sdk/src/core/aortem_entraid_client_credential_request.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class UriFake extends Fake implements Uri {}

void main() {
  setUpAll(() {
    registerFallbackValue(UriFake()); // Register fallback for Uri
  });

  group('AortemEntraIdClientCredentialRequest Tests', () {
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
        // Injecting MockHttpClient
      );
    });

    test('should throw exception on failure response', () async {
      final mockResponse = MockResponse();
      when(() => mockResponse.statusCode).thenReturn(400);
      when(() => mockResponse.body).thenReturn(
        jsonEncode({
          'error': 'invalid_request',
          'error_description': 'Invalid client credentials.',
        }),
      );
      when(
        () => mockHttpClient.post(any(), body: any(named: 'body')),
      ).thenAnswer((_) async => mockResponse);

      expect(() async => await request.acquireToken(), throwsException);
    });
  });
}
