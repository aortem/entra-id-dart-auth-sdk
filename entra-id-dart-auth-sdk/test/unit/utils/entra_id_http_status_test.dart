import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/utils/entra_id_http_status.dart';

void main() {
  group('EntraIdHttpStatus', () {
    test('isSuccess returns true for success codes', () {
      expect(EntraIdHttpStatus.isSuccess(200), isTrue);
      expect(EntraIdHttpStatus.isSuccess(201), isTrue);
      expect(EntraIdHttpStatus.isSuccess(299), isTrue);
    });

    test('isSuccess returns false for non-success codes', () {
      expect(EntraIdHttpStatus.isSuccess(199), isFalse);
      expect(EntraIdHttpStatus.isSuccess(300), isFalse);
    });

    test('isClientError returns true for client error codes', () {
      expect(EntraIdHttpStatus.isClientError(400), isTrue);
      expect(EntraIdHttpStatus.isClientError(404), isTrue);
      expect(EntraIdHttpStatus.isClientError(499), isTrue);
    });

    test('isClientError returns false for non-client error codes', () {
      expect(EntraIdHttpStatus.isClientError(399), isFalse);
      expect(EntraIdHttpStatus.isClientError(500), isFalse);
    });

    test('isServerError returns true for server error codes', () {
      expect(EntraIdHttpStatus.isServerError(500), isTrue);
      expect(EntraIdHttpStatus.isServerError(503), isTrue);
    });

    test('isServerError returns false for non-server error codes', () {
      expect(EntraIdHttpStatus.isServerError(499), isFalse);
      expect(EntraIdHttpStatus.isServerError(600), isFalse);
    });

    test('getDescription returns correct descriptions', () {
      expect(EntraIdHttpStatus.getDescription(200), equals('OK'));
      expect(EntraIdHttpStatus.getDescription(404), equals('Not Found'));
      expect(
        EntraIdHttpStatus.getDescription(500),
        equals('Internal Server Error'),
      );
    });

    test('getDescription returns unknown for unsupported codes', () {
      expect(
        EntraIdHttpStatus.getDescription(999),
        equals('Unknown Status Code'),
      );
    });
  });
}
