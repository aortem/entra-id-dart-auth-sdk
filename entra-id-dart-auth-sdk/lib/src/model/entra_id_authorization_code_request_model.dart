/// Parameters for an authorization code token request
class AuthorizationCodeRequestParameters {
  /// The authorization code received from the auth endpoint
  final String authorizationCode;

  /// The redirect URI used in the initial request
  final String redirectUri;

  /// The client ID of the application
  final String clientId;

  /// Optional client secret for confidential clients
  final String? clientSecret;

  /// Optional PKCE code verifier
  final String? codeVerifier;

  /// Optional scopes to request
  final List<String>? scopes;

  /// Optional correlation ID for request tracing
  final String? correlationId;

  /// Creates a new instance of AuthorizationCodeRequestParameters
  AuthorizationCodeRequestParameters({
    required this.authorizationCode,
    required this.redirectUri,
    required this.clientId,
    this.clientSecret,
    this.codeVerifier,
    this.scopes,
    this.correlationId,
  });

  /// Creates a copy with modified fields
  AuthorizationCodeRequestParameters copyWith({
    String? authorizationCode,
    String? redirectUri,
    String? clientId,
    String? clientSecret,
    String? codeVerifier,
    List<String>? scopes,
    String? correlationId,
  }) {
    return AuthorizationCodeRequestParameters(
      authorizationCode: authorizationCode ?? this.authorizationCode,
      redirectUri: redirectUri ?? this.redirectUri,
      clientId: clientId ?? this.clientId,
      clientSecret: clientSecret ?? this.clientSecret,
      codeVerifier: codeVerifier ?? this.codeVerifier,
      scopes: scopes ?? this.scopes,
      correlationId: correlationId ?? this.correlationId,
    );
  }
}
