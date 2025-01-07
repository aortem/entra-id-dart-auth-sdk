import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/auth/auth_crypto_provider.dart';

void main() {
  group('AortemEntraIdCryptoProvider', () {
    test('generates HMAC-SHA256 signature correctly', () {
      final key = 'secret-key';
      final data = 'test data';
      final result = AortemEntraIdCryptoProvider.generateHmacSha256(key, data);
      expect(result, isNotEmpty);
    });

    test('encodes and decodes Base64 URL-safe correctly', () {
      final input = 'test input';
      final encoded = AortemEntraIdCryptoProvider.encodeBase64Url(input);
      final decoded = AortemEntraIdCryptoProvider.decodeBase64Url(encoded);
      expect(decoded, input);
    });
  });
}
