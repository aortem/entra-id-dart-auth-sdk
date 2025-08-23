import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';

// Replace with actual import path

void main() {
  group('EntraIdHttpMethodUtils', () {
    test('methodToString converts enum to string correctly', () {
      expect(
        EntraIdHttpMethodUtils.methodToString(
          EntraIdHttpMethod.get,
        ),
        equals('get'),
      );
      expect(
        EntraIdHttpMethodUtils.methodToString(
          EntraIdHttpMethod.post,
        ),
        equals('post'),
      );
    });

    test('stringToMethod converts valid string to enum', () {
      expect(
        EntraIdHttpMethodUtils.stringToMethod('get'),
        equals(EntraIdHttpMethod.get),
      );
      expect(
        EntraIdHttpMethodUtils.stringToMethod('POST'),
        equals(EntraIdHttpMethod.post),
      );
    });

    test('stringToMethod throws ArgumentError on invalid method', () {
      expect(
        () => EntraIdHttpMethodUtils.stringToMethod('FETCH'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('isSupported returns true for valid HTTP methods', () {
      expect(EntraIdHttpMethodUtils.isSupported('get'), isTrue);
      expect(EntraIdHttpMethodUtils.isSupported('DeLeTe'), isTrue);
      expect(EntraIdHttpMethodUtils.isSupported('OPTIONS'), isTrue);
    });

    test('isSupported returns false for unsupported methods', () {
      expect(EntraIdHttpMethodUtils.isSupported('fetch'), isFalse);
      expect(EntraIdHttpMethodUtils.isSupported('foo'), isFalse);
      expect(EntraIdHttpMethodUtils.isSupported(''), isFalse);
    });
  });
}
