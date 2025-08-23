/// Exception thrown for loopback client operations
class LoopbackClientException implements Exception {
  /// A message describing the error
  final String message;

  /// Optional code associated with the error (e.g., error code from the loopback client)
  final String? code;

  /// Optional additional details providing more context about the error
  final dynamic details;

  /// Constructor that initializes the message, and optionally the code and details
  LoopbackClientException(this.message, {this.code, this.details});

  /// Custom string representation of the exception, useful for debugging and logging
  @override
  String toString() => 'LoopbackClientException: $message (Code: $code)';
}
