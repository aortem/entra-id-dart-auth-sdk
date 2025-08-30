/// Types of tokens that can be stored in the cache
enum TokenType {
  /// Access tokens for resource access
  accessToken,

  /// Refresh tokens for token renewal
  refreshToken,

  /// ID tokens containing user claims
  idToken,
}
