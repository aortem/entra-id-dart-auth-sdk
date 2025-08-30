import 'dart:async';
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';

void main() {
  group('EntraIdInteractiveRequest', () {
    test('should initialize with valid parameters', () {
      final params = InteractiveRequestParameters(
        clientId: 'test-client-id',
        redirectUri: 'https://example.com/callback',
        scopes: ['openid', 'profile'],
        timeout: Duration(minutes: 2),
      );

      final request = EntraIdInteractiveRequest(
        authorityUrl:
            'https://login.microsoftonline.com/common/oauth2/v2.0/authorize',
        parameters: params,
      );

      expect(request.status, InteractiveRequestStatus.notStarted);
      expect(request.pkceCodeVerifier, isNotNull);
      expect(request.state, isNotEmpty);
      expect(request.nonce, isNotEmpty);
    });

    test('should throw exception for empty client ID', () {
      final params = InteractiveRequestParameters(
        clientId: '',
        redirectUri: 'https://example.com/callback',
        scopes: ['openid'],
      );

      expect(
        () => EntraIdInteractiveRequest(
          authorityUrl:
              'https://login.microsoftonline.com/common/oauth2/v2.0/authorize',
          parameters: params,
        ),
        throwsA(isA<InteractiveRequestException>()),
      );
    });

    test('should start authentication flow and return auth URL', () async {
      final params = InteractiveRequestParameters(
        clientId: 'test-client-id',
        redirectUri: 'https://example.com/callback',
        scopes: ['openid'],
        timeout: Duration(minutes: 1),
      );

      final request = EntraIdInteractiveRequest(
        authorityUrl:
            'https://login.microsoftonline.com/common/oauth2/v2.0/authorize',
        parameters: params,
      );

      final authUrl = await request.startAuthentication();
      expect(authUrl, contains('https://login.microsoftonline.com'));
      expect(authUrl, contains('client_id=test-client-id'));
    });

    test('should handle authentication response successfully', () {
      final params = InteractiveRequestParameters(
        clientId: 'test-client-id',
        redirectUri: 'https://example.com/callback',
        scopes: ['openid'],
      );

      final request = EntraIdInteractiveRequest(
        authorityUrl:
            'https://login.microsoftonline.com/common/oauth2/v2.0/authorize',
        parameters: params,
      );

      final responseUri = Uri.parse(
        'https://example.com/callback?code=auth_code&state=${request.state}',
      );

      request.handleAuthenticationResponse(responseUri);
      expect(request.status, InteractiveRequestStatus.completed);
    });

    test('should throw exception for invalid response state', () {
      final params = InteractiveRequestParameters(
        clientId: 'test-client-id',
        redirectUri: 'https://example.com/callback',
        scopes: ['openid'],
      );

      final request = EntraIdInteractiveRequest(
        authorityUrl:
            'https://login.microsoftonline.com/common/oauth2/v2.0/authorize',
        parameters: params,
      );

      final responseUri = Uri.parse(
        'https://example.com/callback?code=auth_code&state=invalid_state',
      );

      expect(
        () => request.handleAuthenticationResponse(responseUri),
        throwsA(isA<InteractiveRequestException>()),
      );
    });

    test('should timeout after specified duration', () async {
      final params = InteractiveRequestParameters(
        clientId: 'test-client-id',
        redirectUri: 'https://example.com/callback',
        scopes: ['openid'],
        timeout: Duration(seconds: 1), // Timeout after 1 second
      );

      final request = EntraIdInteractiveRequest(
        authorityUrl:
            'https://login.microsoftonline.com/common/oauth2/v2.0/authorize',
        parameters: params,
      );

      final timeoutFuture = Future.delayed(Duration(seconds: 2), () {
        // This will trigger the timeout
      });

      timeoutFuture.then((_) {
        expect(request.status, InteractiveRequestStatus.timeout);
      });
    });

    test('should cancel authentication flow', () {
      final params = InteractiveRequestParameters(
        clientId: 'test-client-id',
        redirectUri: 'https://example.com/callback',
        scopes: ['openid'],
      );

      final request = EntraIdInteractiveRequest(
        authorityUrl:
            'https://login.microsoftonline.com/common/oauth2/v2.0/authorize',
        parameters: params,
      );

      request.cancel();
      expect(request.status, InteractiveRequestStatus.cancelled);
    });
  });
}
