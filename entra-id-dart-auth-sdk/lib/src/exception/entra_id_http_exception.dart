/// {@template entra_id_http_exception}
/// An exception thrown when an HTTP request to the Microsoft Entra ID service fails.
///
/// This exception provides detailed information about the failed request,
/// including the HTTP status code, error message, target URI, response headers,
/// and the response body (if available and applicable).
/// {@endtemplate}
class HttpException implements Exception {
  /// The HTTP status code returned by the server (e.g., 400, 404, 500).
  final int statusCode;

  /// A human-readable message describing the error.
  final String message;

  /// The full URI of the API endpoint that was requested.
  final Uri uri;

  /// The headers received in the HTTP response.
  final Map<String, String> headers;

  /// The body of the HTTP response, often containing detailed error information
  /// from the server in JSON or XML format. May be `null` for responses with no body.
  final String? responseBody;

  /// Creates a new [ HttpException].
  ///
  /// {@macro entra_id_http_exception}
  ///
  /// Parameters:
  ///   - [statusCode]: The HTTP status code of the failed response.
  ///   - [message]: A descriptive error message.
  ///   - [uri]: The URI that was requested.
  ///   - [headers]: The response headers. Defaults to an empty const map.
  ///   - [responseBody]: The raw response body, if available.
  HttpException({
    required this.statusCode,
    required this.message,
    required this.uri,
    this.headers = const {},
    this.responseBody,
  });

  /// Returns a string representation of this exception.
  ///
  /// The string includes the status code, message, URI, and the response body,
  /// providing a comprehensive overview for debugging purposes.
  @override
  String toString() =>
      ' HttpException($statusCode) $message\nURI: $uri\nBody: $responseBody';
}
