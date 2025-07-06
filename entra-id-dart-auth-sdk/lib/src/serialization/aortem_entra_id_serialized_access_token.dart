import 'package:logging/logging.dart';

import '../exception/aortem_entra_id_serialized_access_token_exception.dart';
import '../utils/aortem_entra_id_guid_generator.dart';

/// Represents a serialized access token with its metadata
class AortemEntraIdSerializedAccessTokenEntity {
  final Logger _logger = Logger('AortemEntraIdSerializedAccessTokenEntity');

  /// The access token value
  final String accessToken;

  /// Client ID that the token was issued to
  final String clientId;

  /// When the token was issued (in UTC)
  final DateTime issuedOn;

  /// When the token expires (in UTC)
  final DateTime expiresOn;

  /// Token type (e.g., "Bearer")
  final String tokenType;

  /// Token scopes
  final List<String> scopes;

  /// User ID associated with the token (if applicable)
  final String? userId;

  /// Tenant ID where the token is valid
  final String tenantId;

  /// Realm/authority that issued the token
  final String authority;

  /// Cache key for the token
  late final String cacheKey;

  /// Additional claims from the token
  final Map<String, dynamic> claims;

  /// Whether this token can be refreshed
  final bool isRefreshable;

  /// Resource the token is valid for
  final String? resource;

  /// Cache expiry time (may differ from token expiry)
  final DateTime? cacheExpiresOn;

  /// Extended properties for future use
  final Map<String, dynamic> extendedProperties;

  /// Creates a new instance of AortemEntraIdSerializedAccessTokenEntity
  AortemEntraIdSerializedAccessTokenEntity({
    required this.accessToken,
    required this.clientId,
    required this.issuedOn,
    required this.expiresOn,
    required this.tokenType,
    required this.scopes,
    required this.tenantId,
    required this.authority,
    this.userId,
    this.resource,
    this.cacheExpiresOn,
    this.claims = const {},
    this.isRefreshable = false,
    this.extendedProperties = const {},
  }) {
    _validateEntity();
    cacheKey = _generateCacheKey();
  }

  /// Creates an access token entity from JSON
  factory AortemEntraIdSerializedAccessTokenEntity.fromJson(
    Map<String, dynamic> json,
  ) {
    return AortemEntraIdSerializedAccessTokenEntity(
      accessToken: json['accessToken'] as String,
      clientId: json['clientId'] as String,
      issuedOn: DateTime.parse(json['issuedOn'] as String),
      expiresOn: DateTime.parse(json['expiresOn'] as String),
      tokenType: json['tokenType'] as String,
      scopes: List<String>.from(json['scopes'] as List),
      tenantId: json['tenantId'] as String,
      authority: json['authority'] as String,
      userId: json['userId'] as String?,
      resource: json['resource'] as String?,
      cacheExpiresOn:
          json['cacheExpiresOn'] != null
              ? DateTime.parse(json['cacheExpiresOn'] as String)
              : null,
      claims: Map<String, dynamic>.from(
        json['claims'] as Map<String, dynamic>? ?? {},
      ),
      isRefreshable: json['isRefreshable'] as bool? ?? false,
      extendedProperties: Map<String, dynamic>.from(
        json['extendedProperties'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  /// Converts the entity to JSON
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'clientId': clientId,
      'issuedOn': issuedOn.toUtc().toIso8601String(),
      'expiresOn': expiresOn.toUtc().toIso8601String(),
      'tokenType': tokenType,
      'scopes': scopes,
      'tenantId': tenantId,
      'authority': authority,
      'userId': userId,
      'resource': resource,
      'cacheExpiresOn': cacheExpiresOn?.toUtc().toIso8601String(),
      'claims': claims,
      'isRefreshable': isRefreshable,
      'extendedProperties': extendedProperties,
      'cacheKey': cacheKey,
    };
  }

  /// Whether the token has expired
  bool get isExpired => DateTime.now().toUtc().isAfter(expiresOn);

  /// Time until the token expires
  Duration get timeUntilExpiry => expiresOn.difference(DateTime.now().toUtc());

  /// Whether the token is expired in cache
  bool get isCacheExpired {
    if (cacheExpiresOn == null) return isExpired;
    return DateTime.now().toUtc().isAfter(cacheExpiresOn!);
  }

  /// Whether the token is a bearer token
  bool get isBearer => tokenType.toLowerCase() == 'bearer';

  /// Validates the entity's required fields
  void _validateEntity() {
    try {
      if (accessToken.isEmpty) {
        throw AccessTokenEntityException(
          'Access token cannot be empty',
          code: 'empty_token',
        );
      }
      if (clientId.isEmpty) {
        throw AccessTokenEntityException(
          'Client ID cannot be empty',
          code: 'empty_client_id',
        );
      }
      if (scopes.isEmpty) {
        throw AccessTokenEntityException(
          'At least one scope is required',
          code: 'empty_scopes',
        );
      }
      if (tenantId.isEmpty) {
        throw AccessTokenEntityException(
          'Tenant ID cannot be empty',
          code: 'empty_tenant_id',
        );
      }
      if (authority.isEmpty) {
        throw AccessTokenEntityException(
          'Authority cannot be empty',
          code: 'empty_authority',
        );
      }
      if (expiresOn.isBefore(issuedOn)) {
        throw AccessTokenEntityException(
          'Expiration time cannot be before issuance time',
          code: 'invalid_expiry',
        );
      }

      _logger.fine('Access token entity validated successfully');
    } catch (e) {
      _logger.severe('Access token entity validation failed', e);
      rethrow;
    }
  }

  /// Generates a unique cache key for the token
  String _generateCacheKey() {
    final components = [
      clientId,
      tenantId,
      if (userId != null) userId!,
      if (resource != null) resource!,
      scopes.join(' '),
      AortemEntraIdGuidGenerator.generate(),
    ];

    return components.join(':');
  }

  /// Creates a copy of the entity with updated fields
  AortemEntraIdSerializedAccessTokenEntity copyWith({
    String? accessToken,
    String? clientId,
    DateTime? issuedOn,
    DateTime? expiresOn,
    String? tokenType,
    List<String>? scopes,
    String? tenantId,
    String? authority,
    String? userId,
    String? resource,
    DateTime? cacheExpiresOn,
    Map<String, dynamic>? claims,
    bool? isRefreshable,
    Map<String, dynamic>? extendedProperties,
  }) {
    return AortemEntraIdSerializedAccessTokenEntity(
      accessToken: accessToken ?? this.accessToken,
      clientId: clientId ?? this.clientId,
      issuedOn: issuedOn ?? this.issuedOn,
      expiresOn: expiresOn ?? this.expiresOn,
      tokenType: tokenType ?? this.tokenType,
      scopes: scopes ?? this.scopes,
      tenantId: tenantId ?? this.tenantId,
      authority: authority ?? this.authority,
      userId: userId ?? this.userId,
      resource: resource ?? this.resource,
      cacheExpiresOn: cacheExpiresOn ?? this.cacheExpiresOn,
      claims: claims ?? this.claims,
      isRefreshable: isRefreshable ?? this.isRefreshable,
      extendedProperties: extendedProperties ?? this.extendedProperties,
    );
  }

  /// Checks if the token has the required scopes
  bool hasScopes(List<String> requiredScopes) {
    return requiredScopes.every((scope) => scopes.contains(scope));
  }

  /// Gets a formatted string representation of the token
  @override
  String toString() {
    return 'AccessToken(clientId: $clientId, '
        'userId: $userId, '
        'scopes: ${scopes.join(" ")}, '
        'expires: $expiresOn)';
  }
}
