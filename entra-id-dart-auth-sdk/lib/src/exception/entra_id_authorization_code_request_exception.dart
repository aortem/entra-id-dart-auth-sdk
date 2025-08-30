/// Exception thrown for authorization code request errors
class AuthorizationCodeException implements Exception {
  /// A message describing the error
  final String message;

  /// Optional code associated with the error (e.g., an error code from the authorization server)
  final String? code;

  /// Optional additional details providing more context about the error
  final dynamic details;

  /// Constructor that takes the message and optional code and details
  AuthorizationCodeException(this.message, {this.code, this.details});

  // Custom string representation of the exception, useful for debugging and logging
  @override
  String toString() => 'AuthorizationCodeException: $message (Code: $code)';
}
