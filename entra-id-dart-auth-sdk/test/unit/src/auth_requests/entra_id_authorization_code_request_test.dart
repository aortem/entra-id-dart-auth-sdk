import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';

void main() {
  group('EntraIdAuthorizationCodeRequest', () {
    const tokenEndpoint =
        'https://login.microsoftonline.com/common/oauth2/v2.0/token';

    test('builds correct request body with all fields', () {
      final request = EntraIdAuthorizationCodeRequest(
        tokenEndpoint: tokenEndpoint,
        parameters: AuthorizationCodeRequestParameters(
          authorizationCode: 'abc123',
          redirectUri: 'https://app.com/callback',
          clientId: 'client123',
          clientSecret: 'secret',
          codeVerifier: 'verifier',
          scopes: ['openid', 'email'],
        ),
      );

      final body = request.buildRequestBody();

      expect(body['grant_type'], equals('authorization_code'));
      expect(body['code'], equals('abc123'));
      expect(body['redirect_uri'], equals('https://app.com/callback'));
      expect(body['client_id'], equals('client123'));
      expect(body['client_secret'], equals('secret'));
      expect(body['code_verifier'], equals('verifier'));
      expect(body['scope'], equals('openid email'));
    });

    test('builds correct headers with basic auth and correlation ID', () {
      final request = EntraIdAuthorizationCodeRequest(
        tokenEndpoint: tokenEndpoint,
        parameters: AuthorizationCodeRequestParameters(
          authorizationCode: 'abc123',
          redirectUri: 'https://app.com/callback',
          clientId: 'client123',
          clientSecret: 'secret123',
          correlationId: 'corr-456',
        ),
      );

      final headers = request.getHeaders();
      expect(
        headers['Content-Type'],
        equals('application/x-www-form-urlencoded'),
      );
      expect(headers['Authorization'], startsWith('Basic'));
      expect(headers['client-request-id'], equals('corr-456'));
    });

    test('validateAuthorizationCodeResponse throws on error', () {
      final uri = Uri.parse(
        'https://app.com/callback?error=access_denied&error_description=User denied',
      );

      expect(
        () => EntraIdAuthorizationCodeRequest
            .validateAuthorizationCodeResponse(
          uri,
          'state123',
        ),
        throwsA(
          isA<AuthorizationCodeException>().having(
            (e) => e.code,
            'code',
            'access_denied',
          ),
        ),
      );
    });

    test('validateAuthorizationCodeResponse throws on state mismatch', () {
      final uri = Uri.parse('https://app.com/callback?code=abc123&state=wrong');

      expect(
        () => EntraIdAuthorizationCodeRequest
            .validateAuthorizationCodeResponse(
          uri,
          'expectedState',
        ),
        throwsA(
          isA<AuthorizationCodeException>().having(
            (e) => e.code,
            'code',
            'state_mismatch',
          ),
        ),
      );
    });

    test('validateAuthorizationCodeResponse succeeds', () {
      final uri = Uri.parse(
        'https://app.com/callback?code=abc123&state=expectedState',
      );

      final result = EntraIdAuthorizationCodeRequest
          .validateAuthorizationCodeResponse(
        uri,
        'expectedState',
      );

      expect(result, isTrue);
    });

    test('validateTokenResponse throws if access_token is missing', () {
      final response = {'token_type': 'Bearer'};

      expect(
        () => EntraIdAuthorizationCodeRequest.validateTokenResponse(
          response,
        ),
        throwsA(
          isA<AuthorizationCodeException>().having(
            (e) => e.code,
            'code',
            'missing_access_token',
          ),
        ),
      );
    });

    test('validateTokenResponse succeeds with valid response', () {
      final response = {'access_token': 'abc', 'token_type': 'Bearer'};

      final result =
          EntraIdAuthorizationCodeRequest.validateTokenResponse(response);
      expect(result, isTrue);
    });
  });
}
