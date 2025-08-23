/// Exception thrown during token cache operations.
///
/// This exception indicates errors encountered while accessing,
/// storing, or managing tokens in the cache. It includes a descriptive
/// [message], an optional [code] for categorizing the error, and optional
/// [details] providing additional context.
///
/// Example usage:
/// ```dart
/// throw TokenCacheException(
///   'Failed to retrieve token from cache',
///   code: 'TOKEN_NOT_FOUND',
///   details: {'tokenKey': 'user_access_token'},
/// );
/// ```
class TokenCacheException implements Exception {
  /// A descriptive message explaining the cause of the exception.
  final String message;

  /// An optional error code to classify the type of error.
  final String? code;

  /// Optional additional information about the exception.
  final dynamic details;

  /// Constructs a [TokenCacheException] with the given [message],
  /// and optional [code] and [details].
  TokenCacheException(this.message, {this.code, this.details});

  @override
  String toString() =>
      'TokenCacheException: $message${code != null ? ' (Code: $code)' : ''}';
}
