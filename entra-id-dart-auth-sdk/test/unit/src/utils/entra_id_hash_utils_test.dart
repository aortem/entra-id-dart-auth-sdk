import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';

import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as crypto;

void main() {
  group('EntraIdHashUtils', () {
    test('hashSHA256 should hash input and return Base64 encoded string', () {
      final input = 'example_data';
      final expectedHash = base64Encode(
        crypto.sha256.convert(utf8.encode(input)).bytes,
      );

      final hashedValue = EntraIdHashUtils.hashSHA256(input);

      // Assert that the hash matches the expected value
      expect(hashedValue, equals(expectedHash));
    });

    test('validateSHA256 should return true for matching hash', () {
      final input = 'example_data';
      final hashedValue = EntraIdHashUtils.hashSHA256(input);

      final isValid = EntraIdHashUtils.validateSHA256(input, hashedValue);

      // Assert that the plain text matches the hash
      expect(isValid, isTrue);
    });

    test('validateSHA256 should return false for non-matching hash', () {
      final input = 'example_data';
      final incorrectHash = 'incorrect_hash_value';

      final isValid = EntraIdHashUtils.validateSHA256(
        input,
        incorrectHash,
      );

      // Assert that the validation fails
      expect(isValid, isFalse);
    });

    test('hashSHA256 should throw error for empty input', () {
      expect(() => EntraIdHashUtils.hashSHA256(''), throwsArgumentError);
    });
  });
}
