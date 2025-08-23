/// Custom exception for user cancellation during the authentication flow.
///
/// This exception is thrown when the user cancels the authentication process
/// during the token acquisition flow. It provides a custom error message to indicate
/// the specific cause of the failure (i.e., user cancellation).
///
/// Example usage:
/// ```dart
/// try {
///   await request.acquireToken('user@example.com', 'password123');
/// } catch (e) {
///   if (e is EntraIdUserCancelledException) {
///     print('User cancelled the authentication process.');
///   } else {
///     print('Other error: $e');
///   }
/// }
/// ```
class EntraIdUserCancelledException implements Exception {
  /// The error message associated with the exception.
  ///
  /// Defaults to 'User cancelled the authentication process.'
  final String message;

  /// Constructs an instance of `EntraIdUserCancelledException`.
  ///
  /// - [message]: The message describing the cancellation. Defaults to a predefined message
  ///   if not provided.
  EntraIdUserCancelledException(
      [this.message = 'User cancelled the authentication process.']);

  @override
  String toString() => 'EntraIdUserCancelledException: $message';
}
