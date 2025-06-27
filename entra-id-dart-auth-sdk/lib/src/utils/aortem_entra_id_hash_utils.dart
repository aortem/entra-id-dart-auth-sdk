import 'dart:convert';

import 'package:ds_standard_features/ds_standard_features.dart';
// Requires `crypto` package in pubspec.yaml.

/// AortemEntraIdHashUtils: Provides hashing utilities for secure data handling.
///
/// This class supports hashing operations using industry-standard algorithms
/// like SHA256, ensuring compliance with cryptographic best practices.
class AortemEntraIdHashUtils {
  /// Hashes the input data using the SHA256 algorithm.
  ///
  /// [input] is the data to be hashed. It must not be null or empty.
  /// Returns a Base64-encoded string of the hashed value.
  ///
  /// Example:
  /// ```dart
  /// final hashedValue = AortemEntraIdHashUtils.hashSHA256('example_data');
  /// print(hashedValue);
  /// ```
  static String hashSHA256(String input) {
    if (input.isEmpty) {
      throw ArgumentError('Input for SHA256 hashing cannot be empty.');
    }

    final bytes = utf8.encode(input); // Convert string to UTF-8 encoded bytes.
    final digest = sha256.convert(bytes); // Compute SHA256 hash.
    return base64Encode(digest.bytes); // Encode the hash in Base64.
  }

  /// Validates a plain-text value against a hashed value using SHA256.
  ///
  /// [plainText] is the original plain-text input.
  /// [hashedValue] is the Base64-encoded hash to validate against.
  /// Returns `true` if the hashes match, `false` otherwise.
  ///
  /// Example:
  /// ```dart
  /// final isValid = AortemEntraIdHashUtils.validateSHA256(
  ///   'example_data',
  ///   hashedValue,
  /// );
  /// print(isValid); // true or false
  /// ```
  static bool validateSHA256(String plainText, String hashedValue) {
    final computedHash = hashSHA256(plainText);
    return computedHash == hashedValue;
  }
}
