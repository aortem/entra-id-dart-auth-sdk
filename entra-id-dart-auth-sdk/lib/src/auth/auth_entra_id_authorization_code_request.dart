import 'package:entra_id_dart_auth_sdk/utils/encoding_utils.dart';
import 'package:logging/logging.dart';

/// Parameters for an authorization code token request
class AuthorizationCodeRequestParameters {
  /// The authorization code received from the auth endpoint
  final String authorizationCode;

  /// The redirect URI used in the initial request
  final String redirectUri;

  /// The client ID of the application
  final String clientId;

  /// Optional client secret for confidential clients
  final String? clientSecret;

  /// Optional PKCE code verifier
  final String? codeVerifier;

  /// Optional scopes to request
  final List<String>? scopes;

  /// Optional correlation ID for request tracing
  final String? correlationId;

  /// Creates a new instance of AuthorizationCodeRequestParameters
  AuthorizationCodeRequestParameters({
    required this.authorizationCode,
    required this.redirectUri,
    required this.clientId,
    this.clientSecret,
    this.codeVerifier,
    this.scopes,
    this.correlationId,
  });

  /// Creates a copy with modified fields
  AuthorizationCodeRequestParameters copyWith({
    String? authorizationCode,
    String? redirectUri,
    String? clientId,
    String? clientSecret,
    String? codeVerifier,
    List<String>? scopes,
    String? correlationId,
  }) {
    return AuthorizationCodeRequestParameters(
      authorizationCode: authorizationCode ?? this.authorizationCode,
      redirectUri: redirectUri ?? this.redirectUri,
      clientId: clientId ?? this.clientId,
      clientSecret: clientSecret ?? this.clientSecret,
      codeVerifier: codeVerifier ?? this.codeVerifier,
      scopes: scopes ?? this.scopes,
      correlationId: correlationId ?? this.correlationId,
    );
  }
}

/// Exception thrown for authorization code request errors
class AuthorizationCodeException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  AuthorizationCodeException(this.message, {this.code, this.details});

  @override
  String toString() => 'AuthorizationCodeException: $message (Code: $code)';
}

/// Handles authorization code token requests
class AortemEntraIdAuthorizationCodeRequest {
  final Logger _logger = Logger('AortemEntraIdAuthorizationCodeRequest');

  /// The token endpoint URL
  final String tokenEndpoint;

  /// Parameters for the token request
  final AuthorizationCodeRequestParameters parameters;

  /// Creates a new instance of AortemEntraIdAuthorizationCodeRequest
  AortemEntraIdAuthorizationCodeRequest({
    required this.tokenEndpoint,
    required this.parameters,
  }) {
    _validateParameters();
  }

  /// Validates the request parameters
  void _validateParameters() {
    try {
      if (parameters.authorizationCode.isEmpty) {
        throw AuthorizationCodeException(
          'Authorization code cannot be empty',
          code: 'empty_auth_code',
        );
      }
      if (parameters.redirectUri.isEmpty) {
        throw AuthorizationCodeException(
          'Redirect URI cannot be empty',
          code: 'empty_redirect_uri',
        );
      }
      if (parameters.clientId.isEmpty) {
        throw AuthorizationCodeException(
          'Client ID cannot be empty',
          code: 'empty_client_id',
        );
      }
      if (!Uri.parse(parameters.redirectUri).isAbsolute) {
        throw AuthorizationCodeException(
          'Redirect URI must be a valid absolute URI',
          code: 'invalid_redirect_uri',
        );
      }

      _logger.info('Authorization code parameters validated successfully');
    } catch (e) {
      _logger.severe('Parameter validation failed', e);
      rethrow;
    }
  }

  /// Builds the token request body
  Map<String, String> buildRequestBody() {
    try {
      final body = {
        'grant_type': 'authorization_code',
        'code': parameters.authorizationCode,
        'redirect_uri': parameters.redirectUri,
        'client_id': parameters.clientId,
      };

      // Add client secret if provided (confidential clients)
      if (parameters.clientSecret != null) {
        body['client_secret'] = parameters.clientSecret!;
      }

      // Add PKCE code verifier if provided
      if (parameters.codeVerifier != null) {
        body['code_verifier'] = parameters.codeVerifier!;
      }

      // Add scopes if provided
      if (parameters.scopes != null && parameters.scopes!.isNotEmpty) {
        body['scope'] = parameters.scopes!.join(' ');
      }

      _logger.info('Built token request for authorization code flow');
      return body;
    } catch (e) {
      _logger.severe('Failed to build token request body', e);
      throw AuthorizationCodeException(
        'Failed to build token request body',
        code: 'body_build_failed',
        details: e,
      );
    }
  }

  /// Gets the required headers for the token request
  Map<String, String> getHeaders() {
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    // Add basic auth header for confidential clients
    if (parameters.clientSecret != null) {
      final credentials = AortemEntraIdEncodingUtils.encodeBase64(
        '${parameters.clientId}:${parameters.clientSecret}',
      );
      headers['Authorization'] = 'Basic $credentials';
    }

    // Add correlation ID if provided
    if (parameters.correlationId != null) {
      headers['client-request-id'] = parameters.correlationId!;
    }

    return headers;
  }

  /// Validates the authorization code response
  static bool validateAuthorizationCodeResponse(
    Uri responseUri,
    String expectedState, {
    bool requireIdToken = false,
  }) {
    final params = responseUri.queryParameters;

    // Check for error response
    if (params.containsKey('error')) {
      throw AuthorizationCodeException(
        'Authorization error: ${params['error']}',
        code: params['error'],
        details: params['error_description'],
      );
    }

    // Validate required parameters
    if (!params.containsKey('code')) {
      throw AuthorizationCodeException(
        'Authorization response missing required code parameter',
        code: 'missing_code',
      );
    }

    // Validate state parameter
    final receivedState = params['state'];
    if (receivedState != expectedState) {
      throw AuthorizationCodeException(
        'State mismatch in authorization response',
        code: 'state_mismatch',
      );
    }

    // Validate id_token if required
    if (requireIdToken && !params.containsKey('id_token')) {
      throw AuthorizationCodeException(
        'ID token required but not received',
        code: 'missing_id_token',
      );
    }

    return true;
  }

  /// Validates a token response
  static bool validateTokenResponse(Map<String, dynamic> response) {
    if (!response.containsKey('access_token')) {
      throw AuthorizationCodeException(
        'Token response missing required access_token',
        code: 'missing_access_token',
      );
    }

    if (!response.containsKey('token_type')) {
      throw AuthorizationCodeException(
        'Token response missing required token_type',
        code: 'missing_token_type',
      );
    }

    return true;
  }
}
