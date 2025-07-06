import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';

import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'dart:convert';

void main() {
  group('AortemEntraIdEncodingUtils', () {
    test('encodeBase64 should encode a string to Base64 URL-safe format', () {
      final input = 'Hello, World!';
      final encoded = AortemEntraIdEncodingUtils.encodeBase64(input);

      // The expected Base64 URL-safe encoding of the input string
      final expectedEncoded = base64UrlEncode(utf8.encode(input));

      expect(encoded, equals(expectedEncoded));
    });

    test('decodeBase64 should decode a Base64 URL-safe string', () {
      final input = 'Hello, World!';
      final encoded = AortemEntraIdEncodingUtils.encodeBase64(input);
      final decoded = AortemEntraIdEncodingUtils.decodeBase64(encoded);

      expect(decoded, equals(input));
    });

    test('encodeBase64 should throw ArgumentError for empty input', () {
      expect(
        () => AortemEntraIdEncodingUtils.encodeBase64(''),
        throwsArgumentError,
      );
    });

    test('decodeBase64 should throw ArgumentError for empty input', () {
      expect(
        () => AortemEntraIdEncodingUtils.decodeBase64(''),
        throwsArgumentError,
      );
    });

    test('encodeUrl should encode a string for use in URLs', () {
      final input = 'Hello, World!';
      final encoded = AortemEntraIdEncodingUtils.encodeUrl(input);

      // The expected URL-encoded value of the input string
      final expectedEncoded = Uri.encodeComponent(input);

      expect(encoded, equals(expectedEncoded));
    });

    test('decodeUrl should decode a URL-encoded string', () {
      final input = 'Hello, World!';
      final encoded = AortemEntraIdEncodingUtils.encodeUrl(input);
      final decoded = AortemEntraIdEncodingUtils.decodeUrl(encoded);

      expect(decoded, equals(input));
    });
  });
}
