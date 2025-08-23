import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/utils/entra_id_encoding_utils.dart';

void main() {
  group('AortemEntraIdEncodingUtils', () {
    test('should encode and decode Base64 correctly', () {
      const input = 'Hello, World!';
      final encoded = AortemEntraIdEncodingUtils.encodeBase64(input);
      final decoded = AortemEntraIdEncodingUtils.decodeBase64(encoded);

      expect(decoded, equals(input));
    });

    test('should throw error on empty Base64 input', () {
      expect(
        () => AortemEntraIdEncodingUtils.encodeBase64(''),
        throwsArgumentError,
      );
      expect(
        () => AortemEntraIdEncodingUtils.decodeBase64(''),
        throwsArgumentError,
      );
    });

    test('should encode and decode URL correctly', () {
      const input = 'Hello, World!';
      final encoded = AortemEntraIdEncodingUtils.encodeUrl(input);
      final decoded = AortemEntraIdEncodingUtils.decodeUrl(encoded);

      expect(decoded, equals(input));
    });

    test('should handle empty strings for URL encode/decode', () {
      const input = '';
      final encoded = AortemEntraIdEncodingUtils.encodeUrl(input);
      final decoded = AortemEntraIdEncodingUtils.decodeUrl(encoded);

      expect(encoded, equals(input));
      expect(decoded, equals(input));
    });
  });
}
