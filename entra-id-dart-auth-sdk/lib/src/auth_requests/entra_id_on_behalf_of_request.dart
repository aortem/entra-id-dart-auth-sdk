import 'package:entra_id_dart_auth_sdk/src/exception/entra_id_on_behalf_of_request_exception.dart';
import 'package:ds_standard_features/ds_standard_features.dart';

import '../cache/entra_id_cache_kv_store.dart';
import '../config/entra_id_configuration.dart';

/// Handles the OAuth 2.0 On-Behalf-Of flow for delegated access scenarios
class AortemEntraIdOnBehalfOfRequest {
  final Logger _logger = Logger('AortemEntraIdOnBehalfOfRequest');

  /// Configuration for the request
  final AortemEntraIdConfiguration configuration;

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
      final cachedToken = await getCachedToken();
      if (cachedToken != null) {
        _logger.info('Retrieved token from cache');
        return cachedToken;
      }

      // Make token request
      final tokenResponse = await _exchangeToken();

      // Cache the response
      await cacheToken(tokenResponse);

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
  Future<Map<String, dynamic>?> getCachedToken() async {
    final cacheKey = generateCacheKey();
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
  Future<void> cacheToken(Map<String, dynamic> tokenResponse) async {
    final cacheKey = generateCacheKey();
    await _cacheStore.set(cacheKey, tokenResponse);
  }

  /// Generates a cache key for the token
  String generateCacheKey() {
    final scopeString = scopes.join(' ');
    return 'obo:${configuration.clientId}:$scopeString';
  }
}
