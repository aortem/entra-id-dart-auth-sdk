import 'package:entra_id_dart_auth_sdk/src/enum/aortem_entra_id_http_method_enum.dart';

/// Utility class for managing and validating HTTP methods.
class AortemEntraIdHttpMethodUtils {
  /// Converts an [AortemEntraIdHttpMethod] enum value to its string representation.
  ///
  /// Example:
  /// ```dart
  /// final method = AortemEntraIdHttpMethod.post;
  /// print(AortemEntraIdHttpMethodUtils.methodToString(method)); // Output: post
  /// ```
  static String methodToString(AortemEntraIdHttpMethod method) {
    return method.name;
  }

  /// Converts a string to its corresponding [AortemEntraIdHttpMethod] enum value.
  ///
  /// Throws [ArgumentError] if the provided method string is not supported.
  ///
  /// Example:
  /// ```dart
  /// final method = AortemEntraIdHttpMethodUtils.stringToMethod('get');
  /// print(method); // Output: AortemEntraIdHttpMethod.get
  /// ```
  static AortemEntraIdHttpMethod stringToMethod(String method) {
    try {
      return AortemEntraIdHttpMethod.values.firstWhere(
        (e) => e.name.toLowerCase() == method.toLowerCase(),
      );
    } catch (e) {
      throw ArgumentError('Unsupported HTTP method: $method');
    }
  }

  /// Checks if a provided string is a valid HTTP method.
  ///
  /// Example:
  /// ```dart
  /// final isValid = AortemEntraIdHttpMethodUtils.isSupported('patch');
  /// print(isValid); // Output: true
  /// ```
  static bool isSupported(String method) {
    return AortemEntraIdHttpMethod.values
        .map((e) => e.name.toLowerCase())
        .contains(method.toLowerCase());
  }
}
