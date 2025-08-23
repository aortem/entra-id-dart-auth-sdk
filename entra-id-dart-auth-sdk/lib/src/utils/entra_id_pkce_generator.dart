import 'dart:convert';
import 'dart:math';
import 'package:ds_standard_features/ds_standard_features.dart';

/// EntraIdPkceGenerator: Generates a PKCE code verifier and challenge pair for OAuth 2.0 flows.
///
/// This class generates secure, random code verifiers and corresponding code challenges for OAuth 2.0 authorization with PKCE.
class EntraIdPkceGenerator {
  final Random _random = Random.secure();

  /// Generate a secure code verifier and code challenge pair for PKCE.
  ///
  /// The code verifier is a random string, and the code challenge is a hashed version of the verifier.
  Map<String, String> generatePkcePair() {
    final codeVerifier = _generateCodeVerifier();
    final codeChallenge = _generateCodeChallenge(codeVerifier);

    return {'code_verifier': codeVerifier, 'code_challenge': codeChallenge};
  }

  /// Generate a random code verifier according to PKCE standards.
  String _generateCodeVerifier() {
    const characters =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
    final codeVerifier =
        List.generate(
          43,
          (index) => characters[_random.nextInt(characters.length)],
        ).join();
    return codeVerifier;
  }

  /// Generate a code challenge from the code verifier using SHA-256.
  String _generateCodeChallenge(String codeVerifier) {
    final bytes = utf8.encode(codeVerifier);
    final hash = sha256.convert(bytes);
    return base64Url
        .encode(hash.bytes)
        .replaceAll('=', ''); // PKCE spec requires URL-safe encoding
  }
}
