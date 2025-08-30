import 'dart:convert';

/// EntraIdEncodingUtils: Provides encoding and decoding utilities.
///
/// This class supports Base64 and URL encoding/decoding operations required
/// for secure communication and request construction in the Aortem EntraId Dart SDK.
class EntraIdEncodingUtils {
  /// Encodes a string to Base64 URL-safe format.
  ///
  /// Throws [ArgumentError] if the input is empty.
  ///
  /// Example:
  /// ```dart
  /// final encoded = EntraIdEncodingUtils.encodeBase64('Hello, World!');
  /// print(encoded); // Encoded Base64 string.
  /// ```
  static String encodeBase64(String input) {
    if (input.isEmpty) {
      throw ArgumentError('Input for Base64 encoding cannot be empty.');
    }

    final bytes = utf8.encode(input);
    return base64UrlEncode(bytes);
  }

  /// Decodes a Base64 URL-safe encoded string.
  ///
  /// Throws [ArgumentError] if the input is empty or improperly formatted.
  ///
  /// Example:
  /// ```dart
  /// final decoded = EntraIdEncodingUtils.decodeBase64(encoded);
  /// print(decoded); // Decoded string.
  /// ```
  static String decodeBase64(String encodedInput) {
    if (encodedInput.isEmpty) {
      throw ArgumentError('Input for Base64 decoding cannot be empty.');
    }

    final bytes = base64Url.decode(encodedInput);
    return utf8.decode(bytes);
  }

  /// Encodes a string for safe use in URLs.
  ///
  /// Example:
  /// ```dart
  /// final encoded = EntraIdEncodingUtils.encodeUrl('Hello, World!');
  /// print(encoded); // Encoded URL string.
  /// ```
  static String encodeUrl(String input) {
    return Uri.encodeComponent(input);
  }

  /// Decodes a URL-encoded string.
  ///
  /// Example:
  /// ```dart
  /// final decoded = EntraIdEncodingUtils.decodeUrl(encoded);
  /// print(decoded); // Decoded URL string.
  /// ```
  static String decodeUrl(String encodedInput) {
    return Uri.decodeComponent(encodedInput);
  }
}
