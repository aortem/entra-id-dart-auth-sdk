/// Enum representing HTTP methods supported by Entra ID.
enum EntraIdHttpMethod {
  /// HTTP GET method.
  get,

  /// HTTP POST method.
  post,

  /// HTTP PUT method.
  put,

  /// HTTP DELETE method.
  delete,

  /// HTTP PATCH method.
  patch,

  /// HTTP HEAD method.
  head,

  /// HTTP OPTIONS method.
  options,

  /// HTTP TRACE method.
  trace,
}

/// Utility class for HTTP method conversion and validation.
class EntraIdHttpMethodUtils {
  /// Converts an HTTP method enum to its string representation.
  ///
  /// [method] The HTTP method enum value.
  ///
  /// Returns the method as a lowercase string (e.g., 'get', 'post').
  static String methodToString(EntraIdHttpMethod method) {
    return method.name.toLowerCase();
  }

  /// Converts a string to an HTTP method enum.
  ///
  /// [method] The HTTP method as a string (case-insensitive).
  ///
  /// Returns the corresponding EntraIdHttpMethod enum value.
  ///
  /// Throws [ArgumentError] if the method string is empty or not a valid HTTP method.
  static EntraIdHttpMethod stringToMethod(String method) {
    if (method.isEmpty) {
      throw ArgumentError('Method cannot be empty');
    }

    final lowerMethod = method.toLowerCase();

    try {
      return EntraIdHttpMethod.values.firstWhere((e) => e.name == lowerMethod);
    } catch (e) {
      throw ArgumentError('Invalid HTTP method: $method');
    }
  }

  /// Checks if a given string is a supported HTTP method.
  ///
  /// [method] The HTTP method string to validate (case-insensitive).
  ///
  /// Returns true if the method is supported, false otherwise.
  static bool isSupported(String method) {
    if (method.isEmpty) {
      return false;
    }

    final lowerMethod = method.toLowerCase();
    return EntraIdHttpMethod.values.any((e) => e.name == lowerMethod);
  }
}
