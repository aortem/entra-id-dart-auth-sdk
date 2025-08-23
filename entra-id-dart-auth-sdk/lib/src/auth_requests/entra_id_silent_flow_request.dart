import 'dart:convert';

import 'package:ds_standard_features/ds_standard_features.dart'
    as http
    show post;
import 'package:entra_id_dart_auth_sdk/src/exception/entra_id_silent_flow_request_exception.dart';
import 'package:ds_standard_features/ds_standard_features.dart';

import '../cache/entra_id_cache_kv_store.dart';
import '../config/entra_id_configuration.dart';

/// Handles silent token acquisition using cached refresh tokens
class EntraIdSilentFlowRequest {
  final Logger _logger = Logger('EntraIdSilentFlowRequest');

  /// Configuration for the request
  final EntraIdConfiguration configuration;

  /// Cache store for tokens
  final EntraIdCacheKVStore _cacheStore;

  /// The requested scopes
  final List<String> scopes;

  /// Account identifier (optional)
  final String? accountId;

  /// Authority to use for the request (optional)
  final String? authority;

  /// Creates a new instance of EntraIdSilentFlowRequest
  EntraIdSilentFlowRequest({
    required this.configuration,
    required EntraIdCacheKVStore cacheStore,
    required this.scopes,
    this.accountId,
    this.authority,
  }) : _cacheStore = cacheStore {
    validateRequest();
  }

  /// Validates the request parameters
  void validateRequest() {
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
      final cachedToken = await getCachedAccessToken();
      if (cachedToken != null && !isTokenExpired(cachedToken)) {
        _logger.info('Retrieved valid token from cache');
        return cachedToken;
      }

      // Try to refresh the token
      final refreshToken = await getCachedRefreshToken();
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
  Future<Map<String, dynamic>?> getCachedAccessToken() async {
    final cacheKey = generateAccessTokenCacheKey();
    return await _cacheStore.get(cacheKey);
  }

  /// Retrieves cached refresh token
  Future<String?> getCachedRefreshToken() async {
    final cacheKey = generateRefreshTokenCacheKey();
    final tokenData = await _cacheStore.get(cacheKey);
    return tokenData?['refresh_token'];
  }

  /// Checks if a token is expired
  bool isTokenExpired(Map<String, dynamic> token) {
    final expiresIn = token['expires_in'] as int?;
    final createdAt = token['created_at'] as int?;

    if (expiresIn == null || createdAt == null) {
      return true;
    }

    final expirationTime = DateTime.fromMillisecondsSinceEpoch(
      createdAt,
    ).add(Duration(seconds: expiresIn));

    // Add buffer time of 5 minutes
    return DateTime.now().add(Duration(minutes: 5)).isAfter(expirationTime);
  }

  /// Refreshes the token using a refresh token
  Future<Map<String, dynamic>> _refreshToken(String refreshToken) async {
    try {
      // Build the refresh token request payload
      final requestBody = {
        'client_id': configuration.clientId,
        'refresh_token': refreshToken,
        'grant_type': 'refresh_token',
        'scope': scopes.join(' '),
      };

      // Make HTTP request to token endpoint
      final response = await http.post(
        Uri.parse('$authority/oauth2/v2.0/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: requestBody,
      );

      // Handle the response
      if (response.statusCode == 200) {
        _logger.info('Token refresh successful');
        final responseBody = jsonDecode(response.body);
        // Cache the new access token and refresh token
        await _cacheStore.set(generateAccessTokenCacheKey(), responseBody);
        await _cacheStore.set(generateRefreshTokenCacheKey(), responseBody);
        return responseBody;
      } else {
        throw SilentFlowRequestException(
          'Token refresh failed',
          code: 'refresh_failed',
          details: response.body,
        );
      }
    } catch (e) {
      _logger.severe('Token refresh request failed', e);
      throw SilentFlowRequestException(
        'Token refresh failed',
        code: 'refresh_failed',
        details: e,
      );
    }
  }

  /// Generates cache key for access tokens
  String generateAccessTokenCacheKey() {
    final scopeString = scopes.join(' ');
    final accountSuffix = accountId != null ? ':$accountId' : '';
    return 'access:${configuration.clientId}:$scopeString$accountSuffix';
  }

  /// Generates cache key for refresh tokens
  String generateRefreshTokenCacheKey() {
    final accountSuffix = accountId != null ? ':$accountId' : '';
    return 'refresh:${configuration.clientId}$accountSuffix';
  }
}
