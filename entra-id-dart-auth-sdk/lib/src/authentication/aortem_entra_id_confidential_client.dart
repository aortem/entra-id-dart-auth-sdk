import 'package:entra_id_dart_auth_sdk/src/enum/aortem_entra_id_confidential_client_enum.dart';
import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// A client application for authenticating with Microsoft Entra ID.
/// This class supports different authentication mechanisms, including
/// client secrets, certificates, and assertions. It allows you to acquire
/// tokens that are necessary to access resources on behalf of the client,
/// or refresh existing tokens when needed.
///
/// The `AortemEntraIdConfidentialClientApplication` class is typically used
/// to authenticate applications that are confidential clients (such as web apps
/// or daemons) and to interact with APIs like Microsoft Graph.
///
/// ## Authentication Mechanisms:
/// - **Client Secret:** Acquires a token using a client secret.
/// - **Certificate:** Acquires a token using a certificate (simplified for demo).
/// - **Assertion:** Acquires a token using a client assertion (JWT).
/// - **Token Refresh:** Refreshes an expired token using the refresh token.
/// - **On-Behalf-Of Flow:** Acquires a token on behalf of another user using their token.

class AortemEntraIdConfidentialClientApplication {
  /// The client ID associated with the Entra ID application.
  /// This is a unique identifier for the application registered in Microsoft Entra ID.
  final String clientId;

  /// The authority URL for Microsoft Entra ID (e.g., `https://login.microsoftonline.com/{tenant}`).
  /// This URL represents the identity provider's endpoint for OAuth2 token requests.
  final String authority;

  /// The credential used to authenticate the client application.
  /// This can be a client secret, certificate, or an assertion, depending on the `credentialType`.
  final String credential;

  /// The type of credential being used for authentication.
  /// It determines whether the `credential` is a client secret, certificate, or assertion.
  final CredentialType credentialType;

  /// A flag indicating whether legacy protocols are allowed for this client application.
  /// If set to `true`, it permits older authentication protocols that may be deprecated or less secure.
  final bool allowLegacyProtocols;

  /// Constructor to initialize the client application.
  ///
  /// [clientId] - The unique identifier for the client application in Entra ID.
  /// [authority] - The authority (e.g., Azure AD endpoint) used for authentication.
  /// [credential] - The credential to be used for authentication (client secret, certificate, or assertion).
  /// [credentialType] - Type of credential being used (e.g., secret, certificate, or assertion).
  /// [allowLegacyProtocols] - Whether to allow legacy protocols (defaults to false).
  AortemEntraIdConfidentialClientApplication({
    required this.clientId,
    required this.authority,
    required this.credential,
    this.credentialType = CredentialType.secret,
    this.allowLegacyProtocols = false,
  });

  /// Validates the configuration of the client application.
  ///
  /// Throws an [ArgumentError] if:
  /// - The [credential] is empty.
  /// - The [authority] does not use HTTPS.
  void validateConfiguration() {
    if (credential.isEmpty) {
      throw ArgumentError('Credential cannot be empty');
    }
    if (!authority.startsWith('https://')) {
      throw ArgumentError('Authority must use HTTPS');
    }
  }

  /// Acquires a token based on the configured credential type.
  ///
  /// Depending on the [credentialType], this method will:
  /// - Call [_acquireTokenWithSecret()] for client secrets.
  /// - Call [_acquireTokenWithCertificate()] for certificates.
  /// - Call [_acquireTokenWithAssertion()] for assertions (JWT).
  ///
  /// Returns a [Map<String, dynamic>] representing the token response.
  Future<Map<String, dynamic>> acquireToken() async {
    try {
      switch (credentialType) {
        case CredentialType.secret:
          return await _acquireTokenWithSecret();
        case CredentialType.certificate:
          return await _acquireTokenWithCertificate();
        case CredentialType.assertion:
          return await _acquireTokenWithAssertion();
      }
    } catch (e) {
      // Log error if needed
      rethrow;
    }
  }

