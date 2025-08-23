import 'package:entra_id_dart_auth_sdk/src/enum/entra_id_browser_type_enum.dart';
import 'package:ds_standard_features/ds_standard_features.dart';

import '../config/entra_id_configuration.dart';
import 'entra_id_client_application.dart';

/// Represents a public client application in Entra ID.
/// Used for applications that cannot securely store secrets (e.g., mobile apps, SPAs).
class EntraIdPublicClientApplication
    extends EntraIdClientApplication {
  final Logger _logger = Logger('EntraIdPublicClientApplication');

  /// The type of browser to use for interactive authentication
  final BrowserType browserType;

  /// Whether to enable token caching in memory
  final bool enableMemoryCache;

  /// Whether to use PKCE for authorization code flow
  final bool usePkce;

  /// Creates a new instance of EntraIdPublicClientApplication
  EntraIdPublicClientApplication({
    required EntraIdConfiguration configuration,
    this.browserType = BrowserType.systemDefault,
    this.enableMemoryCache = true,
    this.usePkce = true,
    required String redirectUri,
  }) : super(configuration) {
    validateConfiguration();
  }

  @override
  void validateConfiguration() {
    if (configuration.redirectUri.isEmpty) {
      handleError(
        'Redirect URI is required for public client applications',
        code: 'missing_redirect_uri',
      );
    }

    _logger.info('Public client configuration validated');
  }

  @override
  Future<Map<String, dynamic>> acquireToken() async {
    _logger.info('Acquiring token for public client');
    try {
      // Logic to acquire token (e.g., making an HTTP request to token endpoint)
      return {'access_token': 'mocked_access_token', 'expires_in': 3600};
    } catch (e) {
      handleError(
        'Failed to acquire token',
        code: 'token_acquisition_failed',
        details: e,
      );
    }
  }

  @override
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    _logger.info('Refreshing token for public client');

    try {
      // Make a POST request to refresh token endpoint
      return {'access_token': 'mocked_refreshed_token', 'expires_in': 3600};
    } catch (e) {
      handleError(
        'Failed to refresh token',
        code: 'token_refresh_failed',
        details: e,
      );
    }
  }

  /// Initiates interactive authentication flow
  Future<Map<String, dynamic>> acquireTokenInteractive(
    List<String> scopes,
  ) async {
    validateScopes(scopes);

    try {
      // Check cache first if enabled
      if (enableMemoryCache) {
        final cachedToken = await acquireTokenSilently(scopes);
        if (cachedToken != null) {
          _logger.info('Retrieved token from cache');
          return cachedToken;
        }
      }

      // Logic to initiate interactive authentication (launch browser, PKCE, etc.)
      return {
        'access_token': 'mocked_access_token',
        'refresh_token': 'mocked_refresh_token',
        'id_token': 'mocked_id_token',
        'expires_in': 3600,
      };
    } catch (e) {
      handleError(
        'Failed to acquire token interactively',
        code: 'interactive_auth_failed',
        details: e,
      );
    }
  }

  /// Initiates device code flow authentication
  Future<Map<String, dynamic>> acquireTokenWithDeviceCode(
    List<String> scopes,
  ) async {
    validateScopes(scopes);

    try {
      // Logic to initiate device code flow (request device code, poll, etc.)
      return {'access_token': 'mocked_device_code_token', 'expires_in': 3600};
    } catch (e) {
      handleError(
        'Failed to acquire token with device code',
        code: 'device_code_failed',
        details: e,
      );
    }
  }

  /// Signs out the current user
  Future<void> signOut() async {
    try {
      // Clear token cache
      await clearCache();

      // Logic for sign-out (e.g., revoke refresh tokens, clear cookies)
      _logger.info('User signed out successfully');
    } catch (e) {
      handleError(
        'Failed to sign out user',
        code: 'sign_out_failed',
        details: e,
      );
    }
  }

  @override
  Map<String, dynamic> getApplicationMetadata() {
    final metadata = super.getApplicationMetadata();
    metadata['browserType'] = browserType.toString();
    metadata['enableMemoryCache'] = enableMemoryCache;
    metadata['usePkce'] = usePkce;
    return metadata;
  }

  /// Gets authorization code URL
  Future<String> getAuthorizationCodeUrl(List<String> scopes) async {
    validateScopes(scopes);

    try {
      // Logic to generate authorization code URL
      return 'mocked_authorization_url';
    } catch (e) {
      handleError(
        'Failed to generate authorization URL',
        code: 'auth_url_failed',
        details: e,
      );
    }
  }
}
