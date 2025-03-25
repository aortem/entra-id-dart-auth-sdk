import 'package:entra_id_dart_auth_sdk/utils/guid_generator.dart';
import 'package:logging/logging.dart';

/// Exception thrown when an error occurs during refresh token entity operations.
/// This is used to handle errors related to refresh token management, such as validation failures.
class RefreshTokenEntityException implements Exception {
  /// The error message describing what went wrong.
  final String message;

  /// An optional error code to categorize the exception.
  final String? code;

  /// Additional details about the error (e.g., stack trace or debug info).
  final dynamic details;

  /// Creates a new instance of [RefreshTokenEntityException].
  ///
  /// Takes a required [message] and optional [code] and [details].
  RefreshTokenEntityException(this.message, {this.code, this.details});

  /// Returns a string representation of the exception.
  @override
  String toString() => 'RefreshTokenEntityException: $message (Code: $code)';
}

/// Entity representing a refresh token and its metadata
class AortemEntraIdSerializedRefreshTokenEntity {
  final Logger _logger = Logger('AortemEntraIdSerializedRefreshTokenEntity');

  /// The refresh token value
  final String refreshToken;

  /// Client ID that the token was issued to
  final String clientId;

  /// User ID associated with the token
  final String? userId;

  /// Family ID for token chaining
  final String? familyId;

  /// Tenant ID where the token is valid
  final String tenantId;

  /// When the token was issued
  final DateTime issuedOn;

  /// Scopes associated with the token
  final List<String> scopes;

  /// Home account ID if available
  final String? homeAccountId;

  /// Environment the token was issued in
  final String environment;

  /// Realm for the token
  final String realm;

  /// Cache key for the token
  late final String cacheKey;

  /// Additional token metadata
  final Map<String, dynamic> metadata;

  /// Creates a new instance of AortemEntraIdSerializedRefreshTokenEntity
  AortemEntraIdSerializedRefreshTokenEntity({
    required this.refreshToken,
    required this.clientId,
    required this.tenantId,
    required this.issuedOn,
    required this.scopes,
    required this.environment,
    required this.realm,
    this.userId,
    this.familyId,
    this.homeAccountId,
    this.metadata = const {},
  }) {
    _validateEntity();
    cacheKey = _generateCacheKey();
  }

  /// Creates a refresh token entity from JSON
  factory AortemEntraIdSerializedRefreshTokenEntity.fromJson(
    Map<String, dynamic> json,
  ) {
    return AortemEntraIdSerializedRefreshTokenEntity(
      refreshToken: json['refreshToken'] as String,
      clientId: json['clientId'] as String,
      tenantId: json['tenantId'] as String,
      issuedOn: DateTime.parse(json['issuedOn'] as String),
      scopes: List<String>.from(json['scopes'] as List),
      environment: json['environment'] as String,
      realm: json['realm'] as String,
      userId: json['userId'] as String?,
      familyId: json['familyId'] as String?,
      homeAccountId: json['homeAccountId'] as String?,
      metadata: Map<String, dynamic>.from(
        json['metadata'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  /// Converts the entity to JSON
  Map<String, dynamic> toJson() {
    return {
      'refreshToken': refreshToken,
      'clientId': clientId,
      'tenantId': tenantId,
      'issuedOn': issuedOn.toUtc().toIso8601String(),
      'scopes': scopes,
      'environment': environment,
      'realm': realm,
      'userId': userId,
      'familyId': familyId,
      'homeAccountId': homeAccountId,
      'metadata': metadata,
      'cacheKey': cacheKey,
    };
  }

  /// Validates the entity's required fields
  void _validateEntity() {
    try {
      if (refreshToken.isEmpty) {
        throw RefreshTokenEntityException(
          'Refresh token cannot be empty',
          code: 'empty_token',
        );
      }
      if (clientId.isEmpty) {
        throw RefreshTokenEntityException(
          'Client ID cannot be empty',
          code: 'empty_client_id',
        );
      }
      if (tenantId.isEmpty) {
        throw RefreshTokenEntityException(
          'Tenant ID cannot be empty',
          code: 'empty_tenant_id',
        );
      }
      if (environment.isEmpty) {
        throw RefreshTokenEntityException(
          'Environment cannot be empty',
          code: 'empty_environment',
        );
      }
      if (realm.isEmpty) {
        throw RefreshTokenEntityException(
          'Realm cannot be empty',
          code: 'empty_realm',
        );
      }
      if (scopes.isEmpty) {
        throw RefreshTokenEntityException(
          'At least one scope is required',
          code: 'empty_scopes',
        );
      }

      _logger.fine('Refresh token entity validated successfully');
    } catch (e) {
      _logger.severe('Refresh token entity validation failed', e);
      rethrow;
    }
  }

  /// Generates a unique cache key for the token
  String _generateCacheKey() {
    final components = [
      'refresh_token',
      clientId,
      tenantId,
      if (userId != null) userId!,
      if (familyId != null) familyId!,
      environment,
      realm,
      AortemEntraIdGuidGenerator.generate(),
    ];

    return components.join(':');
  }

  /// Creates a copy of the entity with updated fields
  AortemEntraIdSerializedRefreshTokenEntity copyWith({
    String? refreshToken,
    String? clientId,
    String? tenantId,
    DateTime? issuedOn,
    List<String>? scopes,
    String? environment,
    String? realm,
    String? userId,
    String? familyId,
    String? homeAccountId,
    Map<String, dynamic>? metadata,
  }) {
    return AortemEntraIdSerializedRefreshTokenEntity(
      refreshToken: refreshToken ?? this.refreshToken,
      clientId: clientId ?? this.clientId,
      tenantId: tenantId ?? this.tenantId,
      issuedOn: issuedOn ?? this.issuedOn,
      scopes: scopes ?? this.scopes,
      environment: environment ?? this.environment,
      realm: realm ?? this.realm,
      userId: userId ?? this.userId,
      familyId: familyId ?? this.familyId,
      homeAccountId: homeAccountId ?? this.homeAccountId,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Whether this token is part of a token family
  bool get isInTokenFamily => familyId != null;

  /// Whether this token is associated with a specific user
  bool get isUserSpecific => userId != null;

  /// Gets the age of the token
  Duration get tokenAge => DateTime.now().toUtc().difference(issuedOn);

  /// Checks if the token has the required scopes
  bool hasScopes(List<String> requiredScopes) {
    return requiredScopes.every((scope) => scopes.contains(scope));
  }

  /// Gets a metadata value with optional default
  T? getMetadata<T>(String key, {T? defaultValue}) {
    return metadata[key] as T? ?? defaultValue;
  }

  /// Gets a formatted string representation of the entity
  @override
  String toString() {
    return 'RefreshToken(clientId: $clientId, '
        'userId: $userId, '
        'familyId: $familyId, '
        'issued: $issuedOn)';
  }
}
