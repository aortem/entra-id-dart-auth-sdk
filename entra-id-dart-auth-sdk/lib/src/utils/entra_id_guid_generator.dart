import 'dart:math';

/// EntraIdGuidGenerator: Generates unique identifiers (GUIDs).
///
/// This class provides utilities for generating GUIDs, ensuring uniqueness
/// in request tracking, token operations, and logging for the Aortem EntraId Dart SDK.
class EntraIdGuidGenerator {
  /// Generates a version 4 (random) GUID.
  ///
  /// Example:
  /// ```dart
  /// final guid = EntraIdGuidGenerator.generate();
  /// print(guid); // Outputs a GUID like "550e8400-e29b-41d4-a716-446655440000".
  /// ```
  static String generate() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));

    // Set the version (4) and variant bits as per RFC 4122
    bytes[6] = (bytes[6] & 0x0f) | 0x40; // Version 4
    bytes[8] = (bytes[8] & 0x3f) | 0x80; // Variant

    return _bytesToGuidString(bytes);
  }

  /// Converts the 16-byte array into a GUID string.
  static String _bytesToGuidString(List<int> bytes) {
    final buffer = StringBuffer();
    for (var i = 0; i < bytes.length; i++) {
      buffer.write(bytes[i].toRadixString(16).padLeft(2, '0'));
      if ([3, 5, 7, 9].contains(i)) {
        buffer.write('-');
      }
    }
    return buffer.toString();
  }
}
