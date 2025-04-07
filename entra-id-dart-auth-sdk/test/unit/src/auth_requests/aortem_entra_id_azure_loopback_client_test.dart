import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';

import 'package:ds_standard_features/ds_standard_features.dart' as http;

void main() {
  group('AortemEntraIdAzureLoopbackClient', () {
    late AortemEntraIdAzureLoopbackClient loopbackClient;

    setUp(() {
      loopbackClient = AortemEntraIdAzureLoopbackClient();
    });

    tearDown(() async {
      await loopbackClient.stop();
    });

    test('should start server and handle redirect with query params', () async {
      final port = await loopbackClient.start();
      final uri = Uri.parse(
        'http://localhost:$port/redirect?code=abc123&state=test',
      );

      final futureResponse = loopbackClient.waitForResponse();

      final response = await http.get(uri);
      expect(response.statusCode, 200);
      expect(response.body.contains('Authentication Complete'), isTrue);

      final loopbackResponse = await futureResponse;

      expect(loopbackResponse.queryParameters['code'], 'abc123');
      expect(loopbackResponse.queryParameters['state'], 'test');
      expect(loopbackResponse.rawRequest, contains('code=abc123'));
    });

    test('should return 404 for non-redirect path', () async {
      final port = await loopbackClient.start();
      final uri = Uri.parse('http://localhost:$port/invalid');

      final response = await http.get(uri);
      expect(response.statusCode, 404);
    });

    test('should timeout if no redirect is received', () async {
      loopbackClient = AortemEntraIdAzureLoopbackClient(
        timeout: Duration(seconds: 2),
      );
      await loopbackClient.start();

      expect(
        () => loopbackClient.waitForResponse(),
        throwsA(
          isA<LoopbackClientException>().having(
            (e) => e.code,
            'code',
            'timeout',
          ),
        ),
      );
    });

    test('getRedirectUri should throw if server not started', () {
      expect(
        () => loopbackClient.getRedirectUri(),
        throwsA(
          isA<LoopbackClientException>().having(
            (e) => e.code,
            'code',
            'server_not_started',
          ),
        ),
      );
    });
  });
}
