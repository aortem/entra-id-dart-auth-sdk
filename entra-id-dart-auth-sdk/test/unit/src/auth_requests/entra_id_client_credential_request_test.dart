import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/auth_requests/entra_id_client_credential_request.dart';
import 'package:http/testing.dart';

void main() {
  group('AortemEntraIdClientCredentialRequest', () {
    late AortemEntraIdClientCredentialRequest request;
    late http.Client mockClient;

    setUp(() {
      request = AortemEntraIdClientCredentialRequest(
        clientId: 'test-client-id',
        clientSecret: 'test-client-secret',
        authority: 'https://login.microsoftonline.com',
        tenantId: 'test-tenant-id',
        scopes: ['https://graph.microsoft.com/.default'],
      );
    });

    test('throws ArgumentError when credentials or tenantId are empty', () {
      expect(
        () => AortemEntraIdClientCredentialRequest(
          clientId: '',
          clientSecret: '',
          authority: 'https://login.microsoftonline.com',
          tenantId: '',
          scopes: ['scope'],
        ).acquireToken(),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws exception with error message on failure', () async {
      mockClient = MockClient((req) async {
        return http.Response(
          jsonEncode({
            'error': 'invalid_client',
            'error_description': 'Client authentication failed.',
          }),
          400,
        );
      });

      // Use the mock client
      request = AortemEntraIdClientCredentialRequest(
        clientId: 'test-client-id',
        clientSecret: 'test-client-secret',
        authority: 'https://login.microsoftonline.com',
        tenantId: 'test-tenant-id',
        scopes: ['https://graph.microsoft.com/.default'],
        client: mockClient, // Inject the mock client
      );

      expect(
        () async => await request.acquireToken(),
        throwsA(
          predicate(
            (e) =>
                e is Exception &&
                e.toString().contains(
                  'Error acquiring token: Client authentication failed.',
                ),
          ),
        ),
      );
    });
  });
}
