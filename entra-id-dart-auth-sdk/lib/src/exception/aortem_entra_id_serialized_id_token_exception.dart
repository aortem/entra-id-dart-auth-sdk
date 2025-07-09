/// Exception thrown for ID token entity operations.
///
/// This exception represents failures related to the ID token during
/// authentication or token parsing/validation processes. It includes
/// an error [message], an optional [code], and optional [details]
/// for enhanced debugging or error handling.
///
/// Example:
/// ```dart
/// throw IdTokenEntityException(
///   'ID token is expired',
///   code: 'EXPIRED_ID_TOKEN',
///   details: {'exp': 1712345678},
/// );
/// ```
class IdTokenEntityException implements Exception {
  /// A human-readable error message describing the exception.
  final String message;

  /// An optional error code to classify the type of error.
  final String? code;

  /// Optional additional data or metadata about the exception.
  final dynamic details;

  /// Constructs an [IdTokenEntityException] with the given [message],
  /// and optionally a [code] and [details].
  IdTokenEntityException(this.message, {this.code, this.details});

  @override
  String toString() => 'IdTokenEntityException: $message (Code: $code)';
}
