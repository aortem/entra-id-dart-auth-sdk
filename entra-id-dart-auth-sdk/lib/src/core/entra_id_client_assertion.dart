import 'package:jwt_generator/jwt_generator.dart';

/// Generates client assertions for confidential client authentication with Entra ID.
///
/// This class creates signed JWTs that securely authenticate client applications
/// with Entra ID. It requires the client ID, tenant ID, and a private key in PEM format.
/// Optionally, a certificate thumbprint can be provided for certificate-based authentication.
class AortemEntraIdClientAssertion {
  /// The client ID of the application registered in Entra ID.
  final String clientId;

  /// The tenant ID or domain of the Entra ID tenant.
  final String tenantId;

  /// The private key used to sign the client assertion, in PEM format.
  final String privateKey;

  /// The thumbprint of the certificate, required for certificate authentication.
  final String? certificateThumbprint;

  /// The audience for the client assertion, typically the token endpoint URL.
  final String audience;

  /// Creates an instance of [AortemEntraIdClientAssertion].
  ///
  /// The [clientId], [tenantId], and [privateKey] parameters are required.
  /// The [certificateThumbprint] is optional and used for certificate-based authentication.
  /// The [audience] parameter specifies the intended recipient of the assertion; if not provided,
  /// it defaults to 'https://login.microsoftonline.com/{tenantId}/oauth2/v2.0/token'.
  ///
  /// Throws an [ArgumentError] if any required parameter is empty.
  AortemEntraIdClientAssertion({
    required this.clientId,
    required this.tenantId,
    required this.privateKey,
    this.certificateThumbprint,
    String? audience,
  }) : audience =
           audience ??
           'https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token' {
    if (clientId.isEmpty) {
      throw ArgumentError('clientId cannot be empty');
    }
    if (tenantId.isEmpty) {
      throw ArgumentError('tenantId cannot be empty');
    }
    if (privateKey.isEmpty) {
      throw ArgumentError('privateKey cannot be empty');
    }
  }

  /// Generates a signed JWT client assertion.
  ///
  /// This method creates a JWT with claims set for client authentication and signs it
  /// using the provided private key. The JWT includes standard claims such as issuer (iss),
  /// subject (sub), audience (aud), expiration time (exp), not before time (nbf),
  /// issued at time (iat), and JWT ID (jti). If a certificate thumbprint is provided,
  /// it is included as the 'x5t' claim.
  ///
  /// Returns a [Future<String>] that completes with the signed JWT.
  ///
  /// Throws an [Exception] if the JWT generation or signing process fails.
  Future<String> generate() async {
    try {
      // Parse the private key
      final parser = RsaKeyParser();
      final rsaPrivateKey = parser.extractPrivateKey(privateKey);

      // Create signer
      final rsaSignifier = RsaSignifier(privateKey: rsaPrivateKey);

      // Calculate timestamps
      final now = DateTime.now();
      final expiry = now.add(const Duration(minutes: 5));

      // Create a custom TokenDto implementation
      final tokenDto = EntraIdTokenDto(
        iss: clientId,
        sub: clientId,
        aud: audience.replaceAll('\$tenantId', tenantId),
        exp: expiry,
        nbf: now,
        iat: now,
        jti: _generateJti(),
        x5t: certificateThumbprint,
      );

      // Build and sign the token
      final jwtBuilder = JwtBuilder(signifier: rsaSignifier);
      return jwtBuilder.buildToken(tokenDto);
    } catch (e) {
      throw Exception('Failed to generate client assertion: ${e.toString()}');
    }
  }

  /// Generates a unique JWT ID (jti claim).
  ///
  /// The jti is a unique identifier for the JWT to prevent replay attacks.
  /// This implementation combines the current time in milliseconds and microseconds
  /// to create a unique identifier.
  ///
  /// Returns a [String] representing the unique JWT ID.
  String _generateJti() {
    final now = DateTime.now().millisecondsSinceEpoch;
    final random = DateTime.now().microsecondsSinceEpoch;
    return '$now-$random';
  }
}

