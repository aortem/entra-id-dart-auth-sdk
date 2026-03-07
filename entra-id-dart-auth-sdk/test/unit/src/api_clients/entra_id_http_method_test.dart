import 'package:entra_id_dart_auth_sdk/src/api_clients/entra_id_http_method.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  group('AortemEntraIdHttpMethod enum helpers', () {
    test('asString returns enum name', () {
      expect(EntraIdHttpMethod.get.asString, equals('GET'));
      expect(EntraIdHttpMethod.post.asString, equals('POST'));
    });

    test('fromString is case-insensitive and maps correctly', () {
      expect(EntraIdHttpMethod.fromString('get'), EntraIdHttpMethod.get);
      expect(EntraIdHttpMethod.fromString('POST'), EntraIdHttpMethod.post);
      expect(EntraIdHttpMethod.fromString('Put'), EntraIdHttpMethod.put);
      expect(EntraIdHttpMethod.fromString('delete'), EntraIdHttpMethod.delete);
      expect(EntraIdHttpMethod.fromString('patch'), EntraIdHttpMethod.patch);
      expect(
        EntraIdHttpMethod.fromString('options'),
        EntraIdHttpMethod.options,
      );
      expect(EntraIdHttpMethod.fromString('HEAD'), EntraIdHttpMethod.head);
    });

    test('fromString throws on unsupported method', () {
      expect(
        () => EntraIdHttpMethod.fromString('FOOBAR'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('isSupported identifies valid and invalid methods', () {
      expect(EntraIdHttpMethod.isSupported('get'), isTrue);
      expect(EntraIdHttpMethod.isSupported('PATCH'), isTrue);
      expect(EntraIdHttpMethod.isSupported('foobar'), isFalse);
    });
  });
}
