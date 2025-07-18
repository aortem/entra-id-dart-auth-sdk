import 'dart:convert';
import 'dart:async';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// AortemEntraIdClientCredentialRequest:
/// Handles the client credential flow for confidential clients in the Aortem EntraId Dart SDK.
class AortemEntraIdClientCredentialRequest {
  /// The client ID of the confidential client application.
  final String clientId;

  /// The client secret of the confidential client application.
  final String clientSecret;

  /// The authority URL (e.g., Azure AD endpoint).
  final String authority;

  /// The tenant ID representing the directory or organization.
  final String tenantId;

  /// A list of scopes for which the token is requested.
  final List<String> scopes;

  /// HTTP Client to perform network requests.
  final http.Client client;

  /// Constructor to initialize the client credential request.
  ///
  /// - [clientId]: The client ID of the confidential client application (required).
  /// - [clientSecret]: The client secret of the confidential client application (required).
  /// - [authority]: The authority URL (required, must be HTTPS).
  /// - [tenantId]: The tenant ID (required, cannot be empty).
  /// - [scopes]: A list of scopes for which the token is requested (required).
  /// - [client]: Custom HTTP client, defaults to `http.Client` if not provided.
  ///
  /// Throws an [ArgumentError] if any required parameter is missing or invalid.
  AortemEntraIdClientCredentialRequest({
    required this.clientId,
    required this.clientSecret,
    required this.authority,
    required this.tenantId,
    required this.scopes,
    http.Client? client,
  }) : client =
           client ??
           http.Client(); // Default to using the global `http.Client` if none provided.

  /// Acquire an access token using the client credentials flow.
  ///
  /// - Returns a [Future] that resolves to a [Map<String, dynamic>] containing the token response.
  /// - Validates required credentials and constructs a POST request to acquire the token.
  ///
  /// Throws an [ArgumentError] if required credentials or tenant ID are empty.
  /// Throws an [Exception] if the token request fails or an error occurs during the process.
  Future<Map<String, dynamic>> acquireToken() async {
    // Validate credentials
    if (clientId.isEmpty || clientSecret.isEmpty || tenantId.isEmpty) {
      throw ArgumentError('Client credentials and tenant ID must be provided.');
    }

    // Prepare the token request URL
    final url = Uri.parse('$authority/$tenantId/oauth2/v2.0/token');

    // Prepare the token request body
    final body = {
      'grant_type': 'client_credentials',
      'client_id': clientId,
      'client_secret': clientSecret,
      'scope': scopes.join(' '),
    };

    try {
      // Send the request
      final response = await client.post(url, body: body);

      // Handle the response
      if (response.statusCode == 200) {
        final Map<String, dynamic> tokenResponse = jsonDecode(response.body);
        return tokenResponse;
      } else {
        // Handle error response
        return _handleError(response);
      }
    } catch (e) {
      // Network errors or other exceptions
      throw Exception('Error during token acquisition: $e');
    }
  }

  /// Handles the error responses from Entra ID.
  ///
  /// - [response]: The HTTP response object that contains the error details.
  /// - Decodes and processes the error response to provide a meaningful exception.
  ///
  /// Throws an [Exception] with a detailed error message extracted from the response.
  Map<String, dynamic> _handleError(http.Response response) {
    final Map<String, dynamic> errorResponse = jsonDecode(response.body);
    print('Error: ${errorResponse['error_description']}');
    throw Exception(
      'Error acquiring token: ${errorResponse['error_description']}',
    );
  }
}
