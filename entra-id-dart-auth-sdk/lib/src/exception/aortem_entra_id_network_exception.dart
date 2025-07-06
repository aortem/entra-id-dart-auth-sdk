/// Custom exception for network-related errors.
///
/// This exception is thrown when there is a failure in a network operation,
/// such as when checking internet connectivity, performing a network request,
/// or retrying a network operation multiple times and still failing.
///
/// It allows you to pass an optional [message] and [cause] to provide more
/// context about the error.
///
/// Example usage:
/// ```dart
/// try {
///   await networkUtils.checkInternetConnectivity();
/// } catch (e) {
///   if (e is NetworkException) {
///     print('Network error: ${e.message}');
///   }
/// }
/// ```
class NetworkException implements Exception {
  /// The error message that describes the problem.
  final String message;

  /// The underlying cause of the exception, if any.
  final Object? cause;

  /// Constructs a [NetworkException] with an optional [message] and [cause].
  ///
  /// - [message]: The description of the error. Defaults to 'Network operation failed.'
  /// - [cause]: The underlying cause of the exception (optional). It can be another exception or error.
  ///
  /// Example:
  /// ```dart
  /// throw NetworkException('Failed to connect to the server.', e);
  /// ```
  NetworkException(
      [this.message = 'Network operation failed.',
      this.cause]); // Constructor initializes the exception with a message and an optional cause.

  @override
  String toString() =>
      'NetworkException: $message ${cause != null ? 'Cause: $cause' : ''}'; // Converts the exception to a string with message and cause if available.
}
