import 'dart:async';
import 'package:entra_id_dart_auth_sdk/src/enum/aortem_entra_id_token_type_enum.dart';
import 'package:ds_standard_features/ds_standard_features.dart';

import '../model/aortem_entra_id_in_memory_cache_model.dart';
import '../model/aortem_entra_id_token_cache_model.dart';
import 'aortem_entra_id_token_cache.dart';

/// Implements an in-memory token cache
class AortemEntraIdInMemoryCache extends AortemEntraIdTokenCache {
  final Logger _logger = Logger('AortemEntraIdInMemoryCache');

  /// The cache configuration
  final InMemoryCacheConfig config;

  /// Internal storage for tokens
  final Map<String, CachedToken> _tokenStorage = {};

  /// Timer for automatic cleanup
  Timer? _cleanupTimer;

  /// Creates a new instance of AortemEntraIdInMemoryCache
  AortemEntraIdInMemoryCache({InMemoryCacheConfig? config})
    : config = config ?? InMemoryCacheConfig() {
    if (this.config.enableAutomaticCleanup) {
      _startCleanupTimer();
    }
    _logger.info('Initialized in-memory token cache');
  }

  @override
  Future<void> saveToken(CachedToken token) async {
    // Validate the token
    validateToken(token);

    // Check capacity before saving
    if (_tokenStorage.length >= config.maxTokens) {
      await _evictTokens();
    }

    // Generate unique key and save token
    final key = generateCacheKey(
      tokenType: token.tokenType,
      clientId: token.clientId,
      userId: token.userId,
      scopes: token.scopes,
    );

    _tokenStorage[key] = token;
    notifyChange('token_saved');
    _logger.fine('Token saved to cache with key: $key');
  }

  @override
  Future<CachedToken?> getToken({
    required TokenType tokenType,
    required String clientId,
    String? userId,
    List<String>? scopes,
  }) async {
    final matches = await findTokens(
      tokenType: tokenType,
      clientId: clientId,
      userId: userId,
      scopes: scopes,
    );

    // Return the most recently cached non-expired token
    final validTokens = matches.where((token) => !token.isExpired);
    if (validTokens.isEmpty) {
      _logger.fine('No valid token found in cache');
      return null;
    }

    return validTokens.reduce(
      (a, b) => a.expiresOn.isAfter(b.expiresOn) ? a : b,
    );
  }

  @override
  Future<void> removeToken({
    required TokenType tokenType,
    required String clientId,
    String? userId,
    List<String>? scopes,
  }) async {
    final tokensToRemove =
        _tokenStorage.entries
            .where(
              (entry) => _matchesFilter(
                entry.value,
                tokenType: tokenType,
                clientId: clientId,
                userId: userId,
                scopes: scopes,
              ),
            )
            .map((e) => e.key)
            .toList();

    for (final key in tokensToRemove) {
      _tokenStorage.remove(key);
    }

    if (tokensToRemove.isNotEmpty) {
      notifyChange('tokens_removed');
      _logger.fine('Removed ${tokensToRemove.length} tokens from cache');
    }
  }

  @override
  Future<List<CachedToken>> findTokens({
    TokenType? tokenType,
    String? clientId,
    String? userId,
    List<String>? scopes,
  }) async {
    return _tokenStorage.values
        .where(
          (token) => _matchesFilter(
            token,
            tokenType: tokenType,
            clientId: clientId,
            userId: userId,
            scopes: scopes,
          ),
        )
        .toList();
  }

  @override
  Future<void> clear() async {
    _tokenStorage.clear();
    notifyChange('cache_cleared');
    _logger.info('Cache cleared');
  }

  @override
  Future<void> removeExpiredTokens() async {
    final now = DateTime.now();
    final expiredKeys =
        _tokenStorage.entries
            .where((entry) => entry.value.expiresOn.isBefore(now))
            .map((e) => e.key)
            .toList();

    for (final key in expiredKeys) {
      _tokenStorage.remove(key);
    }

    if (expiredKeys.isNotEmpty) {
      notifyChange('expired_tokens_removed');
      _logger.fine('Removed ${expiredKeys.length} expired tokens');
    }
  }

  @override
  Future<Map<String, dynamic>> getCacheStats() async {
    final now = DateTime.now();
    final total = _tokenStorage.length;
    final expired =
        _tokenStorage.values
            .where((token) => token.expiresOn.isBefore(now))
            .length;

    return {
      'totalTokens': total,
      'expiredTokens': expired,
      'activeTokens': total - expired,
      'cacheSize': total,
      'maxSize': config.maxTokens,
    };
  }

  /// Starts the automatic cleanup timer
  void _startCleanupTimer() {
    _cleanupTimer?.cancel();
    _cleanupTimer = Timer.periodic(
      config.cleanupInterval,
      (_) => removeExpiredTokens(),
    );
    _logger.info(
      'Started cleanup timer with interval: ${config.cleanupInterval.inMinutes}m',
    );
  }

  /// Evicts tokens when cache is full
  Future<void> _evictTokens() async {
    // First try to remove expired tokens
    await removeExpiredTokens();

    // If still at capacity, remove oldest tokens
    if (_tokenStorage.length >= config.maxTokens) {
      final tokens =
          _tokenStorage.entries.toList()
            ..sort((a, b) => a.value.expiresOn.compareTo(b.value.expiresOn));

      // Remove 10% of oldest tokens
      final removeCount = (config.maxTokens * 0.1).ceil();
      for (var i = 0; i < removeCount && i < tokens.length; i++) {
        _tokenStorage.remove(tokens[i].key);
      }

      notifyChange('tokens_evicted');
      _logger.info('Evicted $removeCount tokens due to capacity limits');
    }
  }

  /// Checks if a token matches the given filter criteria
  bool _matchesFilter(
    CachedToken token, {
    TokenType? tokenType,
    String? clientId,
    String? userId,
    List<String>? scopes,
  }) {
    if (tokenType != null && token.tokenType != tokenType) return false;
    if (clientId != null && token.clientId != clientId) return false;
    if (userId != null && token.userId != userId) return false;
    if (scopes != null && scopes.isNotEmpty) {
      return scopes.every((scope) => token.scopes.contains(scope));
    }
    return true;
  }

  @override
  void dispose() {
    _cleanupTimer?.cancel();
    _tokenStorage.clear();
    super.dispose();
    _logger.info('In-memory cache disposed');
  }
}
