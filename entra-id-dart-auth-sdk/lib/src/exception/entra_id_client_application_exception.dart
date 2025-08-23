/// Exception thrown for client application errors
class ClientApplicationException implements Exception {
  /// Error message
  final String message;

  /// Error code
  final String? code;

  /// Error details
  final dynamic details;

  /// Creates a new instance of ClientApplicationException
  ClientApplicationException(this.message, {this.code, this.details});

  @override
  String toString() => 'ClientApplicationException: $message (Code: $code)';
}
