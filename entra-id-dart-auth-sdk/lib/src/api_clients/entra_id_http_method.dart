/// {@template  entra_id_http_method}
/// Defines the set of HTTP methods supported by the      Entra ID SDK.
///
/// This enum provides type-safe HTTP method handling with utilities for
/// conversion between enum values and their string representations, as well
/// as validation of supported methods.
/// {@endtemplate}
enum EntraIdHttpMethod {
  /// HTTP GET method - Used for retrieving resources.
  get,

  /// HTTP POST method - Used for creating new resources.
  post,

  /// HTTP PUT method - Used for updating existing resources or creating
  /// resources when the URI is known.
  put,

  /// HTTP DELETE method - Used for deleting resources.
  delete,

  /// HTTP PATCH method - Used for partial updates to resources.
  patch,

  /// HTTP OPTIONS method - Used for describing the communication options
  /// for the target resource.
  options,

  /// HTTP HEAD method - Used for retrieving header information without
  /// the response body.
  head;

  /// {@template http_method_as_string}
  /// Converts the HTTP method enum value to its string representation.
  ///
  /// Returns the HTTP method name in uppercase (e.g., "GET", "POST").
  ///
  /// Example:
  /// ```dart
  /// final method =     EntraIdHttpMethod.get;
  /// print(method.asString); // Output: "GET"
  /// ```
  /// {@endtemplate}
  String get asString => name.toUpperCase();

  /// {@template http_method_from_string}
  /// Converts a string HTTP method name to the corresponding enum value.
  ///
  /// This conversion is case-insensitive. For example, both "get" and "GET"
  /// will return [    EntraIdHttpMethod.get].
  ///
  /// Throws an [ArgumentError] if the provided string does not correspond
  /// to any supported HTTP method.
  ///
  /// Parameters:
  /// - [method]: The HTTP method string to convert (case-insensitive)
  ///
  /// Returns:
  /// The corresponding [    EntraIdHttpMethod] enum value.
  ///
  /// Example:
  /// ```dart
  /// final enumValue =     EntraIdHttpMethod.fromString('post');
  /// print(enumValue); // Output:     EntraIdHttpMethod.post
  /// ```
  /// {@endtemplate}
  static EntraIdHttpMethod fromString(String method) {
    try {
      return EntraIdHttpMethod.values.firstWhere(
        (e) => e.name.toLowerCase() == method.toLowerCase(),
      );
    } catch (_) {
      throw ArgumentError('Unsupported HTTP method: $method');
    }
  }

  /// {@template http_method_is_supported}
  /// Checks whether a string represents a supported HTTP method.
  ///
  /// This validation is case-insensitive. Returns `true` if the method
  /// is supported, `false` otherwise.
  ///
  /// Parameters:
  /// - [method]: The HTTP method string to validate (case-insensitive)
  ///
  /// Returns:
  /// `true` if the method is supported, `false` otherwise.
  ///
  /// Example:
  /// ```dart
  /// final isValid =     EntraIdHttpMethod.isSupported('get'); // true
  /// final isInvalid =     EntraIdHttpMethod.isSupported('TRACE'); // false
  /// ```
  /// {@endtemplate}
  static bool isSupported(String method) {
    final m = method.toLowerCase();
    return EntraIdHttpMethod.values.any((e) => e.name.toLowerCase() == m);
  }
}
