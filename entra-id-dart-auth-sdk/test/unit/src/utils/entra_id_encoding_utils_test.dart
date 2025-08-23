import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';

import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'dart:convert';

void main() {
  group('EntraIdEncodingUtils', () {
    test('encodeBase64 should encode a string to Base64 URL-safe format', () {
      final input = 'Hello, World!';
      final encoded = EntraIdEncodingUtils.encodeBase64(input);

      // The expected Base64 URL-safe encoding of the input string
      final expectedEncoded = base64UrlEncode(utf8.encode(input));

      expect(encoded, equals(expectedEncoded));
    });

    test('decodeBase64 should decode a Base64 URL-safe string', () {
      final input = 'Hello, World!';
      final encoded = EntraIdEncodingUtils.encodeBase64(input);
      final decoded = EntraIdEncodingUtils.decodeBase64(encoded);

      expect(decoded, equals(input));
    });

    test('encodeBase64 should throw ArgumentError for empty input', () {
      expect(
        () => EntraIdEncodingUtils.encodeBase64(''),
        throwsArgumentError,
      );
    });

    test('decodeBase64 should throw ArgumentError for empty input', () {
      expect(
        () => EntraIdEncodingUtils.decodeBase64(''),
        throwsArgumentError,
      );
    });

    test('encodeUrl should encode a string for use in URLs', () {
      final input = 'Hello, World!';
      final encoded = EntraIdEncodingUtils.encodeUrl(input);

      // The expected URL-encoded value of the input string
      final expectedEncoded = Uri.encodeComponent(input);

      expect(encoded, equals(expectedEncoded));
    });

    test('decodeUrl should decode a URL-encoded string', () {
      final input = 'Hello, World!';
      final encoded = EntraIdEncodingUtils.encodeUrl(input);
      final decoded = EntraIdEncodingUtils.decodeUrl(encoded);

      expect(decoded, equals(input));
    });
  });
}
