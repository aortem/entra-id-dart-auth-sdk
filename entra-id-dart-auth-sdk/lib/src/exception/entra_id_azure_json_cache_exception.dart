/// Exception thrown for JSON cache operations.
///
/// This exception is thrown when there are errors encountered during JSON
/// cache operations, such as reading, writing, or invalidating cached data.
/// It provides information about the error message, an optional error code,
/// and any additional details relevant to the exception.
///
class JsonCacheException implements Exception {
  /// The error message describing the exception.
  final String message;

  /// An optional error code associated with the exception.
  final String? code;

  /// Optional additional details about the exception.
  final dynamic details;

  /// Constructor for creating a [JsonCacheException].
  ///
  /// [message] is the description of the exception.
  /// [code] is an optional error code for the exception (default is null).
  /// [details] can provide extra information regarding the exception (default is null).
  JsonCacheException(this.message, {this.code, this.details});

  @override
  String toString() => 'JsonCacheException: $message (Code: $code)';
}
