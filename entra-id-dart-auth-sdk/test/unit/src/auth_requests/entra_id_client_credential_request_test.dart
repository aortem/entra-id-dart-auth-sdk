import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/auth_requests/entra_id_client_credential_request.dart';

void main() {
  group('EntraIdClientCredentialRequest', () {
    late EntraIdClientCredentialRequest request;
    late http.Client mockClient;

    setUp(() {
      request = EntraIdClientCredentialRequest(
        clientId: 'test-client-id',
        clientSecret: 'test-client-secret',
        authority: 'https://login.microsoftonline.com',
        tenantId: 'test-tenant-id',
        scopes: ['https://graph.microsoft.com/.default'],
      );
    });

    test('throws ArgumentError when credentials or tenantId are empty', () {
      expect(
        () => EntraIdClientCredentialRequest(
          clientId: '',
          clientSecret: '',
          authority: 'https://login.microsoftonline.com',
          tenantId: '',
          scopes: ['scope'],
        ).acquireToken(),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws ArgumentError when scopes are empty', () {
      expect(
        () => EntraIdClientCredentialRequest(
          clientId: 'test-client-id',
          clientSecret: 'test-client-secret',
          authority: 'https://login.microsoftonline.com',
          tenantId: 'test-tenant-id',
          scopes: const [],
        ).acquireToken(),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('returns token on successful secret flow', () async {
      mockClient = MockClient((req) async {
        final body = req.bodyFields;
        expect(body['client_secret'], equals('test-client-secret'));
        expect(body['scope'], equals('https://graph.microsoft.com/.default'));
        return http.Response(
          jsonEncode({'access_token': 'secret-token', 'token_type': 'Bearer'}),
          200,
        );
      });

      request = EntraIdClientCredentialRequest(
        clientId: 'test-client-id',
        clientSecret: 'test-client-secret',
        authority: 'https://login.microsoftonline.com',
        tenantId: 'test-tenant-id',
        scopes: ['https://graph.microsoft.com/.default'],
        client: mockClient,
      );

      final token = await request.acquireToken();

      expect(token['access_token'], equals('secret-token'));
    });

    test('returns token on successful assertion flow', () async {
      mockClient = MockClient((req) async {
        final body = req.bodyFields;
        expect(body['client_assertion'], equals('federated-jwt'));
        expect(
          body['client_assertion_type'],
          equals('urn:ietf:params:oauth:client-assertion-type:jwt-bearer'),
        );
        expect(body['scope'], equals('https://management.azure.com/.default'));
        return http.Response(
          jsonEncode({
            'access_token': 'assertion-token',
            'token_type': 'Bearer',
          }),
          200,
        );
      });

      request = EntraIdClientCredentialRequest.assertion(
        clientId: 'test-client-id',
        clientAssertion: 'federated-jwt',
        authority: 'https://login.microsoftonline.com',
        tenantId: 'test-tenant-id',
        scopes: ['https://management.azure.com/.default'],
        client: mockClient,
      );

      final token = await request.acquireToken();

      expect(token['access_token'], equals('assertion-token'));
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
      request = EntraIdClientCredentialRequest(
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
