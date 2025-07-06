/// Exception thrown for access token entity operations.
///
/// This exception is used to represent errors related to the access token
/// during authentication, parsing, validation, or storage processes.
/// It includes a [message] describing the error, and optional [code]
/// and [details] for deeper debugging and classification.
///
/// Example:
/// ```dart
/// throw AccessTokenEntityException(
///   'Access token is malformed',
///   code: 'MALFORMED_ACCESS_TOKEN',
///   details: {'token': 'abc.def.ghi'},
/// );
/// ```
class AccessTokenEntityException implements Exception {
  /// A human-readable message describing the error.
  final String message;

  /// An optional error code to categorize the type of exception.
  final String? code;

  /// Additional optional data or metadata related to the exception.
  final dynamic details;

  /// Constructs an [AccessTokenEntityException] with a required [message],
  /// and optional [code] and [details].
  AccessTokenEntityException(this.message, {this.code, this.details});

  @override
  String toString() => 'AccessTokenEntityException: $message (Code: $code)';
}
