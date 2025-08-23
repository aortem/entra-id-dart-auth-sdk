import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';

import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  group('AortemEntraIdGuidGenerator', () {
    test('generate should return a valid version 4 GUID', () {
      final guid = AortemEntraIdGuidGenerator.generate();

      // Validate the format of the GUID (xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx)
      final guidRegExp = RegExp(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89a-f][0-9a-f]{3}-[0-9a-f]{12}$',
      );
      expect(
        guidRegExp.hasMatch(guid),
        isTrue,
        reason: 'Generated GUID does not match version 4 format',
      );
    });

    test('generate should produce different GUIDs for multiple calls', () {
      final guid1 = AortemEntraIdGuidGenerator.generate();
      final guid2 = AortemEntraIdGuidGenerator.generate();

      // Assert that the GUIDs are different
      expect(
        guid1,
        isNot(equals(guid2)),
        reason: 'Generated GUIDs should be unique',
      );
    });
  });
}
