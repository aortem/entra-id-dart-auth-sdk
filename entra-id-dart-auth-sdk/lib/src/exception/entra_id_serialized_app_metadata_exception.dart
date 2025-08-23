/// Exception thrown for app metadata entity operations.
///
/// This exception is used to indicate errors encountered while accessing,
/// parsing, or manipulating application metadata. It supports a descriptive
/// [message], an optional [code] for categorizing the error, and [details]
/// for providing additional context.
///
/// Example:
/// ```dart
/// throw AppMetadataEntityException(
///   'App metadata is missing required fields',
///   code: 'MISSING_FIELDS',
///   details: {'requiredFields': ['app_id', 'tenant']},
/// );
/// ```
class AppMetadataEntityException implements Exception {
  /// A message describing the cause of the exception.
  final String message;

  /// An optional error code to help identify the type of exception.
  final String? code;

  /// Additional context or diagnostic information about the error.
  final dynamic details;

  /// Creates an instance of [AppMetadataEntityException] with a required [message],
  /// and optional [code] and [details] for further context.
  AppMetadataEntityException(this.message, {this.code, this.details});

  @override
  String toString() => 'AppMetadataEntityException: $message (Code: $code)';
}
