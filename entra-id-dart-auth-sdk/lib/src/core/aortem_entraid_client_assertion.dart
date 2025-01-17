import 'dart:convert';
import 'package:jose/jose.dart';

class AortemEntraIdClientAssertion {
  final String clientId;
  final String tenantId;
  final String privateKey;
  final String audience;

  AortemEntraIdClientAssertion({
    required this.clientId,
    required this.tenantId,
    required this.privateKey,
    required this.audience,
  });

  /// Generates a signed JWT for client assertion.
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

  /// Generate a unique JWT ID
  String _generateJwtId() {
    return base64UrlEncode(List<int>.generate(16, (_) => DateTime.now().millisecondsSinceEpoch % 256));
  }

  /// Get the expiration timestamp (5 minutes in the future)
  int _getExpiryTimestamp() {
    final expiry = DateTime.now().add(Duration(minutes: 5));
    return (expiry.millisecondsSinceEpoch / 1000).round();
  }
}
