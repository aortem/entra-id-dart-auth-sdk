import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart'; // To use sha256 for testing

void main() {
  group('EntraIdPkceGenerator', () {
    late EntraIdPkceGenerator pkceGenerator;

    setUp(() {
      pkceGenerator = EntraIdPkceGenerator();
    });

    test('should generate a code verifier and code challenge pair', () {
      final pkcePair = pkceGenerator.generatePkcePair();
      expect(pkcePair, containsPair('code_verifier', isNotEmpty));
      expect(pkcePair, containsPair('code_challenge', isNotEmpty));
    });

    test('should generate a valid code challenge based on the verifier', () {
      final pkcePair = pkceGenerator.generatePkcePair();
      final codeVerifier = pkcePair['code_verifier']!;
      final expectedCodeChallenge = pkceGenerator.generateCodeChallenge(
        codeVerifier,
      );

      // Compare generated code challenge with manually calculated one
      expect(pkcePair['code_challenge'], equals(expectedCodeChallenge));
    });

    test('code verifier should be of length 43', () {
      final pkcePair = pkceGenerator.generatePkcePair();
      final codeVerifier = pkcePair['code_verifier']!;

      expect(
        codeVerifier.length,
        equals(43),
      ); // PKCE standard specifies 43 characters
    });

    test('code challenge should be URL-safe and Base64 encoded', () {
      final pkcePair = pkceGenerator.generatePkcePair();
      final codeChallenge = pkcePair['code_challenge']!;

      // PKCE spec requires Base64 URL encoding with no padding
      expect(RegExp(r'^[A-Za-z0-9_-]+$').hasMatch(codeChallenge), isTrue);
    });

    test('code verifier should contain only valid characters', () {
      final pkcePair = pkceGenerator.generatePkcePair();
      final codeVerifier = pkcePair['code_verifier']!;

      // PKCE spec allows only certain characters
      expect(RegExp(r'^[A-Za-z0-9\-._~]+$').hasMatch(codeVerifier), isTrue);
    });

    test('should generate a unique code verifier on each call', () {
      final pkcePair1 = pkceGenerator.generatePkcePair();
      final pkcePair2 = pkceGenerator.generatePkcePair();

      expect(
        pkcePair1['code_verifier'],
        isNot(equals(pkcePair2['code_verifier'])),
      );
    });
  });
}
