import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// AortemEntraIdUsernamePasswordRequest: Handles username and password authentication flow.
///
/// Acquires tokens by directly using the user's credentials.
class AortemEntraIdUsernamePasswordRequest {
  final String clientId;
  final String clientSecret;
  final String tenantId;
  final String authority;

  AortemEntraIdUsernamePasswordRequest({
    required this.clientId,
    required this.clientSecret,
    required this.tenantId,
    required this.authority,
  });

  /// Acquires tokens using username and password.
  ///
  /// [username] The user's username (e.g., email).
  /// [password] The user's password.
  ///
  /// Returns a map containing the access token, refresh token, and ID token.
  /// Throws [ArgumentError] or [Exception] for errors.
  Future<Map<String, dynamic>> acquireToken(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      throw ArgumentError('Username and password must not be empty.');
    }

    final url = '$authority/$tenantId/oauth2/v2.0/token';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'client_id': clientId,
        'client_secret': clientSecret,
        'scope': 'openid profile offline_access',
        'grant_type': 'password',
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(
        'Failed to acquire token. Error: ${error['error_description'] ?? response.body}',
      );
    }
  }
}
