import 'dart:convert';
import 'dart:math';
import 'package:ds_standard_features/ds_standard_features.dart';

/// AortemEntraIdCryptoProvider: Utility class to perform cryptographic operations
/// in the Entra ID Dart SDK. It includes methods for hashing, signing, and
/// generating PKCE (Proof Key for Code Exchange) challenges.
class AortemEntraIdCryptoProvider {
  /// Method to generate a SHA256 hash of the input string.
  ///
  /// [input] The input string to be hashed.
  ///
  /// Returns the SHA256 hash as a string.
  ///
  /// Throws [FormatException] if the hashing fails.
  static String generateSha256Hash(String input) {
    try {
      final bytes = utf8.encode(input); // Convert input string to bytes
      final hash = sha256.convert(bytes); // Hash the bytes
      return hash.toString(); // Return the hash as a string
    } catch (e) {
      throw FormatException("Failed to generate SHA256 hash: $e");
    }
  }

  /// Method to generate a PKCE code verifier.
  ///
  /// Generates a secure random 64-byte code verifier for PKCE (Proof Key for Code Exchange).
  ///
  /// Returns the base64 URL-safe encoded code verifier.
  ///
  /// Throws [FormatException] if the generation fails.
  static String generatePkceCodeVerifier() {
    try {
      final rng = Random.secure(); // Secure random number generator
      final bytes = List<int>.generate(
        64,
        (_) => rng.nextInt(256),
      ); // Generate 64 random bytes
      return base64Url.encode(
        bytes,
      ); // Return the base64 URL-safe encoded verifier
    } catch (e) {
      throw FormatException("Failed to generate PKCE code verifier: $e");
    }
  }

  /// Method to generate a PKCE code challenge from the given code verifier.
  ///
  /// [codeVerifier] The code verifier string to generate a challenge from.
  ///
  /// Returns the base64 URL-safe encoded code challenge.
  ///
  /// Throws [FormatException] if the challenge generation fails.
  static String generatePkceCodeChallenge(String codeVerifier) {
    try {
      final bytes = utf8.encode(codeVerifier); // Encode the code verifier
      final hash = sha256.convert(bytes); // Hash it with SHA256
      return base64Url.encode(
        hash.bytes,
      ); // Return the code challenge as base64 URL-safe
    } catch (e) {
      throw FormatException("Failed to generate PKCE code challenge: $e");
    }
  }

  /// Method to generate HMAC-SHA256 signature.
  ///
  /// [key] The key used for HMAC.
  /// [data] The data to be signed.
  ///
  /// Returns the HMAC SHA256 signature as a string.
  ///
  /// Throws [FormatException] if the signing process fails.
  static String generateHmacSha256(String key, String data) {
    try {
      final keyBytes = utf8.encode(key); // Convert the key to bytes
      final dataBytes = utf8.encode(data); // Convert the data to bytes
      final hmac = Hmac(sha256, keyBytes); // Create an HMAC-SHA256 instance
      final digest = hmac.convert(dataBytes); // Generate the HMAC signature
      return digest.toString(); // Return the HMAC signature as a string
    } catch (e) {
      throw FormatException("Failed to generate HMAC SHA256: $e");
    }
  }

  /// Method to encode a string to Base64 URL-safe encoding.
  ///
  /// [input] The string to encode.
  ///
  /// Returns the Base64 URL-safe encoded string.
  static String encodeBase64Url(String input) {
    final bytes = utf8.encode(input);
    return base64Url.encode(bytes); // Encode to Base64 URL-safe string
  }

  /// Method to decode a Base64 URL-safe encoded string.
  ///
  /// [input] The Base64 URL-safe encoded string.
  ///
  /// Returns the decoded string.
  ///
  /// Throws [FormatException] if decoding fails.
  static String decodeBase64Url(String input) {
    try {
      final decodedBytes = base64Url.decode(
        input,
      ); // Decode from Base64 URL-safe string
      return utf8.decode(decodedBytes); // Convert bytes back to string
    } catch (e) {
      throw FormatException("Failed to decode Base64 URL-safe string: $e");
    }
  }
}
