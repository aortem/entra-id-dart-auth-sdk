import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';

void main() {
  group('EntraIdSerializedIdTokenEntity', () {
    test('should throw exception if raw ID token is empty', () {
      expect(
        () => EntraIdSerializedIdTokenEntity.fromClaims({
          'iss': 'https://login.microsoftonline.com/tenant-id/v2.0',
          'sub': 'subject-id',
          'aud': 'client-id',
          'iat': 1618912345,
          'exp': 1618915945,
        }, ''),
        throwsA(isA<IdTokenEntityException>()),
      );
    });

    test('should correctly calculate expiration status', () {
      final claims = {
        'iss': 'https://login.microsoftonline.com/tenant-id/v2.0',
        'sub': 'subject-id',
        'aud': 'client-id',
        'iat': 1618912345,
        'exp': DateTime.now().add(Duration(hours: 1)).millisecondsSinceEpoch ~/
            1000,
      };
      final rawToken = 'raw-id-token';

      final tokenEntity = EntraIdSerializedIdTokenEntity.fromClaims(
        claims,
        rawToken,
      );

      expect(tokenEntity.isExpired, isFalse);
      expect(tokenEntity.timeUntilExpiry, isA<Duration>());
    });

    test('should validate missing required fields', () {
      final claims = {
        'iss': '',
        'sub': 'subject-id',
        'aud': 'client-id',
        'iat': 1618912345,
        'exp': 1618915945,
      };
      final rawToken = 'raw-id-token';

      expect(
        () => EntraIdSerializedIdTokenEntity.fromClaims(claims, rawToken),
        throwsA(isA<IdTokenEntityException>()),
      );
    });

    test('should extract tenant ID from issuer', () {
      final issuer = 'https://login.microsoftonline.com/tenant-id/v2.0';
      final tenantId = EntraIdSerializedIdTokenEntity.extractTenantId(
        issuer,
      );

      expect(tenantId, equals('tenant-id'));
    });
  });
}
