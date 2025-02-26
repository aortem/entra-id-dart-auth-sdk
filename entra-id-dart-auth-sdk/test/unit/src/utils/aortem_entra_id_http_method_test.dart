
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/utils/aortem_entraid_http_method.dart';

void main() {
  group('AortemEntraIdHttpMethodUtils Tests', () {
    test('methodToString returns correct string representation', () {
      expect(AortemEntraIdHttpMethodUtils.methodToString(AortemEntraIdHttpMethod.GET), 'GET');
      expect(AortemEntraIdHttpMethodUtils.methodToString(AortemEntraIdHttpMethod.POST), 'POST');
    });

    test('stringToMethod returns correct enum value', () {
      expect(AortemEntraIdHttpMethodUtils.stringToMethod('GET'), AortemEntraIdHttpMethod.GET);
      expect(AortemEntraIdHttpMethodUtils.stringToMethod('POST'), AortemEntraIdHttpMethod.POST);
    });

    test('stringToMethod is case-insensitive', () {
      expect(AortemEntraIdHttpMethodUtils.stringToMethod('get'), AortemEntraIdHttpMethod.GET);
      expect(AortemEntraIdHttpMethodUtils.stringToMethod('post'), AortemEntraIdHttpMethod.POST);
    });

    test('stringToMethod throws ArgumentError for unsupported method', () {
      expect(() => AortemEntraIdHttpMethodUtils.stringToMethod('INVALID'),
          throwsA(isA<ArgumentError>()));
    });

    test('isSupported returns true for valid methods', () {
      expect(AortemEntraIdHttpMethodUtils.isSupported('GET'), true);
      expect(AortemEntraIdHttpMethodUtils.isSupported('POST'), true);
    });

    test('isSupported is case-insensitive', () {
      expect(AortemEntraIdHttpMethodUtils.isSupported('get'), true);
      expect(AortemEntraIdHttpMethodUtils.isSupported('post'), true);
    });

    test('isSupported returns false for unsupported methods', () {
      expect(AortemEntraIdHttpMethodUtils.isSupported('INVALID'), false);
      expect(AortemEntraIdHttpMethodUtils.isSupported('UNKNOWN'), false);
    });
  });
}
