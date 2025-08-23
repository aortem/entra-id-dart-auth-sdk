import 'package:logging/logging.dart';
import '../entra_id_auth_configuration.dart';
import '../entra_id_auth_cache_kvstore.dart';

/// Exception for silent flow request errors.
///
/// This exception is thrown when a silent authentication request fails due to
/// missing tokens, invalid scopes, or any other unexpected issue.
class SilentFlowRequestException implements Exception {
  /// Error message describing the failure.
  final String message;

  /// Optional error code for categorizing the failure.
  final String? code;

  /// Additional details related to the exception.
  final dynamic details;

  /// Constructs a [SilentFlowRequestException] with a message and optional details.
  SilentFlowRequestException(this.message, {this.code, this.details});

  @override
  String toString() => 'SilentFlowRequestException: $message (Code: $code)';
}

/// Handles silent token acquisition using cached refresh tokens.
///
/// This class attempts to retrieve a valid access token from the cache.
/// If no valid token is found, it attempts to refresh the token using
/// the refresh token stored in cache.
class EntraIdSilentFlowRequest {
  /// Logger instance for tracking silent authentication flow.
  final Logger _logger = Logger('EntraIdSilentFlowRequest');

  /// Configuration for the request.
  final EntraIdAuthConfiguration configuration;

  /// Cache store for token storage and retrieval.
  final EntraIdCacheKVStore _cacheStore;

  /// The requested authentication scopes.
  final List<String> scopes;

  /// Optional account identifier for multi-account scenarios.
  final String? accountId;

  /// Optional authority URL for token requests.
  final String? authority;

  /// Creates an instance of [EntraIdSilentFlowRequest].
  ///
  /// Ensures that the request parameters are valid before proceeding.
  EntraIdSilentFlowRequest({
    required this.configuration,
    required EntraIdCacheKVStore cacheStore,
    required this.scopes,
    this.accountId,
    this.authority,
  }) : _cacheStore = cacheStore {
    _validateRequest();
  }

  /// Validates request parameters before executing the silent token request.
  void _validateRequest() {
    if (scopes.isEmpty) {
      throw SilentFlowRequestException(
        'Scopes cannot be empty',
        code: 'invalid_scopes',
      );
    }
    _logger.info('Silent flow request validated');
  }

  /// Executes the silent authentication request.
  ///
  /// Attempts to retrieve a valid access token from cache. If unavailable,
  /// tries to refresh the token using the refresh token.
  ///
  /// Throws [SilentFlowRequestException] if authentication fails.
  Future<Map<String, dynamic>> executeRequest() async {
    try {
      // Try to get token from cache
      final cachedToken = await _getCachedAccessToken();
      if (cachedToken != null && !_isTokenExpired(cachedToken)) {
        _logger.info('Retrieved valid token from cache');
        return cachedToken;
      }

      // Try to refresh the token
      final refreshToken = await _getCachedRefreshToken();
      if (refreshToken != null) {
        _logger.info('Attempting token refresh');
        return await _refreshToken(refreshToken);
      }

      throw SilentFlowRequestException(
        'No cached tokens available',
        code: 'no_tokens',
      );
    } catch (e) {
      _logger.severe('Failed to execute silent flow request', e);
      throw SilentFlowRequestException(
        'Failed to execute silent flow request',
        code: 'request_failed',
        details: e,
      );
    }
  }

  /// Retrieves the cached access token from storage.
  Future<Map<String, dynamic>?> _getCachedAccessToken() async {
    final cacheKey = _generateAccessTokenCacheKey();
    return await _cacheStore.get(cacheKey);
  }

  /// Retrieves the cached refresh token from storage.
  Future<String?> _getCachedRefreshToken() async {
    final cacheKey = _generateRefreshTokenCacheKey();
    final tokenData = await _cacheStore.get(cacheKey);
    return tokenData?['refresh_token'];
  }

  /// Determines if the token has expired.
  bool _isTokenExpired(Map<String, dynamic> token) {
    final expiresIn = token['expires_in'] as int?;
    final createdAt = token['created_at'] as int?;

    if (expiresIn == null || createdAt == null) {
      return true;
    }

    final expirationTime = DateTime.fromMillisecondsSinceEpoch(
      createdAt,
    ).add(Duration(seconds: expiresIn));

    // Add buffer time of 5 minutes to prevent using a nearly expired token
    return DateTime.now().add(Duration(minutes: 5)).isAfter(expirationTime);
  }

  /// Refreshes the access token using a stored refresh token.
  ///
  /// Throws [SilentFlowRequestException] if the refresh operation fails.
  Future<Map<String, dynamic>> _refreshToken(String refreshToken) async {
    try {
      // TODO: Implement token refresh logic
      // This would:
      // 1. Build refresh token request
      // 2. Make HTTP request to token endpoint
      // 3. Process and validate response
      // 4. Cache new tokens
      throw UnimplementedError();
    } catch (e) {
      throw SilentFlowRequestException(
        'Token refresh failed',
        code: 'refresh_failed',
        details: e,
      );
    }
  }

  /// Generates a cache key for storing and retrieving access tokens.
  String _generateAccessTokenCacheKey() {
    final scopeString = scopes.join(' ');
    final accountSuffix = accountId != null ? ':$accountId' : '';
    return 'access:${configuration.clientId}:$scopeString$accountSuffix';
  }

  /// Generates a cache key for storing and retrieving refresh tokens.
  String _generateRefreshTokenCacheKey() {
    final accountSuffix = accountId != null ? ':$accountId' : '';
    return 'refresh:${configuration.clientId}$accountSuffix';
  }
}
