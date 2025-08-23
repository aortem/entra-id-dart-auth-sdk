import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';

void main() {
  group('AortemEntraIdApiId', () {
    test('should throw ArgumentError for invalid API ID (too short)', () {
      expect(() => AortemEntraIdApiId('ab'), throwsA(isA<ArgumentError>()));
    });

    test('should throw ArgumentError for invalid API ID (too long)', () {
      final longId = 'a' * 51; // 51 characters
      expect(() => AortemEntraIdApiId(longId), throwsA(isA<ArgumentError>()));
    });
  });
}
