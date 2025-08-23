import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';

// Mocking the helper class that wraps InternetAddress.lookup
class MockNetworkUtilsHelper extends Mock implements NetworkUtilsHelper {}

void main() {
  group('AortemEntraIdNetworkUtils', () {
    late MockNetworkUtilsHelper mockNetworkHelper;
    late AortemEntraIdNetworkUtils networkUtils;

    setUp(() {
      mockNetworkHelper = MockNetworkUtilsHelper();
      networkUtils = AortemEntraIdNetworkUtils(helper: mockNetworkHelper);
    });

    test('validateUrl returns true for valid URL', () {
      final validUrl = 'https://example.com';
      final result = networkUtils.validateUrl(validUrl);
      expect(result, true);
    });

    test('validateUrl throws ArgumentError for invalid URL', () {
      final invalidUrl = 'invalid-url';
      expect(() => networkUtils.validateUrl(invalidUrl), throwsArgumentError);
    });

    test('retryRequest retries a failed operation', () async {
      int callCount = 0;

      // Simulating an operation that fails 2 times before succeeding
      Future<String> operation() async {
        callCount++;
        if (callCount < 3) {
          throw Exception('Temporary failure');
        }
        return 'Success';
      }

      final result = await networkUtils.retryRequest(operation);
      expect(result, 'Success');
      expect(callCount, 3); // Ensure the operation was retried 3 times
    });
  });
}
