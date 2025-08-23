/// Exception thrown for interactive authentication errors
///
/// This exception is used when an error occurs during an interactive
/// authentication flow, such as when the user is prompted to log in
/// via a browser or UI-based interaction.
class InteractiveRequestException implements Exception {
  /// A descriptive message explaining the cause of the error.
  final String message;

  /// An optional error code identifying the specific error.
  final String? code;

  /// Optional additional details about the error. This can include
  /// stack traces, error response bodies, or other relevant info.
  final dynamic details;

  /// Constructs a new [InteractiveRequestException] with the provided [message],
  /// and optionally a [code] and additional [details].
  InteractiveRequestException(this.message, {this.code, this.details});

  /// Returns a readable string representation of the exception.
  @override
  String toString() => 'InteractiveRequestException: $message (Code: $code)';
}