/// Custom implementation of [TokenDto] for Entra ID client assertions.
///
/// This class defines the JWT claims and headers required for client assertions
/// used in confidential client authentication with Entra ID. It includes standard
/// JWT claims and optionally the 'x5t' claim for certificate thumbprints.
class EntraIdTokenDto implements TokenDto {
  /// Represents the issuer of the token, typically the client ID of the application.
  /// This claim identifies the principal that issued the JWT.
  /// See [RFC 7519 - Section 4.1.1](https://datatracker.ietf.org/doc/html/rfc7519#section-4.1.1)

  final String iss;

  /// Identifies the subject of the JWT, usually the client ID of the application.
  /// This claim identifies the principal that is the subject of the JWT.
  /// See [RFC 7519 - Section 4.1.2](https://datatracker.ietf.org/doc/html/rfc7519#section-4.1.2)

  final String sub;

  /// Specifies the audience for the token, indicating the recipient(s) the JWT is intended for.
  /// This claim identifies the recipients that the JWT is intended for.
  /// See [RFC 7519 - Section 4.1.3](https://datatracker.ietf.org/doc/html/rfc7519#section-4.1.3)
  final String aud;

  /// Defines the expiration time on or after which the JWT must not be accepted for processing.
  /// This claim identifies the expiration time on or after which the JWT MUST NOT be accepted for processing.
  /// See [RFC 7519 - Section 4.1.4](https://datatracker.ietf.org/doc/html/rfc7519#section-4.1.4)

  final DateTime exp;

  /// Identifies the time before which the JWT must not be accepted for processing.
  /// This claim identifies the time before which the JWT MUST NOT be accepted for processing.
  /// See [RFC 7519 - Section 4.1.5](https://datatracker.ietf.org/doc/html/rfc7519#section-4.1.5)

  final DateTime nbf;

  /// Represents the time at which the JWT was issued.
  /// This claim identifies the time at which the JWT was issued.
  /// See [RFC 7519 - Section 4.1.6](https://datatracker.ietf.org/doc/html/rfc7519#section-4.1.6)

  final DateTime iat;

  /// Provides a unique identifier for the JWT.
  /// This claim provides a unique identifier for the JWT.
  /// See [RFC 7519 - Section 4.1.7](https://datatracker.ietf.org/doc/html/rfc7519#section-4.1.7)

  final String jti;

  /// The certificate thumbprint, included as the 'x5t' claim if provided.
  final String? x5t;

  /// Creates an instance of [EntraIdTokenDto].
  ///
  /// All parameters are required except for [x5t], which is optional and represents
  /// the certificate thumbprint.
  EntraIdTokenDto({
    required this.iss,
    required this.sub,
    required this.aud,
    required this.exp,
    required this.nbf,
    required this.iat,
    required this.jti,
    this.x5t,
  });

  @override
  Map<String, Object> buildClaims() {
    return <String, Object>{
      'iss': iss,
      'sub': sub,
      'aud': aud,
      'exp': exp.millisecondsSinceEpoch ~/ 1000,
      'nbf': nbf.millisecondsSinceEpoch ~/ 1000,
      'iat': iat.millisecondsSinceEpoch ~/ 1000,
      'jti': jti,
      if (x5t != null) 'x5t': x5t!,
    };
  }

  @override
  Map<String, Object> buildHeader() {
    return <String, Object>{
      'typ': 'JWT',
      'alg': 'RS256',
      if (x5t != null) 'x5t': x5t!,
    };
  }

  /// Converts the [_EntraIdTokenDto] instance to a JSON-compatible map.
  ///
  /// This method is typically used for serialization purposes.
  ///
  /// Returns:
  /// A [Map<String, dynamic>] representing the JWT claims.
  Map<String, dynamic> toJson() => buildClaims();
}
