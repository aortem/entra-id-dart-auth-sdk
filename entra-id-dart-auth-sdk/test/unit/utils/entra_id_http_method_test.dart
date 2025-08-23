import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/utils/entra_id_http_method.dart';

void main() {
  group('EntraIdHttpMethodUtils', () {
    test('methodToString converts enum to string', () {
      expect(
        EntraIdHttpMethodUtils.methodToString(
          EntraIdHttpMethod.get,
        ),
        'get',
      );
      expect(
        EntraIdHttpMethodUtils.methodToString(
          EntraIdHttpMethod.post,
        ),
        'post',
      );
      expect(
        EntraIdHttpMethodUtils.methodToString(
          EntraIdHttpMethod.put,
        ),
        'put',
      );
      expect(
        EntraIdHttpMethodUtils.methodToString(
          EntraIdHttpMethod.delete,
        ),
        'delete',
      );
      expect(
        EntraIdHttpMethodUtils.methodToString(
          EntraIdHttpMethod.patch,
        ),
        'patch',
      );
      expect(
        EntraIdHttpMethodUtils.methodToString(
          EntraIdHttpMethod.head,
        ),
        'head',
      );
      expect(
        EntraIdHttpMethodUtils.methodToString(
          EntraIdHttpMethod.options,
        ),
        'options',
      );
      expect(
        EntraIdHttpMethodUtils.methodToString(
          EntraIdHttpMethod.trace,
        ),
        'trace',
      );
    });

    test('stringToMethod converts string to enum', () {
      expect(
        EntraIdHttpMethodUtils.stringToMethod('get'),
        EntraIdHttpMethod.get,
      );
      expect(
        EntraIdHttpMethodUtils.stringToMethod('POST'),
        EntraIdHttpMethod.post,
      );
      expect(
        EntraIdHttpMethodUtils.stringToMethod('Put'),
        EntraIdHttpMethod.put,
      );
      expect(
        EntraIdHttpMethodUtils.stringToMethod('delete'),
        EntraIdHttpMethod.delete,
      );
      expect(
        EntraIdHttpMethodUtils.stringToMethod('PATCH'),
        EntraIdHttpMethod.patch,
      );
      expect(
        EntraIdHttpMethodUtils.stringToMethod('head'),
        EntraIdHttpMethod.head,
      );
      expect(
        EntraIdHttpMethodUtils.stringToMethod('OPTIONS'),
        EntraIdHttpMethod.options,
      );
      expect(
        EntraIdHttpMethodUtils.stringToMethod('TrAcE'),
        EntraIdHttpMethod.trace,
      );
    });

    test('stringToMethod throws ArgumentError for invalid method', () {
      expect(
        () => EntraIdHttpMethodUtils.stringToMethod('invalid'),
        throwsArgumentError,
      );
      expect(
        () => EntraIdHttpMethodUtils.stringToMethod('123'),
        throwsArgumentError,
      );
      expect(
        () => EntraIdHttpMethodUtils.stringToMethod(''),
        throwsArgumentError,
      );
    });

    test('isSupported returns true for valid methods', () {
      expect(EntraIdHttpMethodUtils.isSupported('get'), isTrue);
      expect(EntraIdHttpMethodUtils.isSupported('POST'), isTrue);
      expect(EntraIdHttpMethodUtils.isSupported('patch'), isTrue);
      expect(EntraIdHttpMethodUtils.isSupported('TRACE'), isTrue);
    });

    test('isSupported returns false for invalid methods', () {
      expect(EntraIdHttpMethodUtils.isSupported('invalid'), isFalse);
      expect(EntraIdHttpMethodUtils.isSupported('123'), isFalse);
      expect(EntraIdHttpMethodUtils.isSupported(''), isFalse);
    });
  });
}
