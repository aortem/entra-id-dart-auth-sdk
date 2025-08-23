import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/utils/entra_id_http_method.dart';

void main() {
  group('AortemEntraIdHttpMethodUtils', () {
    test('methodToString converts enum to string', () {
      expect(
        AortemEntraIdHttpMethodUtils.methodToString(
          AortemEntraIdHttpMethod.get,
        ),
        'get',
      );
      expect(
        AortemEntraIdHttpMethodUtils.methodToString(
          AortemEntraIdHttpMethod.post,
        ),
        'post',
      );
      expect(
        AortemEntraIdHttpMethodUtils.methodToString(
          AortemEntraIdHttpMethod.put,
        ),
        'put',
      );
      expect(
        AortemEntraIdHttpMethodUtils.methodToString(
          AortemEntraIdHttpMethod.delete,
        ),
        'delete',
      );
      expect(
        AortemEntraIdHttpMethodUtils.methodToString(
          AortemEntraIdHttpMethod.patch,
        ),
        'patch',
      );
      expect(
        AortemEntraIdHttpMethodUtils.methodToString(
          AortemEntraIdHttpMethod.head,
        ),
        'head',
      );
      expect(
        AortemEntraIdHttpMethodUtils.methodToString(
          AortemEntraIdHttpMethod.options,
        ),
        'options',
      );
      expect(
        AortemEntraIdHttpMethodUtils.methodToString(
          AortemEntraIdHttpMethod.trace,
        ),
        'trace',
      );
    });

    test('stringToMethod converts string to enum', () {
      expect(
        AortemEntraIdHttpMethodUtils.stringToMethod('get'),
        AortemEntraIdHttpMethod.get,
      );
      expect(
        AortemEntraIdHttpMethodUtils.stringToMethod('POST'),
        AortemEntraIdHttpMethod.post,
      );
      expect(
        AortemEntraIdHttpMethodUtils.stringToMethod('Put'),
        AortemEntraIdHttpMethod.put,
      );
      expect(
        AortemEntraIdHttpMethodUtils.stringToMethod('delete'),
        AortemEntraIdHttpMethod.delete,
      );
      expect(
        AortemEntraIdHttpMethodUtils.stringToMethod('PATCH'),
        AortemEntraIdHttpMethod.patch,
      );
      expect(
        AortemEntraIdHttpMethodUtils.stringToMethod('head'),
        AortemEntraIdHttpMethod.head,
      );
      expect(
        AortemEntraIdHttpMethodUtils.stringToMethod('OPTIONS'),
        AortemEntraIdHttpMethod.options,
      );
      expect(
        AortemEntraIdHttpMethodUtils.stringToMethod('TrAcE'),
        AortemEntraIdHttpMethod.trace,
      );
    });

    test('stringToMethod throws ArgumentError for invalid method', () {
      expect(
        () => AortemEntraIdHttpMethodUtils.stringToMethod('invalid'),
        throwsArgumentError,
      );
      expect(
        () => AortemEntraIdHttpMethodUtils.stringToMethod('123'),
        throwsArgumentError,
      );
      expect(
        () => AortemEntraIdHttpMethodUtils.stringToMethod(''),
        throwsArgumentError,
      );
    });

    test('isSupported returns true for valid methods', () {
      expect(AortemEntraIdHttpMethodUtils.isSupported('get'), isTrue);
      expect(AortemEntraIdHttpMethodUtils.isSupported('POST'), isTrue);
      expect(AortemEntraIdHttpMethodUtils.isSupported('patch'), isTrue);
      expect(AortemEntraIdHttpMethodUtils.isSupported('TRACE'), isTrue);
    });

    test('isSupported returns false for invalid methods', () {
      expect(AortemEntraIdHttpMethodUtils.isSupported('invalid'), isFalse);
      expect(AortemEntraIdHttpMethodUtils.isSupported('123'), isFalse);
      expect(AortemEntraIdHttpMethodUtils.isSupported(''), isFalse);
    });
  });
}
