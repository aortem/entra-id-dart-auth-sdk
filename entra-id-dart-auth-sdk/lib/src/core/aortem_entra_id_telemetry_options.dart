/// AortemEntraIdTelemetryOptions: Configure telemetry settings for the SDK.
///
/// This class manages telemetry options, such as event tracking and endpoint configuration.
class AortemEntraIdTelemetryOptions {
  // Enable or disable telemetry collection
  final bool enableTelemetry;

  // Telemetry endpoint URL
  final String telemetryEndpoint;

  // Retry attempts for telemetry if endpoint is unreachable
  final int retryAttempts;

  // Private constructor with named parameters
  AortemEntraIdTelemetryOptions({
    required this.enableTelemetry,
    required this.telemetryEndpoint,
    this.retryAttempts = 3, // Default: 3 retries
  }) {
    if (enableTelemetry && telemetryEndpoint.isEmpty) {
      throw ArgumentError('Telemetry is enabled, but no telemetry endpoint is provided.');
    }

    if (retryAttempts < 0) {
      throw ArgumentError('Retry attempts cannot be negative.');
    }
  }
}
