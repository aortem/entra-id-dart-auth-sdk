/// Status of the interactive authentication flow
enum InteractiveRequestStatus {
  /// Not started
  notStarted,

  /// Waiting for user interaction
  inProgress,

  /// Authentication completed successfully
  completed,

  /// Authentication failed
  failed,

  /// User cancelled authentication
  cancelled,

  /// Authentication timed out
  timeout,
}
