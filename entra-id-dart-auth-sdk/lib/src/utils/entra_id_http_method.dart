///
/// EntraIdHttpMethod: Defines standard HTTP methods for API requests
/// in the Aortem EntraId Dart SDK.
///
/// This file provides an enumeration of HTTP methods and a utility class to
/// validate, convert, and manage HTTP methods consistently across the SDK.
///

library;

/// Enum defining standard HTTP methods.
enum EntraIdHttpMethod {
  /// The HTTP GET method is used to retrieve data from a server.
  get,

  /// The HTTP POST method is used to send data to a server.
  post,

  /// The HTTP PUT method is used to update or create a resource.
  put,

  /// The HTTP DELETE method is used to delete a resource from a server.
  delete,

  /// The HTTP PATCH method is used to partially update a resource.
  patch,

  /// The HTTP HEAD method retrieves the headers of a resource without its body.
  head,

  /// The HTTP OPTIONS method describes the communication options for a resource.
  options,

  /// The HTTP TRACE method performs a diagnostic request for testing.
  trace,
}

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
