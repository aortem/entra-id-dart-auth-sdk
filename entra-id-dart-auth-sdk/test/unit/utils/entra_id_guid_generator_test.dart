import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/utils/entra_id_guid_generator.dart';

void main() {
  group('EntraIdGuidGenerator', () {
    test('should generate a valid GUID', () {
      final guid = EntraIdGuidGenerator.generate();
      final guidPattern = RegExp(
        r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-4[0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$',
      );

      expect(guid, matches(guidPattern));
    });

    test('should generate unique GUIDs', () {
      final guid1 = EntraIdGuidGenerator.generate();
      final guid2 = EntraIdGuidGenerator.generate();

      expect(guid1, isNot(equals(guid2)));
    });

    test('should always generate GUIDs with version 4', () {
      final guid = EntraIdGuidGenerator.generate();
      final version = guid.split('-')[2][0]; // Get the version digit.

      expect(version, equals('4'));
    });
  });
}
