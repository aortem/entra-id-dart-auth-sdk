import 'package:entra_id_dart_auth_sdk/src/enum/entra_id_http_method_enum.dart';

/// Utility class for managing and validating HTTP methods.
class EntraIdHttpMethodUtils {
  /// Converts an [EntraIdHttpMethod] enum value to its string representation.
  ///
  /// Example:
  /// ```dart
  /// final method = EntraIdHttpMethod.post;
  /// print(EntraIdHttpMethodUtils.methodToString(method)); // Output: post
  /// ```
  static String methodToString(EntraIdHttpMethod method) {
    return method.name;
  }

  /// Converts a string to its corresponding [EntraIdHttpMethod] enum value.
  ///
  /// Throws [ArgumentError] if the provided method string is not supported.
  ///
  /// Example:
  /// ```dart
  /// final method = EntraIdHttpMethodUtils.stringToMethod('get');
  /// print(method); // Output: EntraIdHttpMethod.get
  /// ```
  static EntraIdHttpMethod stringToMethod(String method) {
    try {
      return EntraIdHttpMethod.values.firstWhere(
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
  /// final isValid = EntraIdHttpMethodUtils.isSupported('patch');
  /// print(isValid); // Output: true
  /// ```
  static bool isSupported(String method) {
    return EntraIdHttpMethod.values
        .map((e) => e.name.toLowerCase())
        .contains(method.toLowerCase());
  }
}
