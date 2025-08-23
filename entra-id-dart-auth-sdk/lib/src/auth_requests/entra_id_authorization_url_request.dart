import 'package:entra_id_dart_auth_sdk/src/exception/entra_id_authorization_url_request_exception.dart';
import 'package:entra_id_dart_auth_sdk/src/model/entra_id_authorization_url_request_model.dart';
import 'package:ds_standard_features/ds_standard_features.dart';

import '../utils/entra_id_encoding_utils.dart';
import '../utils/entra_id_guid_generator.dart';

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

      final uri = Uri.parse(authorityUrl).replace(queryParameters: queryParams);

      _logger.info(
        'Built authorization URL with state: ${queryParams['state']}',
      );
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
