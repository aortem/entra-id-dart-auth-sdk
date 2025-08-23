import 'dart:async';
import 'package:entra_id_dart_auth_sdk/src/utils/entra_id_guid_generator.dart';
import 'package:logging/logging.dart';

/// Types of tokens that can be stored in the cache
enum TokenType {
  /// Access tokens for resource access
  accessToken,

  /// Refresh tokens for token renewal
  refreshToken,

  /// ID tokens containing user claims
  idToken,
}

/// Represents a cached token with metadata
class CachedToken {
  /// The token value
  final String token;

  /// Type of token
  final TokenType tokenType;

  /// When the token expires
  final DateTime expiresOn;

  /// Associated client ID
  final String clientId;

  /// Associated user identifier (if applicable)
  final String? userId;

  /// Token scope(s)
  final List<String> scopes;

  /// Additional token metadata
  final Map<String, dynamic> metadata;

  /// Creates a new instance of CachedToken
  CachedToken({
    required this.token,
    required this.tokenType,
    required this.expiresOn,
    required this.clientId,
    this.userId,
    required this.scopes,
    this.metadata = const {},
  });

  /// Whether the token has expired
  bool get isExpired => DateTime.now().isAfter(expiresOn);

  /// Creates a CachedToken from JSON
  factory CachedToken.fromJson(Map<String, dynamic> json) {
    return CachedToken(
      token: json['token'] as String,
      tokenType: TokenType.values.firstWhere(
        (t) => t.toString() == json['tokenType'],
      ),
      expiresOn: DateTime.parse(json['expiresOn'] as String),
      clientId: json['clientId'] as String,
      userId: json['userId'] as String?,
      scopes: List<String>.from(json['scopes'] as List),
      metadata: Map<String, dynamic>.from(
        json['metadata'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  /// Converts the token to JSON
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'tokenType': tokenType.toString(),
      'expiresOn': expiresOn.toIso8601String(),
      'clientId': clientId,
      'userId': userId,
      'scopes': scopes,
      'metadata': metadata,
    };
  }
}

/// Exception thrown for token cache operations
/// Exception thrown for errors related to token cache operations.
/// This exception is used to handle issues that occur while storing,
/// retrieving, or managing cached authentication tokens.
class TokenCacheException implements Exception {
  /// The error message describing the issue.
  final String message;

  /// An optional error code to categorize the error.
  final String? code;

  /// Additional details about the error, such as debug information or stack trace.
  final dynamic details;

  /// Creates a new instance of [TokenCacheException].
  ///
  /// - [message]: A required description of the error.
  /// - [code]: An optional identifier for the error type.
  /// - [details]: Optional extra details related to the error, such as a stack trace.
  TokenCacheException(this.message, {this.code, this.details});

  /// Returns a string representation of the exception, including the error message and optional code.
  @override
  String toString() => 'TokenCacheException: $message (Code: $code)';
}

/// Abstract base class for token cache implementations
abstract class EntraIdTokenCache {
  final Logger _logger = Logger('EntraIdTokenCache');

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
      EntraIdGuidGenerator.generate(),
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
