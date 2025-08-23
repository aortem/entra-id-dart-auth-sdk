import 'package:logging/logging.dart';
import '../entra_id_auth_configuration.dart';
import '../entra_id_auth_cache_kvstore.dart';

/// Exception thrown when an error occurs during an On-Behalf-Of (OBO) request.
///
/// This exception is used to handle errors related to the OBO authentication flow,
/// where a service obtains an access token on behalf of a user.
///
/// Example usage:
/// ```dart
/// throw OnBehalfOfRequestException('Invalid token', code: 'invalid_token');
/// ```
class OnBehalfOfRequestException implements Exception {
  /// Error message describing the reason for the exception.
  final String message;

  /// Optional error code providing additional context for the error.
  final String? code;

  /// Optional additional details related to the error (e.g., response data, stack trace).
  final dynamic details;

  /// Creates an instance of [OnBehalfOfRequestException].
  ///
  /// - [message]: A descriptive error message.
  /// - [code]: An optional error code (e.g., 'invalid_token').
  /// - [details]: Additional information about the error, if available.
  OnBehalfOfRequestException(this.message, {this.code, this.details});

  @override
  String toString() => 'OnBehalfOfRequestException: $message (Code: $code)';
}

/// Handles the OAuth 2.0 On-Behalf-Of flow for delegated access scenarios
class AortemEntraIdOnBehalfOfRequest {
  final Logger _logger = Logger('AortemEntraIdOnBehalfOfRequest');

  /// Configuration for the request
  final AortemEntraIdAuthConfiguration configuration;

  /// Cache store for tokens
  final AortemEntraIdCacheKVStore _cacheStore;

  /// The user assertion (access token) to exchange
  final String userAssertion;

  /// The requested scopes
  final List<String> scopes;

  /// Creates a new instance of AortemEntraIdOnBehalfOfRequest
  AortemEntraIdOnBehalfOfRequest({
    required this.configuration,
    required AortemEntraIdCacheKVStore cacheStore,
    required this.userAssertion,
    required this.scopes,
  }) : _cacheStore = cacheStore {
    _validateRequest();
  }

  /// Validates the request parameters
  void _validateRequest() {
    if (userAssertion.isEmpty) {
      throw OnBehalfOfRequestException(
        'User assertion cannot be empty',
        code: 'invalid_assertion',
      );
    }

    if (scopes.isEmpty) {
      throw OnBehalfOfRequestException(
        'Scopes cannot be empty',
        code: 'invalid_scopes',
      );
    }

    _logger.info('OnBehalfOf request validated');
  }

  /// Executes the On-Behalf-Of token request
  Future<Map<String, dynamic>> executeRequest() async {
    try {
      // Check cache first
      final cachedToken = await _getCachedToken();
      if (cachedToken != null) {
        _logger.info('Retrieved token from cache');
        return cachedToken;
      }

      // Make token request
      final tokenResponse = await _exchangeToken();

      // Cache the response
      await _cacheToken(tokenResponse);

      return tokenResponse;
    } catch (e) {
      _logger.severe('Failed to execute OnBehalfOf request', e);
      throw OnBehalfOfRequestException(
        'Failed to execute OnBehalfOf request',
        code: 'request_failed',
        details: e,
      );
    }
  }

  /// Attempts to retrieve a cached token
  Future<Map<String, dynamic>?> _getCachedToken() async {
    final cacheKey = _generateCacheKey();
    return await _cacheStore.get(cacheKey);
  }

  /// Exchanges the user assertion for a new token
  Future<Map<String, dynamic>> _exchangeToken() async {
    // TODO: Implement token exchange logic
    // This would:
    // 1. Build token request with grant_type='urn:ietf:params:oauth:grant-type:jwt-bearer'
    // 2. Include the user assertion
    // 3. Make HTTP request to token endpoint
    // 4. Process and validate response
    throw UnimplementedError();
  }

  /// Caches the token response
  Future<void> _cacheToken(Map<String, dynamic> tokenResponse) async {
    final cacheKey = _generateCacheKey();
    await _cacheStore.set(cacheKey, tokenResponse);
  }

  /// Generates a cache key for the token
  String _generateCacheKey() {
    final scopeString = scopes.join(' ');
    return 'obo:${configuration.clientId}:$scopeString';
  }
}
