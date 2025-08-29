import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/auth_requests/entra_id_client_credential_request.dart';

import 'package:http/testing.dart' as http_testing;

void main() {
  group('EntraIdClientCredentialRequest', () {
    test('acquireToken returns token map on 200 OK', () async {
      final mock = http_testing.MockClient((http.Request req) async {
        expect(req.method, equals('POST'));
        expect(
          req.url.toString(),
          equals('https://login.microsoftonline.com/tenant/oauth2/v2.0/token'),
        );

        // Optionally validate form body fields present
        expect(req.bodyFields['grant_type'], equals('client_credentials'));
        expect(req.bodyFields['client_id'], equals('abc'));
        expect(req.bodyFields['client_secret'], equals('shh'));
        expect(req.bodyFields['scope'], equals('scope1 scope2'));

        final token = {
          'access_token': 'fake-token',
          'token_type': 'Bearer',
          'expires_in': 3600,
        };
        return http.Response(
          jsonEncode(token),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final req = EntraIdClientCredentialRequest(
        clientId: 'abc',
        clientSecret: 'shh',
        authority: 'https://login.microsoftonline.com',
        tenantId: 'tenant',
        scopes: const ['scope1', 'scope2'],
        client: mock,
      );

      final res = await req.acquireToken();
      expect(res['access_token'], equals('fake-token'));
      expect(res['token_type'], equals('Bearer'));
      expect(res['expires_in'], equals(3600));
    });

    test('acquireToken throws on non-2xx (error payload)', () async {
      final mock = http_testing.MockClient((http.Request req) async {
        final err = {
          'error': 'invalid_client',
          'error_description': 'The client secret is incorrect.',
        };
        return http.Response(
          jsonEncode(err),
          400,
          headers: {'content-type': 'application/json'},
        );
      });

      final req = EntraIdClientCredentialRequest(
        clientId: 'abc',
        clientSecret: 'wrong',
        authority: 'https://login.microsoftonline.com',
        tenantId: 'tenant',
        scopes: const ['scope1'],
        client: mock,
      );

      expect(
        () => req.acquireToken(),
        throwsA(
          predicate(
            (e) =>
                e is Exception &&
                e.toString().contains('The client secret is incorrect.'),
          ),
        ),
      );
    });

    test('throws ArgumentError when required fields are empty', () async {
      final req = EntraIdClientCredentialRequest(
        clientId: '',
        clientSecret: 'x',
        authority: 'https://login.microsoftonline.com',
        tenantId: '',
        scopes: const ['scope1'],
        client: http_testing.MockClient((_) async => http.Response('', 500)),
      );

      expect(() => req.acquireToken(), throwsA(isA<ArgumentError>()));
    });
  });
}
