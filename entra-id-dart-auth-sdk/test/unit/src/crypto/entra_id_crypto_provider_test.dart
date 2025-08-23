import 'package:ds_standard_features/ds_standard_features.dart'
    show Hmac, sha256;
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';

import 'dart:convert';

void main() {
  group('EntraIdCryptoProvider', () {
    test('should generate a valid SHA256 hash', () {
      final input = 'test string';
      final hash = EntraIdCryptoProvider.generateSha256Hash(input);
      final expectedHash = sha256.convert(utf8.encode(input)).toString();

      expect(hash, equals(expectedHash));
    });

    test(
      'should generate a valid PKCE code challenge from the code verifier',
      () {
        final codeVerifier = 'dGVzdCBzdHJpbmc=';
        final codeChallenge =
            EntraIdCryptoProvider.generatePkceCodeChallenge(codeVerifier);
        final expectedChallenge = base64Url.encode(
          sha256.convert(utf8.encode(codeVerifier)).bytes,
        );

        expect(codeChallenge, equals(expectedChallenge));
      },
    );

    test('should generate a valid HMAC-SHA256 signature', () {
      final key = 'secret-key';
      final data = 'data-to-sign';
      final signature = EntraIdCryptoProvider.generateHmacSha256(
        key,
        data,
      );

      final hmac = Hmac(sha256, utf8.encode(key));
      final expectedSignature = hmac.convert(utf8.encode(data)).toString();

      expect(signature, equals(expectedSignature));
    });

    test('should encode a string to Base64 URL-safe', () {
      final input = 'test string';
      final encoded = EntraIdCryptoProvider.encodeBase64Url(input);
      final expectedEncoded = base64Url.encode(utf8.encode(input));

      expect(encoded, equals(expectedEncoded));
    });

    test('should decode a Base64 URL-safe string', () {
      final input = 'dGVzdCBzdHJpbmc='; // base64 URL-safe encoded 'test string'
      final decoded = EntraIdCryptoProvider.decodeBase64Url(input);

      expect(decoded, equals('test string'));
    });

    test(
      'should throw FormatException on Base64 URL-safe decoding failure',
      () {
        expect(
          () => EntraIdCryptoProvider.decodeBase64Url('invalid-base64'),
          throwsA(isA<FormatException>()),
        );
      },
    );
  });
}
