import 'package:ds_standard_features/ds_standard_features.dart';

import '../exception/entra_id_serialized_id_token_exception.dart';

/// Entity representing a deserialized OpenID Connect ID token
class EntraIdSerializedIdTokenEntity {
  final Logger _logger = Logger('EntraIdSerializedIdTokenEntity');

  /// The raw ID token string
  final String rawIdToken;

  /// Issuer identifier (iss claim)
  final String issuer;

  /// Subject identifier (sub claim)
  final String subject;

  /// Client ID (aud claim)
  final String clientId;

  /// Token issuance time (iat claim)
  final DateTime issuedAt;

  /// Token expiration time (exp claim)
  final DateTime expiresOn;

  /// Nonce value (nonce claim)
  final String? nonce;

  /// User's name (name claim)
  final String? name;

  /// User's preferred username (preferred_username claim)
  final String? preferredUsername;

  /// User's email (email claim)
  final String? email;

  /// Whether email is verified (email_verified claim)
  final bool? emailVerified;

  /// Time when auth occurred (auth_time claim)
  final DateTime? authTime;

  /// Additional claims from the token
  final Map<String, dynamic> additionalClaims;

  /// Tenant ID where the token is valid
  final String tenantId;

  /// Cache key for the token
  late final String cacheKey;

  /// Creates a new instance of EntraIdSerializedIdTokenEntity
  EntraIdSerializedIdTokenEntity({
    required this.rawIdToken,
    required this.issuer,
    required this.subject,
    required this.clientId,
    required this.issuedAt,
    required this.expiresOn,
    required this.tenantId,
    this.nonce,
    this.name,
    this.preferredUsername,
    this.email,
    this.emailVerified,
    this.authTime,
    this.additionalClaims = const {},
  }) {
    validateEntity();
    cacheKey = generateCacheKey();
  }

  /// Creates an ID token entity from claims
  factory EntraIdSerializedIdTokenEntity.fromClaims(
    Map<String, dynamic> claims,
    String rawToken,
  ) {
    return EntraIdSerializedIdTokenEntity(
      rawIdToken: rawToken,
      issuer: claims['iss'] as String,
      subject: claims['sub'] as String,
      clientId: claims['aud'] as String,
      issuedAt: DateTime.fromMillisecondsSinceEpoch(
        (claims['iat'] as int) * 1000,
        isUtc: true,
      ),
      expiresOn: DateTime.fromMillisecondsSinceEpoch(
        (claims['exp'] as int) * 1000,
        isUtc: true,
      ),
      tenantId: extractTenantId(claims['iss'] as String),
      nonce: claims['nonce'] as String?,
      name: claims['name'] as String?,
      preferredUsername: claims['preferred_username'] as String?,
      email: claims['email'] as String?,
      emailVerified: claims['email_verified'] as bool?,
      authTime: claims['auth_time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (claims['auth_time'] as int) * 1000,
              isUtc: true,
            )
          : null,
      additionalClaims: Map<String, dynamic>.from(claims)
        ..removeWhere(
          (key, _) => [
            'iss',
            'sub',
            'aud',
            'exp',
            'iat',
            'nonce',
            'name',
            'preferred_username',
            'email',
            'email_verified',
            'auth_time',
          ].contains(key),
        ),
    );
  }

