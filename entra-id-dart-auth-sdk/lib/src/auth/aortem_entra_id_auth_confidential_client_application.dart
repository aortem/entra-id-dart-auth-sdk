import 'package:entra_id_dart_auth_sdk/src/auth/aortem_entra_id_auth_configuration.dart';
import 'package:logging/logging.dart';

/// Enum for credential types used in authentication
enum CredentialType {
  /// Uses a client secret
  secret,

  /// Uses a client certificate
  certificate,

  /// Uses a client assertion
  assertion,
}

/// Manages confidential client applications for the Aortem Entra ID SDK.
class AortemEntraIdConfidentialClientApplication {
  /// Configuration object for the confidential client application.
  final AortemEntraIdAuthConfiguration configuration;

  /// The credential used for authentication.
  final String credential;

  /// The type of credential being used.
  final CredentialType credentialType;

  /// Whether legacy authentication protocols are allowed.
  final bool allowLegacyProtocols;

  /// Logger instance.
  static final Logger _logger = Logger(
    'AortemEntraIdConfidentialClientApplication',
  );

  /// Constructor for initializing the confidential client application.
  /// Throws [ArgumentError] if required parameters are not provided or invalid.
  AortemEntraIdConfidentialClientApplication({
    required this.configuration,
    required this.credential,
    this.credentialType = CredentialType.secret,
    this.allowLegacyProtocols = false,
  }) {
    _validateConfiguration();
  }

  /// Validates the provided configuration.
  void _validateConfiguration() {
    if (credential.isEmpty) {
      _handleError('Credential cannot be empty', code: 'invalid_credential');
    }

    if (!configuration.authority.startsWith('https://')) {
      _handleError(
        'Authority must use HTTPS',
        code: 'invalid_authority_protocol',
      );
    }

    _logger.info('Confidential client configuration validated');
  }

  /// Handles errors by logging and throwing exceptions.
  void _handleError(String message, {required String code, dynamic details}) {
    _logger.severe('$code: $message', details);
    throw ArgumentError('$code: $message');
  }

  /// Acquires a token for the confidential client.
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
      _handleError(
        'Failed to acquire token',
        code: 'token_acquisition_failed',
        details: e,
      );
    }

    return {};
  }

  /// Acquires token using client secret.
  Future<Map<String, dynamic>> _acquireTokenWithSecret() async {
    throw UnimplementedError();
  }

  /// Acquires token using client certificate.
  Future<Map<String, dynamic>> _acquireTokenWithCertificate() async {
    throw UnimplementedError();
  }

  /// Acquires token using client assertion.
  Future<Map<String, dynamic>> _acquireTokenWithAssertion() async {
    throw UnimplementedError();
  }

  /// Refreshes an existing token.
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    _logger.info('Refreshing token for confidential client');

    try {
      throw UnimplementedError();
    } catch (e) {
      _handleError(
        'Failed to refresh token',
        code: 'token_refresh_failed',
        details: e,
      );
    }

    return {};
  }

  /// Acquires token using client credentials grant.
  Future<Map<String, dynamic>> acquireTokenByClientCredential(
    List<String> scopes,
  ) async {
    _logger.info('Acquiring token using client credentials');

    try {
      return await acquireToken();
    } catch (e) {
      _handleError(
        'Failed to acquire token by client credential',
        code: 'client_credential_failed',
        details: e,
      );
    }

    return {};
  }

  /// Acquires token on behalf of a user.
  Future<Map<String, dynamic>> acquireTokenOnBehalfOf(
    String userAssertion,
    List<String> scopes,
  ) async {
    _logger.info('Acquiring token on behalf of user');

    try {
      throw UnimplementedError();
    } catch (e) {
      _handleError(
        'Failed to acquire token on behalf of user',
        code: 'on_behalf_of_failed',
        details: e,
      );
    }

    return {};
  }

  /// Returns application metadata.
  Map<String, dynamic> getApplicationMetadata() {
    return {
      'clientId': configuration.clientId,
      'authority': configuration.authority,
      'credentialType': credentialType.toString(),
      'allowLegacyProtocols': allowLegacyProtocols,
    };
  }
}
