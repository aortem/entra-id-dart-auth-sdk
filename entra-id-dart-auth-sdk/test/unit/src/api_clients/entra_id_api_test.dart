import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';

void main() {
  group('EntraIdApiId', () {
    test('should throw ArgumentError for invalid API ID (too short)', () {
      expect(() => EntraIdApiId('ab'), throwsA(isA<ArgumentError>()));
    });

    test('should throw ArgumentError for invalid API ID (too long)', () {
      final longId = 'a' * 51; // 51 characters
      expect(() => EntraIdApiId(longId), throwsA(isA<ArgumentError>()));
    });
  });
}
