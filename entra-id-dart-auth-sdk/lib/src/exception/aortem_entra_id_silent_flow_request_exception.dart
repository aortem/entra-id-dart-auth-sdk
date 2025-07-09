/// Exception thrown for errors during silent flow requests.
///
/// This exception is thrown when an error occurs while attempting to perform
/// a silent flow request, typically in the context of OAuth2 or OpenID Connect
/// authentication flows, where the user is not prompted for credentials.
class SilentFlowRequestException implements Exception {
  /// The error message describing the issue.
  final String message;

  /// An optional error code associated with the exception.
  final String? code;

  /// Additional details about the error, if any.
  final dynamic details;

  /// Constructs a new [SilentFlowRequestException] with the given [message],
  /// an optional [code], and any additional [details].
  SilentFlowRequestException(this.message, {this.code, this.details});

  /// Returns a string representation of the exception, including the message
  /// and optionally the error code.
  @override
  String toString() => 'SilentFlowRequestException: $message (Code: $code)';
}
