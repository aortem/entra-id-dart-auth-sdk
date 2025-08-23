import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';

void main() {
  group('EntraIdHttpStatus', () {
    test('isSuccess returns true for 2xx status codes', () {
      expect(EntraIdHttpStatus.isSuccess(200), isTrue);
      expect(EntraIdHttpStatus.isSuccess(201), isTrue);
      expect(EntraIdHttpStatus.isSuccess(299), isTrue);
    });

    test('isSuccess returns false for non-2xx status codes', () {
      expect(EntraIdHttpStatus.isSuccess(199), isFalse);
      expect(EntraIdHttpStatus.isSuccess(300), isFalse);
    });

    test('isClientError returns true for 4xx status codes', () {
      expect(EntraIdHttpStatus.isClientError(400), isTrue);
      expect(EntraIdHttpStatus.isClientError(404), isTrue);
      expect(EntraIdHttpStatus.isClientError(499), isTrue);
    });

    test('isClientError returns false for non-4xx status codes', () {
      expect(EntraIdHttpStatus.isClientError(399), isFalse);
      expect(EntraIdHttpStatus.isClientError(500), isFalse);
    });

    test('isServerError returns true for 5xx status codes', () {
      expect(EntraIdHttpStatus.isServerError(500), isTrue);
      expect(EntraIdHttpStatus.isServerError(503), isTrue);
      expect(EntraIdHttpStatus.isServerError(599), isTrue);
    });

    test('isServerError returns false for status codes below 500', () {
      expect(EntraIdHttpStatus.isServerError(499), isFalse);
      expect(EntraIdHttpStatus.isServerError(200), isFalse);
    });

    test('getDescription returns correct string for known codes', () {
      expect(EntraIdHttpStatus.getDescription(100), equals('Continue'));
      expect(EntraIdHttpStatus.getDescription(200), equals('OK'));
      expect(EntraIdHttpStatus.getDescription(201), equals('Created'));
      expect(
        EntraIdHttpStatus.getDescription(400),
        equals('Bad Request'),
      );
      expect(EntraIdHttpStatus.getDescription(403), equals('Forbidden'));
      expect(EntraIdHttpStatus.getDescription(404), equals('Not Found'));
      expect(
        EntraIdHttpStatus.getDescription(503),
        equals('Service Unavailable'),
      );
    });

    test('getDescription returns fallback for unknown codes', () {
      expect(
        EntraIdHttpStatus.getDescription(999),
        equals('Unknown Status Code'),
      );
      expect(
        EntraIdHttpStatus.getDescription(150),
        equals('Unknown Status Code'),
      );
    });
  });
}
