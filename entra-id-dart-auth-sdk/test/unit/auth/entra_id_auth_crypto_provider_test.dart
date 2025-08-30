import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/auth/entra_id_auth_crypto_provider.dart';

void main() {
  group('EntraIdCryptoProvider', () {
    test('generates HMAC-SHA256 signature correctly', () {
      final key = 'secret-key';
      final data = 'test data';
      final result = EntraIdCryptoProvider.generateHmacSha256(key, data);
      expect(result, isNotEmpty);
    });

    test('encodes and decodes Base64 URL-safe correctly', () {
      final input = 'test input';
      final encoded = EntraIdCryptoProvider.encodeBase64Url(input);
      final decoded = EntraIdCryptoProvider.decodeBase64Url(encoded);
      expect(decoded, input);
    });
  });
}
