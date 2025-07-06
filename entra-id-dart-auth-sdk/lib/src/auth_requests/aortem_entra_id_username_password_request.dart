import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:entra_id_dart_auth_sdk/src/exception/aortem_entra_id_authorization_user_cancle_exception.dart';

/// AortemEntraIdUsernamePasswordRequest: Handles username and password authentication flow.
///
/// Acquires tokens by directly using the user's credentials.
/// AortemEntraIdUsernamePasswordRequest: Handles token acquisition using the username-password grant flow.
///
/// This class is responsible for acquiring access tokens, refresh tokens, and ID tokens
/// from Microsoft Entra ID using the Resource Owner Password Credentials (ROPC) flow.
///
/// Key Features:
/// - Uses client credentials (client ID, client secret, and tenant ID) for authentication.
/// - Acquires tokens by providing a user's username and password.
/// - Validates input and handles error responses gracefully.
///
/// Example usage:
/// ```dart
/// final request = AortemEntraIdUsernamePasswordRequest(
///   clientId: 'your-client-id',
///   clientSecret: 'your-client-secret',
///   tenantId: 'your-tenant-id',
///   authority: 'https://login.microsoftonline.com',
/// );
///
/// final tokens = await request.acquireToken('user@example.com', 'password123');
/// print('Access Token: ${tokens['access_token']}');
/// ```
class AortemEntraIdUsernamePasswordRequest {
  /// The client ID of the application registered in Microsoft Entra ID.
  final String clientId;

  /// The client secret associated with the application in Microsoft Entra ID.
  final String clientSecret;

  /// The tenant ID of the directory in Microsoft Entra ID.
  final String tenantId;

  /// The authority URL for token requests, e.g., `https://login.microsoftonline.com`.
  final String authority;

  /// Constructs an instance of `AortemEntraIdUsernamePasswordRequest`.
  ///
  /// - [clientId]: The application's client ID.
  /// - [clientSecret]: The application's client secret.
  /// - [tenantId]: The directory's tenant ID.
  /// - [authority]: The authority URL for authentication requests.
  AortemEntraIdUsernamePasswordRequest({
    required this.clientId,
    required this.clientSecret,
    required this.tenantId,
    required this.authority,
  });

  /// Acquires tokens using the Resource Owner Password Credentials (ROPC) flow.
  ///
  /// - [username]: The user's username (e.g., email address).
  /// - [password]: The user's password.
  ///
  /// Returns:
  /// A map containing the tokens, including:
  /// - `access_token`: The access token.
  /// - `refresh_token`: The refresh token.
  /// - `id_token`: The ID token.
  ///
  /// Throws:
  /// - [ArgumentError]: If the username or password is empty.
  /// - [AortemEntraIdUserCancelledException]: If the user cancels the authentication flow.
  /// - [Exception]: For HTTP errors or unexpected responses.
  ///
  /// Example:
  /// ```dart
  /// final tokens = await request.acquireToken('user@example.com', 'password123');
  /// print('Access Token: ${tokens['access_token']}');
  /// ```
  Future<Map<String, dynamic>> acquireToken(
    String username,
    String password, {
    http.Client? client, // Optional custom client for testing or production use
  }) async {
    // Ensure username and password are not empty
    if (username.isEmpty || password.isEmpty) {
      throw ArgumentError('Username and password must not be empty.');
    }

    // If no custom client is provided, use the default one
    final httpClient = client ?? http.Client();

    final url = '$authority/$tenantId/oauth2/v2.0/token';

    try {
      // Make the HTTP POST request
      final response = await httpClient.post(
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

      // Close the client if it was created locally (i.e., not passed in)
      if (client == null) {
        httpClient.close();
      }

      // Handle the response
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        final error = jsonDecode(response.body);
        // Check if the error is caused by user cancellation
        if (error['error'] == 'access_denied') {
          throw AortemEntraIdUserCancelledException();
        }
        throw Exception(
          'Failed to acquire token. Error: ${error['error_description'] ?? response.body}',
        );
      }
    } catch (e) {
      // Handle the exception gracefully
      rethrow; // Let the caller handle the error
    }
  }
}
