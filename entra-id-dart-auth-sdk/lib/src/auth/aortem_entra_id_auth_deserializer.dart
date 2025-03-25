import 'dart:convert';
import 'package:logging/logging.dart';

/// AortemEntraIdDeserializer provides utilities to deserialize Entra ID JSON responses into SDK-specific entities.
class AortemEntraIdDeserializer {
  // Logger for error tracking
  static final _logger = Logger('AortemEntraIdDeserializer');

  /// Deserializes a token response from the Entra ID API.
  ///
  /// The response is expected to contain `access_token` and `expires_in`.
  ///
  /// Throws [FormatException] if the required fields are missing or if the response is invalid.
  ///
  /// Args:
  ///   jsonResponse (String): The raw JSON response from the Entra ID API.
  ///

  static Map<String, dynamic> deserializeTokenResponse(String jsonResponse) {
    try {
      final Map<String, dynamic> data = json.decode(jsonResponse);

      // Check for required fields
      if (!data.containsKey('access_token') ||
          !data.containsKey('expires_in')) {
        throw FormatException("Missing required fields in token response.");
      }

      return data;
    } catch (e) {
      _logger.severe("Failed to deserialize token response: $e");
      rethrow; // Re-throws the exception for higher-level handling
    }
  }

  /// Deserializes a user profile response from the Entra ID API.
  ///
  /// The response is expected to contain `id` and `displayName`.
  ///
  /// Throws [FormatException] if the required fields are missing or if the response is invalid.
  ///
  /// Args:
  ///   jsonResponse (String): The raw JSON response from the Entra ID API.
  ///

  static Map<String, dynamic> deserializeUserProfileResponse(
    String jsonResponse,
  ) {
    try {
      final Map<String, dynamic> data = json.decode(jsonResponse);

      // Check for required fields
      if (!data.containsKey('id') || !data.containsKey('displayName')) {
        throw FormatException(
          "Missing required fields in user profile response.",
        );
      }

      return data;
    } catch (e) {
      _logger.severe("Failed to deserialize user profile response: $e");
      rethrow;
    }
  }

  /// A generic method for deserializing any response type using a provided `fromJson` function.
  ///
  /// Args:
  ///   jsonResponse (String): The raw JSON response.
  ///   fromJson (Function): A function that converts the parsed JSON map into an object of type T.
  ///
  /// Returns:
  ///   T: The deserialized object.
  ///
  /// Throws [FormatException] if the response is invalid.
  static T deserializeResponse<T>(
    String jsonResponse,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    try {
      final Map<String, dynamic> data = json.decode(jsonResponse);
      return fromJson(data);
    } catch (e) {
      _logger.severe("Failed to deserialize response: $e");
      rethrow;
    }
  }

  /// Deserializes an error response from the Entra ID API.
  ///
  /// The response is expected to contain `error` and `error_description`.
  ///
  /// Throws [FormatException] if the required fields are missing or if the response is invalid.
  ///
  /// Args:
  ///   jsonResponse (String): The raw JSON error response.
  ///
  ///
  static Map<String, dynamic> deserializeErrorResponse(String jsonResponse) {
    try {
      final Map<String, dynamic> data = json.decode(jsonResponse);

      // Check for error details
      if (!data.containsKey('error') ||
          !data.containsKey('error_description')) {
        throw FormatException("Missing error details in the error response.");
      }

      return data;
    } catch (e) {
      _logger.severe("Failed to deserialize error response: $e");
      rethrow;
    }
  }
}
