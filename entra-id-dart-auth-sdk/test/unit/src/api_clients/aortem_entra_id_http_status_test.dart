import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';

void main() {
  group('AortemEntraIdHttpStatus', () {
    test('isSuccess returns true for 2xx status codes', () {
      expect(AortemEntraIdHttpStatus.isSuccess(200), isTrue);
      expect(AortemEntraIdHttpStatus.isSuccess(201), isTrue);
      expect(AortemEntraIdHttpStatus.isSuccess(299), isTrue);
    });

    test('isSuccess returns false for non-2xx status codes', () {
      expect(AortemEntraIdHttpStatus.isSuccess(199), isFalse);
      expect(AortemEntraIdHttpStatus.isSuccess(300), isFalse);
    });

    test('isClientError returns true for 4xx status codes', () {
      expect(AortemEntraIdHttpStatus.isClientError(400), isTrue);
      expect(AortemEntraIdHttpStatus.isClientError(404), isTrue);
      expect(AortemEntraIdHttpStatus.isClientError(499), isTrue);
    });

    test('isClientError returns false for non-4xx status codes', () {
      expect(AortemEntraIdHttpStatus.isClientError(399), isFalse);
      expect(AortemEntraIdHttpStatus.isClientError(500), isFalse);
    });

    test('isServerError returns true for 5xx status codes', () {
      expect(AortemEntraIdHttpStatus.isServerError(500), isTrue);
      expect(AortemEntraIdHttpStatus.isServerError(503), isTrue);
      expect(AortemEntraIdHttpStatus.isServerError(599), isTrue);
    });

    test('isServerError returns false for status codes below 500', () {
      expect(AortemEntraIdHttpStatus.isServerError(499), isFalse);
      expect(AortemEntraIdHttpStatus.isServerError(200), isFalse);
    });

    test('getDescription returns correct string for known codes', () {
      expect(AortemEntraIdHttpStatus.getDescription(100), equals('Continue'));
      expect(AortemEntraIdHttpStatus.getDescription(200), equals('OK'));
      expect(AortemEntraIdHttpStatus.getDescription(201), equals('Created'));
      expect(
        AortemEntraIdHttpStatus.getDescription(400),
        equals('Bad Request'),
      );
      expect(AortemEntraIdHttpStatus.getDescription(403), equals('Forbidden'));
      expect(AortemEntraIdHttpStatus.getDescription(404), equals('Not Found'));
      expect(
        AortemEntraIdHttpStatus.getDescription(503),
        equals('Service Unavailable'),
      );
    });

    test('getDescription returns fallback for unknown codes', () {
      expect(
        AortemEntraIdHttpStatus.getDescription(999),
        equals('Unknown Status Code'),
      );
      expect(
        AortemEntraIdHttpStatus.getDescription(150),
        equals('Unknown Status Code'),
      );
    });
  });
}
