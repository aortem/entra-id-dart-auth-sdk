import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';

import 'dart:convert';
// Adjust the import according to your project structure

void main() {
  group('EntraIdSerializer', () {
    test('should serialize an entity to JSON string', () {
      final entity = {'name': 'John Doe', 'age': 30};

      // Serialize the entity
      final jsonString = EntraIdSerializer.serialize(entity);

      // Check if the result is a valid JSON string
      expect(jsonString, isA<String>());
      expect(jsonDecode(jsonString), equals(entity));
    });

    test('should throw an ArgumentError when serialization fails', () {
      invalidEntity() => {};

      // Attempt to serialize an invalid entity
      expect(
        () => EntraIdSerializer.serialize(invalidEntity),
        throwsArgumentError,
      );
    });

    test('should deserialize a JSON string into a Map', () {
      final jsonString = '{"name": "John Doe", "age": 30}';

      // Deserialize the JSON string
      final map = EntraIdSerializer.deserialize(jsonString);

      // Check if the deserialized map matches the expected structure
      expect(map, isA<Map<String, dynamic>>());
      expect(map['name'], 'John Doe');
      expect(map['age'], 30);
    });

    test(
      'should throw an ArgumentError when deserialization fails due to empty JSON',
      () {
        const emptyJsonString = '';

        // Attempt to deserialize an empty JSON string
        expect(
          () => EntraIdSerializer.deserialize(emptyJsonString),
          throwsArgumentError,
        );
      },
    );

    test(
      'should throw an ArgumentError when deserialization fails due to invalid JSON',
      () {
        const invalidJsonString = '{name: John Doe, age: 30}'; // Invalid JSON

        // Attempt to deserialize an invalid JSON string
        expect(
          () => EntraIdSerializer.deserialize(invalidJsonString),
          throwsArgumentError,
        );
      },
    );

    test(
      'should deserialize JSON string into specific type using factory function',
      () {
        final jsonString = '{"name": "John Doe", "age": 30}';

        // Define a factory function to convert the map into a specific type
        fromJsonFactory(Map<String, dynamic> map) => Person.fromJson(map);

        // Deserialize using the factory function
        final person = EntraIdSerializer.deserializeTo<Person>(
          jsonString,
          fromJsonFactory,
        );

        // Check if the deserialized object is of the expected type and has correct data
        expect(person, isA<Person>());
        expect(person.name, 'John Doe');
        expect(person.age, 30);
      },
    );

    test(
      'should throw an ArgumentError when deserialization to type fails',
      () {
        final jsonString = '{"name": "John Doe", "age": "invalid-age"}';

        // Define a factory function that expects an integer for age
        fromJsonFactory(Map<String, dynamic> map) => Person.fromJson(map);

        // Attempt to deserialize with invalid data type
        expect(
          () => EntraIdSerializer.deserializeTo<Person>(
            jsonString,
            fromJsonFactory,
          ),
          throwsArgumentError,
        );
      },
    );
  });
}

// Example class for deserialization tests
class Person {
  final String name;
  final int age;

  Person({required this.name, required this.age});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(name: json['name'], age: json['age']);
  }
}
