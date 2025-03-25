

import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/utils/aortem_entra_id_network_utils.dart';

void main() {
  group('AortemEntraIdNetworkUtils', () {
    final networkUtils = AortemEntraIdNetworkUtils();

    test('checkInternetConnectivity should return a boolean', () async {
      final result = await networkUtils.checkInternetConnectivity();
      expect(result, isA<bool>());
    });

    test('validateUrl should throw for invalid URLs', () {
      expect(() => networkUtils.validateUrl('invalid_url'), throwsArgumentError);
    });

    test('validateUrl should return true for valid URLs', () {
      final isValid = networkUtils.validateUrl('https://example.com');
      expect(isValid, isTrue);
    });

    test('retryRequest should retry the operation on failure', () async {
      int attemptCount = 0;

      try {
        await networkUtils.retryRequest(() async {
          attemptCount++;
          throw Exception('Simulated network error');
        }, retryCount: 3);
      } catch (_) {}

      expect(attemptCount, equals(3));
    });

    test('retryRequest should return result on success', () async {
      final result = await networkUtils.retryRequest(() async {
        return 'Success';
      });
      expect(result, equals('Success'));
    });
  });
}
