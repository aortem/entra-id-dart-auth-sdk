import 'package:ds_tools_testing/ds_tools_testing.dart';

import 'package:entra_id_dart_auth_sdk/src/core/aortem_entra_id_client_assertion.dart';

void main() {
  // Test private key (for testing only)
  const testPrivateKey = '''
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAy1YRVTIxeB6YU88f6OhsHtZUB0ll/9Wi72lgzohPRHkHHb3J
y193Y41wmtYNhxY9GHQ6QjciXP4LtQUqf+WOf70O9x3xDJLPuHx8Zw25Cz+S4r0t
KnSNnh7gBi0QJ5PYv+gIJxgV/QlQFVencXbpaohkU/LInxVMoo8bkta160OOBSW2
5JBSxF8tY49SDfxcLyh91BD+E/8cOplGAXaYyPbsVUn76Y83JZ+jIzZWXNvap9Xq
SbfqXzjVQuOQ/XdrQOS5u1c+F6OzWgdSa7OBj479yzfuh7z+W+NpZAKjFihvh1ME
nnLd61Htu/1D5/L/zkv+lZ5sjAps0aWRkwZ+CQIDAQABAoIBADI8BjY1G1GgxWNX
NXv2B9gqfUH7mS52WjWppBgCRwsUl3R6keMjp7w5kks+fMMV9GwZMtdvBZdR0BSd
vR0x2l2mmI7mn8nKb3UVlCplkoS75Q8NS55Eg0RAPnpoIaiVdyQaMAFwiuYjqdxL
9nsqtIn0Pk0bGwNqYK98iYRidTk026KsYrZGSb/Ya0DlBJYOMQnDslPmebGgbZro
9opVaceLpYaklQa2Q7cF4M2MRcKAK//wb2t2aPQ+LmtZGfnyW0z/ZZB8loaMClCU
k0vLcRPt8OuzGUO+9it8GT9JjW59HTEhYtkBs9dLr3yWeSOiUraienNGAEwRSALe
sYyFiTECgYEA5ITum3Vw339C5KByBek3wmFSWhxokgtJfUe33hgqFeSB4Cs8rJri
B8zc00q4WSoXWH7zz/lJm4DCUHl+U7ycppQYovVfuoegXC784uihW4XwPWc4r3yH
agpNancSkLVkWznDGafpQxq7YbK21hYdVRoaw9Y36fO1/9zw+xIHJGUCgYEA48nd
HoXL0v062IdoJ/dgm+RO97iYCDtVzRCYvv65Toa0n5mA+W6IFcJzKFWjE8/eiqoV
/Vl+UXu8QG0g6elVgdHEyoR5ZzX5jjaNl4ZAyzY9Oubh3pj8N6xq1deAOjjBPQNZ
z+NRchG43GJ7m0Z7lajmaMc0PLVNe7SUY7sF/tUCgYBEoriX8LoqJqsMyDP3Goko
1NpLPmUaGFHGUxgimNdrI+ruTY43uX1SInHg9HxSK5Y/ekH4oUM+dXnnedY7iFb0
oV6U82YBPGMpzOMftAdi2ePCTZJ1As4ZR2bhJ0poNFMkI0E6H3isMwc83NSVkKbW
vLR1RY4dspljdBTdFBkZEQKBgGzzNlHNCOpHuIesbEMBbTHjB2ow3nbBeo50q7pe
t185ytazYx7qoShXMyFNpIxrVjPYml/tGB/9INNn3uBCfGV1YbzDlBWrmUtOCHc6
/W606KBtogcIAUrXqtnRE0HFt5dpLOHkBiabF2JBsIFaOu4gNORUs0V+KitK+dah
s4JpAoGAd+YLoCWwe+2P7EqhiGi0eUcqFyTvOsxxRCTsBWWkf2P0SorjjYcmlw2G
iLxH64ZqxyJNdI1wYkGYVxoTdB5jFRP3X7QPDv5v0iMs6iLX0e3XHkUQZSpij2rq
UmUIGqLdAx3FNG0CO/HLr+kc8vkeDTkBKYtDm4r9Ik9IquF4MUc=
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

      expect(assertion.audience,
          'https://login.microsoftonline.com/$testTenantId/oauth2/v2.0/token');
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

    test('should generate valid JWT with certificate thumbprint', () async {
      final assertion = AortemEntraIdClientAssertion(
        clientId: testClientId,
        tenantId: testTenantId,
        privateKey: testPrivateKey,
        certificateThumbprint: testCertThumbprint,
      );

      final jwt = await assertion.generate();
      expect(jwt, isNotEmpty);
      expect(jwt.split('.').length, 3); // Valid JWT has 3 parts
    });

    test('should generate valid JWT without certificate thumbprint', () async {
      final assertion = AortemEntraIdClientAssertion(
        clientId: testClientId,
        tenantId: testTenantId,
        privateKey: testPrivateKey,
      );

      final jwt = await assertion.generate();
      expect(jwt, isNotEmpty);
      expect(jwt.split('.').length, 3); // Valid JWT has 3 parts
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