  /// Acquires a token using the client secret.
  ///
  /// Makes an HTTP POST request to the Entra ID token endpoint using the client
  /// secret for authentication. This method supports the client credentials flow
  /// in OAuth 2.0.
  ///
  /// Returns a [Map<String, dynamic>] representing the token response.
  /// Throws an exception if the request fails or the response is not successful.
  Future<Map<String, dynamic>> _acquireTokenWithSecret() async {
    final response = await http.post(
      Uri.parse('$authority/oauth2/v2.0/token'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'client_id': clientId,
        'client_secret': credential,
        'grant_type': 'client_credentials',
        'scope': 'https://graph.microsoft.com/.default',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to acquire token with client secret: ${response.body}');
    }
  }

  /// Acquires a token using a certificate.
  ///
  /// Similar to acquiring a token with a secret, but uses a certificate for
  /// client authentication. This implementation is simplified, and in practice,
  /// the certificate should be properly loaded and used for the request.
  ///
  /// Returns a [Map<String, dynamic>] representing the token response.
  /// Throws an exception if the request fails or the response is not successful.
  Future<Map<String, dynamic>> _acquireTokenWithCertificate() async {
    final response = await http.post(
      Uri.parse('$authority/oauth2/v2.0/token'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'client_id': clientId,
        'client_certificate':
            credential, // This is simplified; handle certificate properly in production
        'grant_type': 'client_credentials',
        'scope': 'https://graph.microsoft.com/.default',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to acquire token with certificate: ${response.body}');
    }
  }

  /// Acquires a token using an assertion (JWT).
  ///
  /// In this method, a client assertion (typically a JWT) is used to authenticate.
  /// This is commonly used when the client is acting on behalf of a user in OAuth 2.0 flows.
  ///
  /// Returns a [Map<String, dynamic>] representing the token response.
  /// Throws an exception if the request fails or the response is not successful.
  Future<Map<String, dynamic>> _acquireTokenWithAssertion() async {
    final response = await http.post(
      Uri.parse('$authority/oauth2/v2.0/token'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'client_id': clientId,
        'client_assertion': credential, // The assertion string (JWT)
        'grant_type': 'client_credentials',
        'scope': 'https://graph.microsoft.com/.default',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to acquire token with assertion: ${response.body}');
    }
  }

  /// Refreshes the token using the provided refresh token.
  ///
  /// The refresh token flow is part of the OAuth 2.0 specification. When the
  /// access token expires, you can use the refresh token to get a new access token.
  ///
  /// [refreshToken] - The refresh token previously obtained during the initial
  /// token request.
  ///
  /// Returns a [Map<String, dynamic>] representing the new token response.
  /// Throws an exception if the request fails or the response is not successful.
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    final response = await http.post(
      Uri.parse('$authority/oauth2/v2.0/token'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'client_id': clientId,
        'refresh_token': refreshToken,
        'grant_type': 'refresh_token',
        'scope': 'https://graph.microsoft.com/.default',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to refresh token: ${response.body}');
    }
  }

  /// Acquires a token on behalf of a user (OAuth 2.0 On-Behalf-Of flow).
  ///
  /// This flow allows the client to obtain an access token on behalf of a user
  /// using their existing token. The `assertion` parameter represents the user's
  /// existing token (e.g., a JWT) that can be exchanged for a new token.
  ///
  /// [userToken] - The user's token that will be used in the On-Behalf-Of flow.
  ///
  /// Returns a [Map<String, dynamic>] representing the token response.
  /// Throws an exception if the request fails or the response is not successful.
  Future<Map<String, dynamic>> acquireTokenOnBehalfOf(String userToken) async {
    final response = await http.post(
      Uri.parse('$authority/oauth2/v2.0/token'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'client_id': clientId,
        'client_secret': credential,
        'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
        'assertion': userToken, // The user's token
        'scope': 'https://graph.microsoft.com/.default',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to acquire token on behalf of user: ${response.body}');
    }
  }
}
