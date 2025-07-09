import 'dart:async';

import 'package:entra_id_dart_auth_sdk/src/enum/aortem_entra_id_token_type_enum.dart';
import 'package:ds_standard_features/ds_standard_features.dart';

import '../exception/aortem_entra_id_token_cache_exception.dart';
import '../model/aortem_entra_id_token_cache_model.dart';
import '../utils/aortem_entra_id_guid_generator.dart';

/// Abstract base class for token cache implementations

abstract class AortemEntraIdTokenCache {
  final Logger _logger = Logger('AortemEntraIdTokenCache');

  /// Stream controller for cache events
  final _changeController = StreamController<String>.broadcast();

  /// Stream of cache change events
  Stream<String> get changes => _changeController.stream;

  /// Saves a token to the cache
  Future<void> saveToken(CachedToken token);

  /// Gets a token from the cache
  Future<CachedToken?> getToken({
    required TokenType tokenType,
    required String clientId,
    String? userId,
    List<String>? scopes,
  });

  /// Removes a token from the cache
  Future<void> removeToken({
    required TokenType tokenType,
    required String clientId,
    String? userId,
    List<String>? scopes,
  });

  /// Gets all tokens matching the criteria
  Future<List<CachedToken>> findTokens({
    TokenType? tokenType,
    String? clientId,
    String? userId,
    List<String>? scopes,
  });

  /// Clears all tokens from the cache
  Future<void> clear();

  /// Gets all tokens for a user
  Future<List<CachedToken>> getTokensForUser(String userId) {
    return findTokens(userId: userId);
  }

  /// Gets all tokens for a client
  Future<List<CachedToken>> getTokensForClient(String clientId) {
    return findTokens(clientId: clientId);
  }

  /// Removes expired tokens from the cache
  Future<void> removeExpiredTokens();

  /// Gets stats about the cache
  Future<Map<String, dynamic>> getCacheStats();

  /// Generates a unique cache key for a token
  String generateCacheKey({
    required TokenType tokenType,
    required String clientId,
    String? userId,
    List<String>? scopes,
  }) {
    final components = [
      tokenType.toString(),
      clientId,
      if (userId != null) userId,
      if (scopes != null && scopes.isNotEmpty) scopes.join(' '),
      AortemEntraIdGuidGenerator.generate(),
    ];

    return components.join(':');
  }

  /// Validates a cached token
  bool validateToken(CachedToken token) {
    if (token.token.isEmpty) {
      throw TokenCacheException(
        'Token value cannot be empty',
        code: 'empty_token',
      );
    }

    if (token.clientId.isEmpty) {
      throw TokenCacheException(
        'Client ID cannot be empty',
        code: 'empty_client_id',
      );
    }

    if (token.scopes.isEmpty) {
      throw TokenCacheException(
        'Token must have at least one scope',
        code: 'empty_scopes',
      );
    }

    return true;
  }

  /// Notifies listeners of cache changes
  void notifyChange(String changeType) {
    _changeController.add(changeType);
    _logger.fine('Cache change notification: $changeType');
  }

  /// Disposes of cache resources
  void dispose() {
    _changeController.close();
    _logger.info('Token cache disposed');
  }
}
