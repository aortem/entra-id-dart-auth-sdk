import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/utils/entra_id_pkce_generator.dart';

void main() {
  group('AortemEntraIdPkceGenerator', () {
    test('should generate a valid code verifier and challenge pair', () {
      final pkceGenerator = AortemEntraIdPkceGenerator();
      final pkcePair = pkceGenerator.generatePkcePair();

      expect(pkcePair['code_verifier'], isNotEmpty);
      expect(pkcePair['code_challenge'], isNotEmpty);
      expect(
        pkcePair['code_verifier']!.length,
        43,
      ); // PKCE spec requires 43 characters for code verifier
    });

    test('should generate different code verifiers on each call', () {
      final pkceGenerator = AortemEntraIdPkceGenerator();
      final pkcePair1 = pkceGenerator.generatePkcePair();
      final pkcePair2 = pkceGenerator.generatePkcePair();

      expect(
        pkcePair1['code_verifier'],
        isNot(equals(pkcePair2['code_verifier'])),
      );
    });

    test('should generate a URL-safe base64 encoded code challenge', () {
      final pkceGenerator = AortemEntraIdPkceGenerator();
      final pkcePair = pkceGenerator.generatePkcePair();

      final codeChallenge = pkcePair['code_challenge']!;
      expect(
        codeChallenge,
        matches(r'^[A-Za-z0-9\-_]+$'),
      ); // Only URL-safe base64 characters
      expect(
        codeChallenge.length,
        lessThan(128),
      ); // PKCE challenge is typically short
    });
  });
}
