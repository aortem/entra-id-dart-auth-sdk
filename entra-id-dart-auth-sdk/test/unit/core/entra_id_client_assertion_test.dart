import 'package:ds_tools_testing/ds_tools_testing.dart';

import 'package:entra_id_dart_auth_sdk/src/core/entra_id_client_assertion.dart';

void main() {
  // Test private key (for testing only)
  const testPrivateKey = '''
-----BEGIN RSA PRIVATE KEY-----
[YOUR PRIVATE KEY]
-----END RSA PRIVATE KEY-----
''';

  const testClientId = 'test-client-id';
  const testTenantId = 'test-tenant-id';
  const testCertThumbprint = 'test-thumbprint';

  group('AortemEntraIdClientAssertion', () {
    test('should initialize with default audience', () {
      final assertion = AortemEntraIdClientAssertion(
        clientId: testClientId,
        tenantId: testTenantId,
        privateKey: testPrivateKey,
      );

      expect(
        assertion.audience,
        'https://login.microsoftonline.com/$testTenantId/oauth2/v2.0/token',
      );
    });

    test('should initialize with custom audience', () {
      const customAudience = 'https://custom.audience';
      final assertion = AortemEntraIdClientAssertion(
        clientId: testClientId,
        tenantId: testTenantId,
        privateKey: testPrivateKey,
        audience: customAudience,
      );

      expect(assertion.audience, customAudience);
    });

    test('should throw when clientId is empty', () {
      expect(
        () => AortemEntraIdClientAssertion(
          clientId: '',
          tenantId: testTenantId,
          privateKey: testPrivateKey,
        ),
        throwsArgumentError,
      );
    });

    test('should throw when tenantId is empty', () {
      expect(
        () => AortemEntraIdClientAssertion(
          clientId: testClientId,
          tenantId: '',
          privateKey: testPrivateKey,
        ),
        throwsArgumentError,
      );
    });

    test('should throw when privateKey is empty', () {
      expect(
        () => AortemEntraIdClientAssertion(
          clientId: testClientId,
          tenantId: testTenantId,
          privateKey: '',
        ),
        throwsArgumentError,
      );
    });

    test('should throw when private key is invalid', () async {
      final assertion = AortemEntraIdClientAssertion(
        clientId: testClientId,
        tenantId: testTenantId,
        privateKey: 'invalid-key',
      );

      expect(() => assertion.generate(), throwsException);
    });

    test('_EntraIdTokenDto should build correct claims', () {
      final now = DateTime.now();
      final tokenDto = EntraIdTokenDto(
        iss: testClientId,
        sub: testClientId,
        aud: 'test-audience',
        exp: now.add(const Duration(minutes: 5)),
        nbf: now,
        iat: now,
        jti: 'test-jti',
        x5t: testCertThumbprint,
      );

      final claims = tokenDto.buildClaims();
      expect(claims['iss'], testClientId);
      expect(claims['sub'], testClientId);
      expect(claims['aud'], 'test-audience');
      expect(claims['jti'], 'test-jti');
      expect(claims['x5t'], testCertThumbprint);
    });

    test('_EntraIdTokenDto should build correct header', () {
      final now = DateTime.now();
      final tokenDto = EntraIdTokenDto(
        iss: testClientId,
        sub: testClientId,
        aud: 'test-audience',
        exp: now.add(const Duration(minutes: 5)),
        nbf: now,
        iat: now,
        jti: 'test-jti',
        x5t: testCertThumbprint,
      );

      final header = tokenDto.buildHeader();
      expect(header['typ'], 'JWT');
      expect(header['alg'], 'RS256');
      expect(header['x5t'], testCertThumbprint);
    });
  });
}
