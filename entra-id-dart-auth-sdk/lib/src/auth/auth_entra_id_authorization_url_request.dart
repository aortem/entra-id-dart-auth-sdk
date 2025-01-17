import 'package:entra_id_dart_auth_sdk/utils/encoding_utils.dart';
import 'package:entra_id_dart_auth_sdk/utils/guid_generator.dart';
import 'package:logging/logging.dart';

/// Parameters for building an authorization URL request
class AuthorizationUrlRequestParameters {
  /// The client ID of the application
  final String clientId;

  /// The redirect URI for the authorization response
  final String redirectUri;

  /// The requested scopes
  final List<String> scopes;

  /// Optional state parameter for security validation
  final String? state;

  /// Optional login hint (username) to pre-fill
  final String? loginHint;

  /// Optional domain hint for authentication
  final String? domainHint;

  /// Optional prompt behavior
  final String? prompt;

  /// Optional correlation ID for request tracing
  final String? correlationId;

  /// Creates a new instance of AuthorizationUrlRequestParameters
  AuthorizationUrlRequestParameters({
    required this.clientId,
    required this.redirectUri,
    required this.scopes,
    this.state,
    this.loginHint,
    this.domainHint,
    this.prompt,
    this.correlationId,
  });

  /// Creates a copy with modified fields
  AuthorizationUrlRequestParameters copyWith({
    String? clientId,
    String? redirectUri,
    List<String>? scopes,
    String? state,
    String? loginHint,
    String? domainHint,
    String? prompt,
    String? correlationId,
  }) {
    return AuthorizationUrlRequestParameters(
      clientId: clientId ?? this.clientId,
      redirectUri: redirectUri ?? this.redirectUri,
      scopes: scopes ?? this.scopes,
      state: state ?? this.state,
      loginHint: loginHint ?? this.loginHint,
      domainHint: domainHint ?? this.domainHint,
      prompt: prompt ?? this.prompt,
      correlationId: correlationId ?? this.correlationId,
    );
  }
}

/// Exception thrown for authorization URL creation errors
class AuthorizationUrlException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  AuthorizationUrlException(this.message, {this.code, this.details});

  @override
  String toString() => 'AuthorizationUrlException: $message (Code: $code)';
}

/// Handles creation of authorization URLs for OAuth2 flows
class AortemEntraIdAuthorizationUrlRequest {
  final Logger _logger = Logger('AortemEntraIdAuthorizationUrlRequest');

  /// The base authorization endpoint
  final String authorityUrl;

  /// Parameters for the authorization request
  final AuthorizationUrlRequestParameters parameters;

  /// PKCE code challenge if PKCE is enabled
  final String? pkceCodeChallenge;

  /// PKCE code challenge method (e.g., 'S256')
  final String? pkceCodeChallengeMethod;

  /// Creates a new instance of AortemEntraIdAuthorizationUrlRequest
  AortemEntraIdAuthorizationUrlRequest({
    required this.authorityUrl,
    required this.parameters,
    this.pkceCodeChallenge,
    this.pkceCodeChallengeMethod,
  }) {
    _validateParameters();
  }

  /// Validates the request parameters
  void _validateParameters() {
    try {
      if (parameters.clientId.isEmpty) {
        throw AuthorizationUrlException(
          'Client ID cannot be empty',
          code: 'empty_client_id',
        );
      }
      if (parameters.redirectUri.isEmpty) {
        throw AuthorizationUrlException(
          'Redirect URI cannot be empty',
          code: 'empty_redirect_uri',
        );
      }
      if (parameters.scopes.isEmpty) {
        throw AuthorizationUrlException(
          'At least one scope must be specified',
          code: 'empty_scopes',
        );
      }
      if (!Uri.parse(parameters.redirectUri).isAbsolute) {
        throw AuthorizationUrlException(
          'Redirect URI must be a valid absolute URI',
          code: 'invalid_redirect_uri',
        );
      }

      // Validate PKCE parameters if provided
      if (pkceCodeChallenge != null && pkceCodeChallengeMethod == null) {
        throw AuthorizationUrlException(
          'PKCE code challenge method must be provided when using PKCE',
          code: 'invalid_pkce_config',
        );
      }

      _logger.info('Authorization URL parameters validated successfully');
    } catch (e) {
      _logger.severe('Parameter validation failed', e);
      rethrow;
    }
  }

  /// Builds the authorization URL with all parameters
  String buildUrl() {
    try {
      final queryParams = {
        'client_id': parameters.clientId,
        'response_type': 'code',
        'redirect_uri': parameters.redirectUri,
        'scope': parameters.scopes.join(' '),
        'state': parameters.state ?? AortemEntraIdGuidGenerator.generate(),
      };

      // Add PKCE parameters if provided
      if (pkceCodeChallenge != null) {
        queryParams['code_challenge'] = pkceCodeChallenge!;
        queryParams['code_challenge_method'] = pkceCodeChallengeMethod!;
      }

      // Add optional parameters if provided
      if (parameters.loginHint != null) {
        queryParams['login_hint'] = AortemEntraIdEncodingUtils.encodeUrl(
          parameters.loginHint!,
        );
      }
      if (parameters.domainHint != null) {
        queryParams['domain_hint'] = parameters.domainHint!;
      }
      if (parameters.prompt != null) {
        queryParams['prompt'] = parameters.prompt!;
      }
      if (parameters.correlationId != null) {
        queryParams['client-request-id'] = parameters.correlationId!;
      }

      final uri = Uri.parse(authorityUrl).replace(
        queryParameters: queryParams,
      );

      _logger
          .info('Built authorization URL with state: ${queryParams['state']}');
      return uri.toString();
    } catch (e) {
      _logger.severe('Failed to build authorization URL', e);
      throw AuthorizationUrlException(
        'Failed to build authorization URL',
        code: 'url_build_failed',
        details: e,
      );
    }
  }

  /// Validates a redirect URI against the expected URI
  static bool validateRedirectUri(String actualUri, String expectedUri) {
    try {
      final actual = Uri.parse(actualUri);
      final expected = Uri.parse(expectedUri);

      return actual.scheme == expected.scheme &&
          actual.host == expected.host &&
          actual.path == expected.path;
    } catch (e) {
      throw AuthorizationUrlException(
        'Failed to validate redirect URI',
        code: 'uri_validation_failed',
        details: e,
      );
    }
  }
}
