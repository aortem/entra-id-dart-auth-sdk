/// Parameters for device code flow requests
class DeviceCodeRequestParameters {
  /// The client ID of the application
  final String clientId;

  /// The scopes to request
  final List<String> scopes;

  /// Optional client secret for confidential clients
  final String? clientSecret;

  /// Optional correlation ID for request tracing
  final String? correlationId;

  /// Creates a new instance of DeviceCodeRequestParameters
  DeviceCodeRequestParameters({
    required this.clientId,
    required this.scopes,
    this.clientSecret,
    this.correlationId,
  });
}
