import 'dart:convert';

/// EntraIdSerializer: Unified Serialization and Deserialization Utility.
///
/// Provides methods to serialize and deserialize entities into/from JSON format.
class EntraIdSerializer {
  /// Serializes an entity to a JSON string.
  ///
  /// [entity] is the object to serialize.
  /// Throws [ArgumentError] if the entity cannot be serialized.
  static String serialize(Object entity) {
    try {
      return jsonEncode(entity);
    } catch (e) {
      throw ArgumentError('Failed to serialize entity: ${e.toString()}');
    }
  }

  /// Deserializes a JSON string into a map.
  ///
  /// [jsonString] is the JSON string to deserialize.
  /// Throws [ArgumentError] if the JSON string is invalid or null.
  static Map<String, dynamic> deserialize(String jsonString) {
    try {
      if (jsonString.isEmpty) {
        throw ArgumentError('JSON string cannot be empty.');
      }
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      throw ArgumentError('Failed to deserialize JSON string: ${e.toString()}');
    }
  }

  /// Attempts to deserialize JSON string into a specific type using a provided factory function.
  ///
  /// [jsonString] is the JSON string to deserialize.
  /// [fromJsonFactory] is a function that converts a map to an entity.
  /// Throws [ArgumentError] for invalid JSON or unsupported formats.
  static T deserializeTo<T>(
    String jsonString,
    T Function(Map<String, dynamic>) fromJsonFactory,
  ) {
    try {
      final map = deserialize(jsonString);
      return fromJsonFactory(map);
    } catch (e) {
      throw ArgumentError('Failed to deserialize to type $T: ${e.toString()}');
    }
  }
}
