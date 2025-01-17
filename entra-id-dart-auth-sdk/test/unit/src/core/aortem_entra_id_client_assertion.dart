

import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/core/aortem_entraid_client_assertion.dart';
import 'package:jose/jose.dart';

void main() {
  group('AortemEntraIdClientAssertion Tests', () {
    late AortemEntraIdClientAssertion clientAssertion;

    setUp(() {
      clientAssertion = AortemEntraIdClientAssertion(
        clientId: 'test-client-id',
        tenantId: 'test-tenant-id',
        privateKey: '''-----BEGIN PRIVATE KEY-----
<your-test-private-key>
-----END PRIVATE KEY-----''',
        audience: 'https://login.microsoftonline.com/test-tenant-id/oauth2/v2.0/token',
      );
    });

    test('Generate Client Assertion Successfully', () async {
      final assertion = await clientAssertion.generateAssertion();
      expect(assertion.isNotEmpty, true);
      expect(() => JsonWebToken.unverified(assertion), returnsNormally);
    });

    test('Throws Exception for Missing Private Key', () {
      final invalidClientAssertion = AortemEntraIdClientAssertion(
        clientId: 'test-client-id',
        tenantId: 'test-tenant-id',
        privateKey: '',
        audience: 'https://login.microsoftonline.com/test-tenant-id/oauth2/v2.0/token',
      );

      expect(
        () async => await invalidClientAssertion.generateAssertion(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
