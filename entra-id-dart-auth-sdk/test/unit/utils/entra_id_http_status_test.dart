import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/utils/entra_id_http_status.dart';

void main() {
  group('AortemEntraIdHttpStatus', () {
    test('isSuccess returns true for success codes', () {
      expect(AortemEntraIdHttpStatus.isSuccess(200), isTrue);
      expect(AortemEntraIdHttpStatus.isSuccess(201), isTrue);
      expect(AortemEntraIdHttpStatus.isSuccess(299), isTrue);
    });

    test('isSuccess returns false for non-success codes', () {
      expect(AortemEntraIdHttpStatus.isSuccess(199), isFalse);
      expect(AortemEntraIdHttpStatus.isSuccess(300), isFalse);
    });

    test('isClientError returns true for client error codes', () {
      expect(AortemEntraIdHttpStatus.isClientError(400), isTrue);
      expect(AortemEntraIdHttpStatus.isClientError(404), isTrue);
      expect(AortemEntraIdHttpStatus.isClientError(499), isTrue);
    });

    test('isClientError returns false for non-client error codes', () {
      expect(AortemEntraIdHttpStatus.isClientError(399), isFalse);
      expect(AortemEntraIdHttpStatus.isClientError(500), isFalse);
    });

    test('isServerError returns true for server error codes', () {
      expect(AortemEntraIdHttpStatus.isServerError(500), isTrue);
      expect(AortemEntraIdHttpStatus.isServerError(503), isTrue);
    });

    test('isServerError returns false for non-server error codes', () {
      expect(AortemEntraIdHttpStatus.isServerError(499), isFalse);
      expect(AortemEntraIdHttpStatus.isServerError(600), isFalse);
    });

    test('getDescription returns correct descriptions', () {
      expect(AortemEntraIdHttpStatus.getDescription(200), equals('OK'));
      expect(AortemEntraIdHttpStatus.getDescription(404), equals('Not Found'));
      expect(
        AortemEntraIdHttpStatus.getDescription(500),
        equals('Internal Server Error'),
      );
    });

    test('getDescription returns unknown for unsupported codes', () {
      expect(
        AortemEntraIdHttpStatus.getDescription(999),
        equals('Unknown Status Code'),
      );
    });
  });
}
