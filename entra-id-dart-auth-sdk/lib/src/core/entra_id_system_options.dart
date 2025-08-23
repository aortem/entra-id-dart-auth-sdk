/// AortemEntraIdSystemOptions: Configure System-Level SDK Behavior.
///
/// This class provides centralized control over system-level behaviors such as logging,
/// telemetry, and request timeouts in the Aortem EntraId Dart SDK.
class AortemEntraIdSystemOptions {
  static AortemEntraIdSystemOptions? _instance;

  /// Enables or disables logging in the SDK.
  final bool enableLogging;

  /// Enables or disables telemetry data collection.
  final bool enableTelemetry;

  /// Request timeout in seconds.
  final int requestTimeoutInSeconds;

  /// Maximum retry attempts for failed requests.
  final int maxRetryAttempts;

  /// Private constructor for creating a singleton instance.
  AortemEntraIdSystemOptions._internal({
    required this.enableLogging,
    required this.enableTelemetry,
    required this.requestTimeoutInSeconds,
    required this.maxRetryAttempts,
  });

  /// Singleton instance getter. Initializes the system options if not already initialized.
  factory AortemEntraIdSystemOptions.initialize({
    bool enableLogging = false,
    bool enableTelemetry = true,
    int requestTimeoutInSeconds = 30, // Default timeout: 30 seconds
    int maxRetryAttempts = 3, // Default retry: 3 attempts
  }) {
    if (_instance == null) {
      // Validate configurations
      if (requestTimeoutInSeconds <= 0) {
        throw ArgumentError('Request timeout must be a positive integer.');
      }
      if (maxRetryAttempts < 0) {
        throw ArgumentError('Max retry attempts cannot be negative.');
      }

      _instance = AortemEntraIdSystemOptions._internal(
        enableLogging: enableLogging,
        enableTelemetry: enableTelemetry,
        requestTimeoutInSeconds: requestTimeoutInSeconds,
        maxRetryAttempts: maxRetryAttempts,
      );
    }
    return _instance!;
  }

  /// Check if the system options have been initialized.
  static bool get isInitialized => _instance != null;

  /// Reset the system options (useful for testing or re-initialization).
  static void reset() {
    _instance = null;
  }

  /// Access the shared instance of system options.
  ///
  /// Throws an exception if the options have not been initialized.
  static AortemEntraIdSystemOptions get instance {
    if (_instance == null) {
      throw StateError(
        'AortemEntraIdSystemOptions has not been initialized. '
        'Call initialize() first.',
      );
    }
    return _instance!;
  }
}