  /// Creates an ID token entity from JSON
  factory EntraIdSerializedIdTokenEntity.fromJson(
    Map<String, dynamic> json,
  ) {
    return EntraIdSerializedIdTokenEntity(
      rawIdToken: json['rawIdToken'] as String,
      issuer: json['issuer'] as String,
      subject: json['subject'] as String,
      clientId: json['clientId'] as String,
      issuedAt: DateTime.parse(json['issuedAt'] as String),
      expiresOn: DateTime.parse(json['expiresOn'] as String),
      tenantId: json['tenantId'] as String,
      nonce: json['nonce'] as String?,
      name: json['name'] as String?,
      preferredUsername: json['preferredUsername'] as String?,
      email: json['email'] as String?,
      emailVerified: json['emailVerified'] as bool?,
      authTime: json['authTime'] != null
          ? DateTime.parse(json['authTime'] as String)
          : null,
      additionalClaims: Map<String, dynamic>.from(
        json['additionalClaims'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  /// Converts the entity to JSON
  Map<String, dynamic> toJson() {
    return {
      'rawIdToken': rawIdToken,
      'issuer': issuer,
      'subject': subject,
      'clientId': clientId,
      'issuedAt': issuedAt.toUtc().toIso8601String(),
      'expiresOn': expiresOn.toUtc().toIso8601String(),
      'tenantId': tenantId,
      'nonce': nonce,
      'name': name,
      'preferredUsername': preferredUsername,
      'email': email,
      'emailVerified': emailVerified,
      'authTime': authTime?.toUtc().toIso8601String(),
      'additionalClaims': additionalClaims,
      'cacheKey': cacheKey,
    };
  }

  /// Whether the token has expired
  bool get isExpired => DateTime.now().toUtc().isAfter(expiresOn);

  /// Time until the token expires
  Duration get timeUntilExpiry => expiresOn.difference(DateTime.now().toUtc());

  /// Validates the entity's required fields
  void validateEntity() {
    try {
      if (rawIdToken.isEmpty) {
        throw IdTokenEntityException(
          'Raw ID token cannot be empty',
          code: 'empty_token',
        );
      }
      if (issuer.isEmpty) {
        throw IdTokenEntityException(
          'Issuer cannot be empty',
          code: 'empty_issuer',
        );
      }
      if (subject.isEmpty) {
        throw IdTokenEntityException(
          'Subject cannot be empty',
          code: 'empty_subject',
        );
      }
      if (clientId.isEmpty) {
        throw IdTokenEntityException(
          'Client ID cannot be empty',
          code: 'empty_client_id',
        );
      }
      if (tenantId.isEmpty) {
        throw IdTokenEntityException(
          'Tenant ID cannot be empty',
          code: 'empty_tenant_id',
        );
      }
      if (expiresOn.isBefore(issuedAt)) {
        throw IdTokenEntityException(
          'Expiration time cannot be before issuance time',
          code: 'invalid_expiry',
        );
      }

      _logger.fine('ID token entity validated successfully');
    } catch (e) {
      _logger.severe('ID token entity validation failed', e);
      rethrow;
    }
  }

  /// Generates a unique cache key for the token
  String generateCacheKey() {
    return 'id_token:$clientId:$subject:$tenantId';
  }

  /// Extracts tenant ID from issuer
  static String extractTenantId(String issuer) {
    try {
      final uri = Uri.parse(issuer);
      final pathSegments = uri.pathSegments;
      if (pathSegments.isEmpty) {
        throw IdTokenEntityException(
          'Could not extract tenant ID from issuer: $issuer',
          code: 'invalid_issuer',
        );
      }
      return pathSegments.first;
    } catch (e) {
      throw IdTokenEntityException(
        'Invalid issuer format',
        code: 'invalid_issuer_format',
        details: e,
      );
    }
  }

  /// Gets a custom claim value
  T? getClaim<T>(String claimName) {
    return additionalClaims[claimName] as T?;
  }

  /// Creates a copy of the entity with updated fields
  EntraIdSerializedIdTokenEntity copyWith({
    String? rawIdToken,
    String? issuer,
    String? subject,
    String? clientId,
    DateTime? issuedAt,
    DateTime? expiresOn,
    String? tenantId,
    String? nonce,
    String? name,
    String? preferredUsername,
    String? email,
    bool? emailVerified,
    DateTime? authTime,
    Map<String, dynamic>? additionalClaims,
  }) {
    return EntraIdSerializedIdTokenEntity(
      rawIdToken: rawIdToken ?? this.rawIdToken,
      issuer: issuer ?? this.issuer,
      subject: subject ?? this.subject,
      clientId: clientId ?? this.clientId,
      issuedAt: issuedAt ?? this.issuedAt,
      expiresOn: expiresOn ?? this.expiresOn,
      tenantId: tenantId ?? this.tenantId,
      nonce: nonce ?? this.nonce,
      name: name ?? this.name,
      preferredUsername: preferredUsername ?? this.preferredUsername,
      email: email ?? this.email,
      emailVerified: emailVerified ?? this.emailVerified,
      authTime: authTime ?? this.authTime,
      additionalClaims: additionalClaims ?? this.additionalClaims,
    );
  }

  /// Gets a formatted string representation of the entity
  @override
  String toString() {
    return 'IdToken(sub: $subject, '
        'name: $name, '
        'email: $email, '
        'expires: $expiresOn)';
  }
}
