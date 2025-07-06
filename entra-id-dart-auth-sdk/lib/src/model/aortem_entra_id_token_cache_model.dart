import 'package:entra_id_dart_auth_sdk/src/enum/aortem_entra_id_token_type_enum.dart';

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
