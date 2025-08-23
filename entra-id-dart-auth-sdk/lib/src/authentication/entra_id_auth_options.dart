/// AortemEntraIdAuthOptions encapsulates the authentication configuration
/// parameters for the Aortem EntraId Dart SDK.
///
/// This class ensures proper validation and provides a structured way to
/// configure authentication settings such as `clientId`, `authority`, and
/// `redirectUri`.
class AortemEntraIdAuthOptions {
  /// The client ID of the application registered in Entra ID.
  final String clientId;

  /// The authority URL (e.g., tenant-specific or common endpoint).
  final String authority;

  /// The redirect URI for handling authentication responses.
  final String redirectUri;

  /// Additional scopes to request during authentication.
  final List<String>? scopes;

  AortemEntraIdAuthOptions._({
    required this.clientId,
    required this.authority,
    required this.redirectUri,
    this.scopes,
  });

  /// Factory constructor that validates and initializes authentication options.
  factory AortemEntraIdAuthOptions({
    required String clientId,
    required String authority,
    required String redirectUri,
    List<String>? scopes,
  }) {
    if (clientId.isEmpty) {
      throw ArgumentError('clientId is required and cannot be empty.');
    }
    if (!_isValidUrl(authority)) {
      throw ArgumentError('Invalid authority URL: $authority');
    }
    if (!_isValidUrl(redirectUri)) {
      throw ArgumentError('Invalid redirect URI: $redirectUri');
    }

    return AortemEntraIdAuthOptions._(
      clientId: clientId,
      authority: authority,
      redirectUri: redirectUri,
      scopes: scopes,
    );
  }

  /// Validates if a given string is a properly formatted URL.
  static bool _isValidUrl(String url) {
    final Uri? uri = Uri.tryParse(url);
    return uri != null && uri.hasScheme && uri.host.isNotEmpty;
  }

  @override
  String toString() {
    return 'AortemEntraIdAuthOptions(clientId: $clientId, authority: $authority, redirectUri: $redirectUri, scopes: $scopes)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AortemEntraIdAuthOptions &&
          other.clientId == clientId &&
          other.authority == authority &&
          other.redirectUri == redirectUri &&
          other.scopes == scopes);

  @override
  int get hashCode =>
      clientId.hashCode ^
      authority.hashCode ^
      redirectUri.hashCode ^
      scopes.hashCode;
}
