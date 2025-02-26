/// A class to manage confidential client applications for the Aortem Entra ID SDK.
class AortemEntraIdConfidentialClientApplication {
  /// The client ID of the confidential client application.
  final String clientId;

  /// The authority (e.g., the tenant-specific or common endpoint URL).
  final String authority;

  /// The client secret for the application (if applicable).
  final String? clientSecret;

  /// The client assertion for the application (if applicable).
  final String? clientAssertion;

  /// Constructor for initializing the confidential client application.
  ///
  /// Throws [ArgumentError] if required parameters are not provided or invalid.
  AortemEntraIdConfidentialClientApplication({
    required AortemEntraIdConfiguration configuration,
    required this.credential,
    this.credentialType = CredentialType.secret,
    this.allowLegacyProtocols = false,
  }) : super(configuration) {
    validateConfiguration();
  }

  @override
  void validateConfiguration() {
    if (credential.isEmpty) {
      handleError(
        'Credential cannot be empty',
        code: 'invalid_credential',
      );
    }

    if (!configuration.authority.startsWith('https://')) {
      handleError(
        'Authority must use HTTPS',
        code: 'invalid_authority_protocol',
      );
    }

    _logger.info('Confidential client configuration validated');
  }

  @override
  Future<Map<String, dynamic>> acquireToken() async {
    _logger.info('Acquiring token for confidential client');

    try {
      switch (credentialType) {
        case CredentialType.secret:
          return await _acquireTokenWithSecret();
        case CredentialType.certificate:
          return await _acquireTokenWithCertificate();
        case CredentialType.assertion:
          return await _acquireTokenWithAssertion();
      }
    } catch (e) {
      handleError(
        'Failed to acquire token',
        code: 'token_acquisition_failed',
        details: e,
      );
    }
  }

  /// Acquires token using client secret
  Future<Map<String, dynamic>> _acquireTokenWithSecret() async {
    // TODO: Implement client secret flow
    // This would make a POST request to the token endpoint with client_credentials grant
    throw UnimplementedError();
  }

  /// Acquires token using client certificate
  Future<Map<String, dynamic>> _acquireTokenWithCertificate() async {
    // TODO: Implement certificate-based authentication
    throw UnimplementedError();
  }

  /// Acquires token using client assertion
  Future<Map<String, dynamic>> _acquireTokenWithAssertion() async {
    // TODO: Implement client assertion flow
    throw UnimplementedError();
  }

  @override

  /// Refreshes an existing token for a confidential client using the
  /// `refresh_token` grant.
  ///
  /// This method will throw an [UnimplementedError] until implemented.
  ///
  /// If the token refresh fails, a [TokenAcquisitionException] will be thrown.
  ///
  /// Returns a new token if the refresh is successful.
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    _logger.info('Refreshing token for confidential client');

    try {
      // TODO: Implement token refresh
      // This would make a POST request to the token endpoint with refresh_token grant
      throw UnimplementedError();
    } catch (e) {
      handleError(
        'Failed to refresh token',
        code: 'token_refresh_failed',
        details: e,
      );
    }
  }

  /// Makes client credentials request
  Future<Map<String, dynamic>> acquireTokenByClientCredential(
      List<String> scopes) async {
    validateScopes(scopes);

    try {
      // Check cache first
      final cachedToken = await acquireTokenSilently(scopes);
      if (cachedToken != null) {
        _logger.info('Retrieved token from cache');
        return cachedToken;
      }

      // Acquire new token
      final tokenResponse = await acquireToken();

      // Cache the new token
      // await _cacheStore.set(
      //   _generateTokenCacheKey(scopes),
      //   tokenResponse,
      // );

      return tokenResponse;
    } catch (e) {
      handleError(
        'Failed to acquire token by client credential',
        code: 'client_credential_failed',
        details: e,
      );
    }
  }

  /// Makes on-behalf-of request
  Future<Map<String, dynamic>> acquireTokenOnBehalfOf(
    String userAssertion,
    List<String> scopes,
  ) async {
    validateScopes(scopes);

    try {
      // TODO: Implement on-behalf-of flow
      // This would exchange the user's token for a new token
      throw UnimplementedError();
    } catch (e) {
      handleError(
        'Failed to acquire token on behalf of user',
        code: 'on_behalf_of_failed',
        details: e,
      );
    }
  }

  @override

  /// Returns application metadata
  ///
  /// This includes the credential type and whether legacy protocols are allowed
  Map<String, dynamic> getApplicationMetadata() {
    final metadata = super.getApplicationMetadata();
    metadata['credentialType'] = credentialType.toString();
    metadata['allowLegacyProtocols'] = allowLegacyProtocols;
    return metadata;
  }
}
