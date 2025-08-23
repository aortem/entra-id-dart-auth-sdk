import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/utils/entra_id_serializer.dart';

class MockEntity {
  final String key;
  MockEntity({required this.key});

  factory MockEntity.fromJson(Map<String, dynamic> json) {
    return MockEntity(key: json['key'] as String);
  }

  Map<String, dynamic> toJson() => {'key': key};
}

void main() {
  group('AortemEntraIdSerializer', () {
    test('serialize should return JSON string', () {
      final entity = MockEntity(key: 'value');
      final jsonString = AortemEntraIdSerializer.serialize(entity.toJson());
      expect(jsonString, '{"key":"value"}');
    });

    test('deserialize should return Map from JSON string', () {
      final jsonString = '{"key":"value"}';
      final map = AortemEntraIdSerializer.deserialize(jsonString);
      expect(map['key'], 'value');
    });

    test('deserializeTo should return entity from JSON string', () {
      final jsonString = '{"key":"value"}';
      final entity = AortemEntraIdSerializer.deserializeTo<MockEntity>(
        jsonString,
        (json) => MockEntity.fromJson(json),
      );
      expect(entity.key, 'value');
    });

    test('serialize should throw ArgumentError for invalid input', () {
      expect(
        () => AortemEntraIdSerializer.serialize(Object()),
        throwsArgumentError,
      );
    });

    test('deserialize should throw ArgumentError for empty JSON string', () {
      expect(
        () => AortemEntraIdSerializer.deserialize(''),
        throwsArgumentError,
      );
    });

    test('deserialize should throw ArgumentError for invalid JSON', () {
      expect(
        () => AortemEntraIdSerializer.deserialize('invalid'),
        throwsArgumentError,
      );
    });
  });
}
