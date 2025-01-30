import 'package:logging/logging.dart';
import '../auth_entra_id_configuration.dart';
import '../auth_entra_id_cache_kvstore.dart';

/// Exception for silent flow request errors
class SilentFlowRequestException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  SilentFlowRequestException(this.message, {this.code, this.details});

  @override
  String toString() => 'SilentFlowRequestException: $message (Code: $code)';
}

/// Handles silent token acquisition using cached refresh tokens
class AortemEntraIdSilentFlowRequest {
  final Logger _logger = Logger('AortemEntraIdSilentFlowRequest');

  /// Configuration for the request
  final AortemEntraIdConfiguration configuration;

  /// Cache store for tokens
  final AortemEntraIdCacheKVStore _cacheStore;

  /// The requested scopes
  final List<String> scopes;

  /// Account identifier (optional)
  final String? accountId;

  /// Authority to use for the request (optional)
  final String? authority;

  /// Creates a new instance of AortemEntraIdSilentFlowRequest
  AortemEntraIdSilentFlowRequest({
    required this.configuration,
    required AortemEntraIdCacheKVStore cacheStore,
    required this.scopes,
    this.accountId,
    this.authority,
  }) : _cacheStore = cacheStore {
    _validateRequest();
  }

  /// Validates the request parameters
  void _validateRequest() {
    if (scopes.isEmpty) {
      throw SilentFlowRequestException(
        'Scopes cannot be empty',
        code: 'invalid_scopes',
      );
    }

    _logger.info('Silent flow request validated');
  }

  /// Executes the silent token request
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

  /// Retrieves cached access token
  Future<Map<String, dynamic>?> _getCachedAccessToken() async {
    final cacheKey = _generateAccessTokenCacheKey();
    return await _cacheStore.get(cacheKey);
  }

  /// Retrieves cached refresh token
  Future<String?> _getCachedRefreshToken() async {
    final cacheKey = _generateRefreshTokenCacheKey();
    final tokenData = await _cacheStore.get(cacheKey);
    return tokenData?['refresh_token'];
  }

  /// Checks if a token is expired
  bool _isTokenExpired(Map<String, dynamic> token) {
    final expiresIn = token['expires_in'] as int?;
    final createdAt = token['created_at'] as int?;

    if (expiresIn == null || createdAt == null) {
      return true;
    }

    final expirationTime = DateTime.fromMillisecondsSinceEpoch(createdAt)
        .add(Duration(seconds: expiresIn));

    // Add buffer time of 5 minutes
    return DateTime.now().add(Duration(minutes: 5)).isAfter(expirationTime);
  }

  /// Refreshes the token using a refresh token
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

  /// Generates cache key for access tokens
  String _generateAccessTokenCacheKey() {
    final scopeString = scopes.join(' ');
    final accountSuffix = accountId != null ? ':$accountId' : '';
    return 'access:${configuration.clientId}:$scopeString$accountSuffix';
  }

  /// Generates cache key for refresh tokens
  String _generateRefreshTokenCacheKey() {
    final accountSuffix = accountId != null ? ':$accountId' : '';
    return 'refresh:${configuration.clientId}$accountSuffix';
  }
}
