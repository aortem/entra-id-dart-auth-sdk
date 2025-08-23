import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/authentication/entra_id_auth_options.dart'
    show AortemEntraIdAuthOptions;

void main() {
  group('AortemEntraIdAuthOptions', () {
    test('should create an instance with valid parameters', () {
      final options = AortemEntraIdAuthOptions(
        clientId: 'test-client-id',
        authority: 'https://login.microsoftonline.com/common',
        redirectUri: 'https://localhost/auth/callback',
        scopes: ['user.read'],
      );

      expect(options.clientId, equals('test-client-id'));
      expect(
        options.authority,
        equals('https://login.microsoftonline.com/common'),
      );
      expect(options.redirectUri, equals('https://localhost/auth/callback'));
      expect(options.scopes, equals(['user.read']));
    });

    test('should throw error when clientId is empty', () {
      expect(
        () => AortemEntraIdAuthOptions(
          clientId: '',
          authority: 'https://login.microsoftonline.com/common',
          redirectUri: 'https://localhost/auth/callback',
        ),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('clientId is required'),
          ),
        ),
      );
    });

    test('should throw error on invalid authority URL', () {
      expect(
        () => AortemEntraIdAuthOptions(
          clientId: 'test-client-id',
          authority: 'invalid-url',
          redirectUri: 'https://localhost/auth/callback',
        ),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('Invalid authority URL'),
          ),
        ),
      );
    });

    test('should throw error on invalid redirectUri', () {
      expect(
        () => AortemEntraIdAuthOptions(
          clientId: 'test-client-id',
          authority: 'https://login.microsoftonline.com/common',
          redirectUri: 'not-a-valid-uri',
        ),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('Invalid redirect URI'),
          ),
        ),
      );
    });
  });
}
