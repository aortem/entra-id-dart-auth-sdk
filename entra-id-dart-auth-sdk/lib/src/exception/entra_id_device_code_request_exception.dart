/// Exception thrown for device code request errors
class DeviceCodeException implements Exception {
  /// A message describing the error
  final String message;

  /// Optional error code associated with the error (e.g., an error code from the device code request)
  final String? code;

  /// Optional additional details providing more context about the error
  final dynamic details;

  /// Constructor to initialize the exception with a message, and optionally with a code and details
  DeviceCodeException(this.message, {this.code, this.details});

  /// Custom string representation of the exception, useful for debugging and logging
  @override
  String toString() => 'DeviceCodeException: $message (Code: $code)';
}
