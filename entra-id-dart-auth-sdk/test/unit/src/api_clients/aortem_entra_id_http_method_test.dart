import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';

// Replace with actual import path

void main() {
  group('AortemEntraIdHttpMethodUtils', () {
    test('methodToString converts enum to string correctly', () {
      expect(
        AortemEntraIdHttpMethodUtils.methodToString(
          AortemEntraIdHttpMethod.get,
        ),
        equals('get'),
      );
      expect(
        AortemEntraIdHttpMethodUtils.methodToString(
          AortemEntraIdHttpMethod.post,
        ),
        equals('post'),
      );
    });

    test('stringToMethod converts valid string to enum', () {
      expect(
        AortemEntraIdHttpMethodUtils.stringToMethod('get'),
        equals(AortemEntraIdHttpMethod.get),
      );
      expect(
        AortemEntraIdHttpMethodUtils.stringToMethod('POST'),
        equals(AortemEntraIdHttpMethod.post),
      );
    });

    test('stringToMethod throws ArgumentError on invalid method', () {
      expect(
        () => AortemEntraIdHttpMethodUtils.stringToMethod('FETCH'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('isSupported returns true for valid HTTP methods', () {
      expect(AortemEntraIdHttpMethodUtils.isSupported('get'), isTrue);
      expect(AortemEntraIdHttpMethodUtils.isSupported('DeLeTe'), isTrue);
      expect(AortemEntraIdHttpMethodUtils.isSupported('OPTIONS'), isTrue);
    });

    test('isSupported returns false for unsupported methods', () {
      expect(AortemEntraIdHttpMethodUtils.isSupported('fetch'), isFalse);
      expect(AortemEntraIdHttpMethodUtils.isSupported('foo'), isFalse);
      expect(AortemEntraIdHttpMethodUtils.isSupported(''), isFalse);
    });
  });
}
