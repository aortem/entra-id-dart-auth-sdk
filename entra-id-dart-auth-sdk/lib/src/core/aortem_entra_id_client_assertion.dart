import 'dart:convert';
import 'package:jose/jose.dart';

/// AortemEntraIdClientAssertion: Handles the generation of client assertions for Entra ID.
///
/// This class creates a signed JWT (JSON Web Token) that can be used for client authentication
/// in OAuth 2.0 or OpenID Connect flows.
///
/// Features:
/// - Generates signed client assertions using RS256 algorithm.
/// - Includes claims such as issuer, subject, audience, JWT ID, and expiration timestamp.
class AortemEntraIdClientAssertion {
  /// The client ID of the application registered in Entra ID.
  final String clientId;

  /// The tenant ID associated with the Entra ID instance.
  final String tenantId;

  /// The private key (in PEM format) used for signing the client assertion.
  final String privateKey;

  /// The audience for the client assertion (typically the token endpoint URL).
  final String audience;

  /// Constructor for `AortemEntraIdClientAssertion`.
  ///
  /// - [clientId]: The application client ID.
  /// - [tenantId]: The tenant ID associated with the application.
  /// - [privateKey]: The PEM-formatted private key for signing the JWT.
  /// - [audience]: The intended audience for the JWT (e.g., token endpoint URL).
  AortemEntraIdClientAssertion({
    required this.clientId,
    required this.tenantId,
    required this.privateKey,
    required this.audience,
  });

  /// Generates a signed JWT for client assertion.
  ///
  /// The JWT includes the following claims:
  /// - `iss`: The issuer, which is the application client ID.
  /// - `sub`: The subject, which is also the application client ID.
  /// - `aud`: The audience, which is typically the token endpoint URL.
  /// - `jti`: A unique JWT ID for identifying the token.
  /// - `exp`: The expiration time for the token (5 minutes from now).
  ///
  /// Example usage:
  /// ```dart
  /// final assertion = await clientAssertion.generateAssertion();
  /// print('Generated Client Assertion: $assertion');
  /// ```
  ///
  /// - Returns: A signed JWT string in compact serialization format.
  /// - Throws: An exception if the token generation fails.
  Future<String> generateAssertion() async {
    try {
      final claims = JsonWebTokenClaims.fromJson({
        'iss': clientId,
        'sub': clientId,
        'aud': audience,
        'jti': _generateJwtId(),
        'exp': _getExpiryTimestamp(),
      });

      // Load the private key
      final key = JsonWebKey.fromPem(privateKey);

      // Sign the token
      final builder = JsonWebSignatureBuilder()
        ..jsonContent = claims.toJson()
        ..addRecipient(key, algorithm: 'RS256');

      final jws = builder.build();
      return jws.toCompactSerialization();
    } catch (e) {
      throw Exception('Failed to generate client assertion: $e');
    }
  }

  /// Generates a unique JWT ID.
  ///
  /// This method creates a base64 URL-encoded string to serve as a unique identifier
  /// for each JWT. It uses the current timestamp to ensure uniqueness.
  ///
  /// - Returns: A unique JWT ID as a base64 URL-encoded string.
  String _generateJwtId() {
    return base64UrlEncode(
      List<int>.generate(16, (_) => DateTime.now().millisecondsSinceEpoch % 256),
    );
  }

  /// Calculates the expiration timestamp for the JWT.
  ///
  /// The expiration time is set to 5 minutes (300 seconds) from the current time.
  ///
  /// - Returns: The expiration timestamp in seconds since the Unix epoch.
  int _getExpiryTimestamp() {
    final expiry = DateTime.now().add(Duration(minutes: 5));
    return (expiry.millisecondsSinceEpoch / 1000).round();
  }
}
