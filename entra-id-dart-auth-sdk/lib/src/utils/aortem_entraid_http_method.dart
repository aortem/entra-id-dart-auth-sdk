/// File: src/utils/http/aortem_entraid_http_method.dart
///
/// AortemEntraIdHttpMethod: Defines standard HTTP methods for API requests
/// in the Aortem EntraId Dart SDK.
///
/// This file provides an enumeration of HTTP methods and a utility class to
/// validate, convert, and manage HTTP methods consistently across the SDK.
///
/// Author: Usman Babar
/// Email: ubabar@venturseed.com
/// Date: 2025-01-14

/// Enum defining standard HTTP methods.
enum AortemEntraIdHttpMethod {
  /// The HTTP GET method is used to retrieve data from a server.
  GET,

  /// The HTTP POST method is used to send data to a server.
  POST,

  /// The HTTP PUT method is used to update or create a resource.
  PUT,

  /// The HTTP DELETE method is used to delete a resource from a server.
  DELETE,

  /// The HTTP PATCH method is used to partially update a resource.
  PATCH,

  /// The HTTP HEAD method retrieves the headers of a resource without its body.
  HEAD,

  /// The HTTP OPTIONS method describes the communication options for a resource.
  OPTIONS,

  /// The HTTP TRACE method performs a diagnostic request for testing.
  TRACE,
}

/// Utility class for managing and validating HTTP methods.
class AortemEntraIdHttpMethodUtils {
  /// Converts an [AortemEntraIdHttpMethod] enum value to its string representation.
  ///
  /// Example:
  /// ```dart
  /// final method = AortemEntraIdHttpMethod.POST;
  /// print(AortemEntraIdHttpMethodUtils.methodToString(method)); // Output: POST
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
  /// final method = AortemEntraIdHttpMethodUtils.stringToMethod('GET');
  /// print(method); // Output: AortemEntraIdHttpMethod.GET
  /// ```
  static AortemEntraIdHttpMethod stringToMethod(String method) {
    try {
      return AortemEntraIdHttpMethod.values
          .firstWhere((e) => e.name.toUpperCase() == method.toUpperCase());
    } catch (e) {
      throw ArgumentError('Unsupported HTTP method: $method');
    }
  }

  /// Checks if a provided string is a valid HTTP method.
  ///
  /// Example:
  /// ```dart
  /// final isValid = AortemEntraIdHttpMethodUtils.isSupported('PATCH');
  /// print(isValid); // Output: true
  /// ```
  static bool isSupported(String method) {
    return AortemEntraIdHttpMethod.values
        .map((e) => e.name.toUpperCase())
        .contains(method.toUpperCase());
  }
}
