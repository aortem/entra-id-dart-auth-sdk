/// AortemHttpException: Custom exception class for handling HTTP errors.
///
/// This exception is thrown when an HTTP request fails with a non-success
/// status code. It contains the error message and the corresponding status code,
/// making it easier to debug API failures.
///
/// Example usage:
/// ```dart
/// throw AortemHttpException('Unauthorized access', 401);
/// ```
///
/// Properties:
/// - [message]: A descriptive error message explaining the reason for the failure.
/// - [statusCode]: The HTTP status code associated with the error.
///
/// Methods:
/// - [toString]: Returns a formatted string representation of the exception.
class AortemHttpException implements Exception {
  /// The error message describing the failure.
  final String message;

  /// The HTTP status code returned from the request.
  final int statusCode;

  /// Constructs an instance of `AortemHttpException` with a message and status code.
  ///
  /// - [message]: A description of the error.
  /// - [statusCode]: The HTTP response status code that triggered the error.
  AortemHttpException(this.message, this.statusCode);

  /// Returns a string representation of the exception, including the message and status code.
  @override
  String toString() =>
      'AortemHttpException: $message (Status Code: $statusCode)';
}
