import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/utils/entra_id_encoding_utils.dart';

void main() {
  group('EntraIdEncodingUtils', () {
    test('should encode and decode Base64 correctly', () {
      const input = 'Hello, World!';
      final encoded = EntraIdEncodingUtils.encodeBase64(input);
      final decoded = EntraIdEncodingUtils.decodeBase64(encoded);

      expect(decoded, equals(input));
    });

    test('should throw error on empty Base64 input', () {
      expect(
        () => EntraIdEncodingUtils.encodeBase64(''),
        throwsArgumentError,
      );
      expect(
        () => EntraIdEncodingUtils.decodeBase64(''),
        throwsArgumentError,
      );
    });

    test('should encode and decode URL correctly', () {
      const input = 'Hello, World!';
      final encoded = EntraIdEncodingUtils.encodeUrl(input);
      final decoded = EntraIdEncodingUtils.decodeUrl(encoded);

      expect(decoded, equals(input));
    });

    test('should handle empty strings for URL encode/decode', () {
      const input = '';
      final encoded = EntraIdEncodingUtils.encodeUrl(input);
      final decoded = EntraIdEncodingUtils.decodeUrl(encoded);

      expect(encoded, equals(input));
      expect(decoded, equals(input));
    });
  });
}
