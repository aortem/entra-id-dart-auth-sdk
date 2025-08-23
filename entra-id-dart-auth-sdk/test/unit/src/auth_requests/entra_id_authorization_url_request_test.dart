import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';

void main() {
  group('EntraIdAuthorizationUrlRequest', () {
    const authorityUrl =
        'https://login.microsoftonline.com/common/oauth2/v2.0/authorize';

    test('throws if clientId is empty', () {
      expect(
        () => EntraIdAuthorizationUrlRequest(
          authorityUrl: authorityUrl,
          parameters: AuthorizationUrlRequestParameters(
            clientId: '',
            redirectUri: 'https://example.com/callback',
            scopes: ['openid'],
          ),
        ),
        throwsA(
          isA<AuthorizationUrlException>().having(
            (e) => e.code,
            'code',
            'empty_client_id',
          ),
        ),
      );
    });

    test('throws if redirectUri is empty', () {
      expect(
        () => EntraIdAuthorizationUrlRequest(
          authorityUrl: authorityUrl,
          parameters: AuthorizationUrlRequestParameters(
            clientId: 'client123',
            redirectUri: '',
            scopes: ['openid'],
          ),
        ),
        throwsA(
          isA<AuthorizationUrlException>().having(
            (e) => e.code,
            'code',
            'empty_redirect_uri',
          ),
        ),
      );
    });

    test('throws if redirectUri is not absolute', () {
      expect(
        () => EntraIdAuthorizationUrlRequest(
          authorityUrl: authorityUrl,
          parameters: AuthorizationUrlRequestParameters(
            clientId: 'client123',
            redirectUri: '/callback',
            scopes: ['openid'],
          ),
        ),
        throwsA(
          isA<AuthorizationUrlException>().having(
            (e) => e.code,
            'code',
            'invalid_redirect_uri',
          ),
        ),
      );
    });

    test('throws if scopes are empty', () {
      expect(
        () => EntraIdAuthorizationUrlRequest(
          authorityUrl: authorityUrl,
          parameters: AuthorizationUrlRequestParameters(
            clientId: 'client123',
            redirectUri: 'https://example.com/callback',
            scopes: [],
          ),
        ),
        throwsA(
          isA<AuthorizationUrlException>().having(
            (e) => e.code,
            'code',
            'empty_scopes',
          ),
        ),
      );
    });

    test('throws if PKCE code challenge provided without method', () {
      expect(
        () => EntraIdAuthorizationUrlRequest(
          authorityUrl: authorityUrl,
          parameters: AuthorizationUrlRequestParameters(
            clientId: 'client123',
            redirectUri: 'https://example.com/callback',
            scopes: ['openid'],
          ),
          pkceCodeChallenge: 'challenge',
        ),
        throwsA(
          isA<AuthorizationUrlException>().having(
            (e) => e.code,
            'code',
            'invalid_pkce_config',
          ),
        ),
      );
    });

    test('builds URL with minimum required fields', () {
      final request = EntraIdAuthorizationUrlRequest(
        authorityUrl: authorityUrl,
        parameters: AuthorizationUrlRequestParameters(
          clientId: 'client123',
          redirectUri: 'https://example.com/callback',
          scopes: ['openid', 'profile'],
        ),
      );

      final url = request.buildUrl();
      final uri = Uri.parse(url);

      expect(uri.scheme, equals('https'));
      expect(uri.host, equals('login.microsoftonline.com'));
      expect(uri.queryParameters['client_id'], equals('client123'));
      expect(
        uri.queryParameters['redirect_uri'],
        equals('https://example.com/callback'),
      );
      expect(uri.queryParameters['scope'], equals('openid profile'));
      expect(uri.queryParameters['response_type'], equals('code'));
      expect(uri.queryParameters['state'], isNotNull);
    });

    test('builds URL with optional parameters', () {
      final request = EntraIdAuthorizationUrlRequest(
        authorityUrl: authorityUrl,
        parameters: AuthorizationUrlRequestParameters(
          clientId: 'client123',
          redirectUri: 'https://example.com/callback',
          scopes: ['openid'],
          loginHint: 'user@example.com',
          domainHint: 'contoso.com',
          prompt: 'login',
          correlationId: 'abc-123',
        ),
        pkceCodeChallenge: 'challenge123',
        pkceCodeChallengeMethod: 'S256',
      );

      final url = request.buildUrl();
      final uri = Uri.parse(url);

      expect(uri.queryParameters['login_hint'], contains('user%40example.com'));
      expect(uri.queryParameters['domain_hint'], equals('contoso.com'));
      expect(uri.queryParameters['prompt'], equals('login'));
      expect(uri.queryParameters['client-request-id'], equals('abc-123'));
      expect(uri.queryParameters['code_challenge'], equals('challenge123'));
      expect(uri.queryParameters['code_challenge_method'], equals('S256'));
    });

    test('validateRedirectUri returns true for matching URIs', () {
      final result = EntraIdAuthorizationUrlRequest.validateRedirectUri(
        'https://example.com/callback?code=abc',
        'https://example.com/callback',
      );

      expect(result, isTrue);
    });

    test('validateRedirectUri returns false for different paths', () {
      final result = EntraIdAuthorizationUrlRequest.validateRedirectUri(
        'https://example.com/wrong',
        'https://example.com/callback',
      );

      expect(result, isFalse);
    });

    test('validateRedirectUri throws if input is not valid URIs', () {
      expect(
        () => EntraIdAuthorizationUrlRequest.validateRedirectUri(
          '::not-a-uri::',
          'https://example.com/callback',
        ),
        throwsA(
          isA<AuthorizationUrlException>().having(
            (e) => e.code,
            'code',
            'uri_validation_failed',
          ),
        ),
      );
    });
  });
}
