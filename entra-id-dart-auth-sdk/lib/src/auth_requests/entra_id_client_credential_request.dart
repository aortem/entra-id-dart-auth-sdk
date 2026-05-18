import 'dart:convert';
import 'dart:async';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// EntraIdClientCredentialRequest:
/// Handles the client credential flow for confidential clients in the Aortem EntraId Dart SDK.
class EntraIdClientCredentialRequest {
  /// Default assertion type for Entra ID client assertion flows.
  static const String defaultClientAssertionType =
      'urn:ietf:params:oauth:client-assertion-type:jwt-bearer';

  /// The client ID of the confidential client application.
  final String clientId;

  /// The client secret of the confidential client application.
  final String? clientSecret;

  /// The client assertion used for workload identity or certificate-backed flows.
  final String? clientAssertion;

  /// The assertion type sent to the token endpoint when [clientAssertion] is used.
  final String clientAssertionType;

  /// The authority URL (e.g., Azure AD endpoint).
  final String authority;

  /// The tenant ID representing the directory or organization.
  final String tenantId;

  /// Optional fully-qualified token endpoint.
  final Uri? tokenEndpoint;

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
  EntraIdClientCredentialRequest({
    required this.clientId,
    required this.clientSecret,
    required this.authority,
    required this.tenantId,
    required this.scopes,
    http.Client? client,
  }) : clientAssertion = null,
       clientAssertionType = defaultClientAssertionType,
       tokenEndpoint = null,
       client =
           client ??
           http.Client(); // Default to using the global `http.Client` if none provided.

  /// Assertion-backed client credential flow used by WIF and similar token exchanges.
  EntraIdClientCredentialRequest.assertion({
    required this.clientId,
    required this.clientAssertion,
    required this.authority,
    required this.tenantId,
    required this.scopes,
    this.clientAssertionType = defaultClientAssertionType,
    http.Client? client,
  }) : clientSecret = null,
       tokenEndpoint = null,
       client =
           client ??
           http.Client(); // Default to using the global `http.Client` if none provided.

  /// Secret-backed flow using a fully-qualified token endpoint.
  EntraIdClientCredentialRequest.tokenEndpoint({
    required this.clientId,
    required this.clientSecret,
    required Uri this.tokenEndpoint,
    required this.scopes,
    http.Client? client,
  }) : clientAssertion = null,
       clientAssertionType = defaultClientAssertionType,
       authority = '',
       tenantId = '',
       client =
           client ??
           http.Client(); // Default to using the global `http.Client` if none provided.

  /// Assertion-backed flow using a fully-qualified token endpoint.
  EntraIdClientCredentialRequest.tokenEndpointAssertion({
    required this.clientId,
    required this.clientAssertion,
    required Uri this.tokenEndpoint,
    required this.scopes,
    this.clientAssertionType = defaultClientAssertionType,
    http.Client? client,
  }) : client = client ?? http.Client(),
       clientSecret = null,
       authority = '',
       tenantId = '';

  /// Acquire an access token using the client credentials flow.
  ///
  /// - Returns a [Future] that resolves to a [Map<String, dynamic>] containing the token response.
  /// - Validates required credentials and constructs a POST request to acquire the token.
  ///
  /// Throws an [ArgumentError] if required credentials or tenant ID are empty.
  /// Throws an [Exception] if the token request fails or an error occurs during the process.
  Future<Map<String, dynamic>> acquireToken() async {
    // Validate credentials
    if (clientId.isEmpty) {
      throw ArgumentError('Client ID must be provided.');
    }
    if (scopes.isEmpty) {
      throw ArgumentError('At least one scope must be provided.');
    }
    final hasSecret = clientSecret != null && clientSecret!.isNotEmpty;
    final hasAssertion = clientAssertion != null && clientAssertion!.isNotEmpty;
    if (hasSecret == hasAssertion) {
      throw ArgumentError(
        'Exactly one client credential must be provided: either clientSecret or clientAssertion.',
      );
    }
    if (tokenEndpoint == null && (authority.isEmpty || tenantId.isEmpty)) {
      throw ArgumentError(
        'Authority and tenant ID must be provided when tokenEndpoint is not supplied.',
      );
    }

    // Prepare the token request URL
    final url =
        tokenEndpoint ?? Uri.parse('$authority/$tenantId/oauth2/v2.0/token');

    // Prepare the token request body
    final body = {
      'grant_type': 'client_credentials',
      'client_id': clientId,
      'scope': scopes.join(' '),
    };
    if (hasSecret) {
      body['client_secret'] = clientSecret!;
    } else {
      body['client_assertion'] = clientAssertion!;
      body['client_assertion_type'] = clientAssertionType;
    }

    try {
      // Send the request
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );

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
