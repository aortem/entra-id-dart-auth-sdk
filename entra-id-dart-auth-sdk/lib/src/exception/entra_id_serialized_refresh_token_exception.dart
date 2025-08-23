/// Exception thrown for refresh token entity operations.
///
/// This exception is used to represent errors related to the refresh token
/// during authentication or token management processes. It supports an
/// optional [code] and additional [details] to provide context.
///
/// Example:
/// ```dart
/// throw RefreshTokenEntityException(
///   'Refresh token is invalid',
///   code: 'INVALID_REFRESH_TOKEN',
///   details: {'token': 'abc123'},
/// );
/// ```
class RefreshTokenEntityException implements Exception {
  /// A descriptive error message explaining the exception.
  final String message;

  /// An optional error code that can be used for programmatic handling.
  final String? code;

  /// Optional additional information about the exception.
  final dynamic details;

  /// Constructs a [RefreshTokenEntityException] with the given [message],
  /// and optionally a [code] and [details].
  RefreshTokenEntityException(this.message, {this.code, this.details});

  @override
  String toString() => 'RefreshTokenEntityException: $message (Code: $code)';
}
