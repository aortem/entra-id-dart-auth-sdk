/// A class that manages API identifiers for the Aortem EntraId Dart SDK.
///
/// This class ensures that API identifiers are standardized, validated,
/// and consistently used across different SDK components.
class EntraIdApiId {
  /// The API identifier.
  final String _apiId;

  /// Private constructor to enforce validation before instantiation.
  EntraIdApiId._(this._apiId);

  /// Factory constructor to validate and create an instance.
  ///
  /// Throws an [ArgumentError] if the provided API identifier is invalid.
  factory EntraIdApiId(String apiId) {
    if (!_isValidApiId(apiId)) {
      throw ArgumentError('Invalid API Identifier: $apiId');
    }
    return EntraIdApiId._(apiId);
  }

  /// Returns the API identifier value.
  String get value => _apiId;

  /// Validates the API identifier format.
  ///
  /// An API identifier is considered valid if it consists of 3 to 50
  /// alphanumeric characters, underscores, or hyphens.
  static bool _isValidApiId(String apiId) {
    final RegExp apiIdPattern = RegExp(r'^[a-zA-Z0-9_-]{3,50}\$');
    return apiIdPattern.hasMatch(apiId);
  }

  @override
  String toString() => 'EntraIdApiId($_apiId)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntraIdApiId && other._apiId == _apiId);

  @override
  int get hashCode => _apiId.hashCode;
}
