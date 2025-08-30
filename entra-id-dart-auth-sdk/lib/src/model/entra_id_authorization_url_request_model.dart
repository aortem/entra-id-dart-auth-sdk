/// Parameters for building an authorization URL request
class AuthorizationUrlRequestParameters {
  /// The client ID of the application
  final String clientId;

  /// The redirect URI for the authorization response
  final String redirectUri;

  /// The requested scopes
  final List<String> scopes;

  /// Optional state parameter for security validation
  final String? state;

  /// Optional login hint (username) to pre-fill
  final String? loginHint;

  /// Optional domain hint for authentication
  final String? domainHint;

  /// Optional prompt behavior
  final String? prompt;

  /// Optional correlation ID for request tracing
  final String? correlationId;

  /// Creates a new instance of AuthorizationUrlRequestParameters
  AuthorizationUrlRequestParameters({
    required this.clientId,
    required this.redirectUri,
    required this.scopes,
    this.state,
    this.loginHint,
    this.domainHint,
    this.prompt,
    this.correlationId,
  });

  /// Creates a copy with modified fields
  AuthorizationUrlRequestParameters copyWith({
    String? clientId,
    String? redirectUri,
    List<String>? scopes,
    String? state,
    String? loginHint,
    String? domainHint,
    String? prompt,
    String? correlationId,
  }) {
    return AuthorizationUrlRequestParameters(
      clientId: clientId ?? this.clientId,
      redirectUri: redirectUri ?? this.redirectUri,
      scopes: scopes ?? this.scopes,
      state: state ?? this.state,
      loginHint: loginHint ?? this.loginHint,
      domainHint: domainHint ?? this.domainHint,
      prompt: prompt ?? this.prompt,
      correlationId: correlationId ?? this.correlationId,
    );
  }
}
