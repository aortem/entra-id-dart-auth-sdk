/// Exception thrown for errors occurring during On-Behalf-Of (OBO) requests.
///
/// This exception is raised when a token acquisition fails while trying
/// to obtain a token on behalf of a user using the OBO flow.
class OnBehalfOfRequestException implements Exception {
  /// A descriptive message explaining the cause of the error.
  final String message;

  /// An optional error code that provides more context about the failure.
  final String? code;

  /// Additional details that may help in debugging the error.
  /// Can include error response data or internal metadata.
  final dynamic details;

  /// Creates a new [OnBehalfOfRequestException] with the given [message],
  /// and optionally a [code] and [details].
  OnBehalfOfRequestException(this.message, {this.code, this.details});

  /// Returns a string representation of the exception.
  @override
  String toString() => 'OnBehalfOfRequestException: $message (Code: $code)';
}
