/// Parameters for interactive authentication
class InteractiveRequestParameters {
  /// The client ID of the application
  final String clientId;

  /// The redirect URI for the authentication response
  final String redirectUri;

  /// The requested scopes
  final List<String> scopes;

  /// Optional login hint (username) to pre-fill
  final String? loginHint;

  /// Optional domain hint for authentication
  final String? domainHint;

  /// Optional prompt behavior
  final String? prompt;

  /// Whether to use PKCE for enhanced security
  final bool usePkce;

  /// Timeout duration for the interactive flow
  final Duration timeout;

  /// Optional extra query parameters
  final Map<String, String>? extraQueryParameters;

  /// Optional correlation ID for request tracing
  final String? correlationId;

  /// Creates a new instance of InteractiveRequestParameters
  InteractiveRequestParameters({
    required this.clientId,
    required this.redirectUri,
    required this.scopes,
    this.loginHint,
    this.domainHint,
    this.prompt,
    this.usePkce = true,
    this.timeout = const Duration(minutes: 5),
    this.extraQueryParameters,
    this.correlationId,
  });
}
