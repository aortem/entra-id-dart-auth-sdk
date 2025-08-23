import 'dart:async';

import 'package:entra_id_dart_auth_sdk/src/enum/entra_id_interactive_request_enum.dart';
import 'package:entra_id_dart_auth_sdk/src/exception/entra_id_interactive_request_exception.dart';
import 'package:entra_id_dart_auth_sdk/src/model/entra_id_authorization_url_request_model.dart';
import 'package:entra_id_dart_auth_sdk/src/model/entra_id_interactive_request_model.dart';
import 'package:ds_standard_features/ds_standard_features.dart';

import '../crypto/entra_id_crypto_provider.dart';
import '../utils/entra_id_guid_generator.dart';
import 'entra_id_authorization_url_request.dart';

/// Handles interactive authentication flows
class AortemEntraIdInteractiveRequest {
  final Logger _logger = Logger('AortemEntraIdInteractiveRequest');

  /// The authority URL for authentication
  final String authorityUrl;

  /// Parameters for the interactive request
  final InteractiveRequestParameters parameters;

  /// Current status of the authentication flow
  InteractiveRequestStatus _status = InteractiveRequestStatus.notStarted;

  /// Stream controller for status updates
  final _statusController =
      StreamController<InteractiveRequestStatus>.broadcast();

  /// Generated state parameter for CSRF protection
  late final String _state;

  /// Generated PKCE code verifier if PKCE is enabled
  String? _pkceCodeVerifier;

  /// Generated nonce for OpenID Connect flows
  late final String _nonce;

  /// Timer for authentication timeout
  Timer? _timeoutTimer;

  /// Creates a new instance of AortemEntraIdInteractiveRequest
  AortemEntraIdInteractiveRequest({
    required this.authorityUrl,
    required this.parameters,
  }) {
    _validateParameters();
    _initializeSecurityParameters();
  }

  /// Stream of authentication status updates
  Stream<InteractiveRequestStatus> get statusChanges =>
      _statusController.stream;

  /// Current authentication status
  InteractiveRequestStatus get status => _status;

  /// Validates the request parameters
  void _validateParameters() {
    try {
      if (parameters.clientId.isEmpty) {
        throw InteractiveRequestException(
          'Client ID cannot be empty',
          code: 'empty_client_id',
        );
      }
      if (parameters.redirectUri.isEmpty) {
        throw InteractiveRequestException(
          'Redirect URI cannot be empty',
          code: 'empty_redirect_uri',
        );
      }
      if (parameters.scopes.isEmpty) {
        throw InteractiveRequestException(
          'At least one scope must be specified',
          code: 'empty_scopes',
        );
      }
      if (!Uri.parse(parameters.redirectUri).isAbsolute) {
        throw InteractiveRequestException(
          'Redirect URI must be a valid absolute URI',
          code: 'invalid_redirect_uri',
        );
      }
    } catch (e) {
      _logger.severe('Parameter validation failed', e);
      rethrow;
    }
  }

  /// Initializes security parameters
  void _initializeSecurityParameters() {
    _state = AortemEntraIdGuidGenerator.generate();
    _nonce = AortemEntraIdGuidGenerator.generate();

    if (parameters.usePkce) {
      _pkceCodeVerifier =
          AortemEntraIdCryptoProvider.generatePkceCodeVerifier();
    }
  }

  /// Starts the interactive authentication flow
  Future<String> startAuthentication() async {
    try {
      _updateStatus(InteractiveRequestStatus.inProgress);
      _startTimeoutTimer();

      final urlRequest = AortemEntraIdAuthorizationUrlRequest(
        authorityUrl: authorityUrl,
        parameters: AuthorizationUrlRequestParameters(
          clientId: parameters.clientId,
          redirectUri: parameters.redirectUri,
          scopes: parameters.scopes,
          state: _state,
          loginHint: parameters.loginHint,
          domainHint: parameters.domainHint,
          prompt: parameters.prompt,
          correlationId: parameters.correlationId,
        ),
        pkceCodeChallenge: parameters.usePkce
            ? AortemEntraIdCryptoProvider.generatePkceCodeChallenge(
                _pkceCodeVerifier!,
              )
            : null,
        pkceCodeChallengeMethod: parameters.usePkce ? 'S256' : null,
      );

      final authUrl = urlRequest.buildUrl();
      _logger.info('Generated authentication URL with state: $_state');
      return authUrl;
    } catch (e) {
      _updateStatus(InteractiveRequestStatus.failed);
      rethrow;
    }
  }

  /// Handles the authentication response
  void handleAuthenticationResponse(Uri responseUri) {
    try {
      _validateAuthenticationResponse(responseUri);
      _updateStatus(InteractiveRequestStatus.completed);
    } catch (e) {
      _updateStatus(InteractiveRequestStatus.failed);
      rethrow;
    } finally {
      _timeoutTimer?.cancel();
    }
  }

  /// Validates the authentication response
  void _validateAuthenticationResponse(Uri responseUri) {
    final params = responseUri.queryParameters;

    // Check for error response
    if (params.containsKey('error')) {
      throw InteractiveRequestException(
        'Authentication error: ${params['error']}',
        code: params['error'],
        details: params['error_description'],
      );
    }

    // Validate required parameters
    if (!params.containsKey('code')) {
      throw InteractiveRequestException(
        'Authentication response missing required code parameter',
        code: 'missing_code',
      );
    }

    // Validate state parameter for CSRF protection
    final receivedState = params['state'];
    if (receivedState != _state) {
      throw InteractiveRequestException(
        'State mismatch in authentication response',
        code: 'state_mismatch',
        details: 'Expected: $_state, Received: $receivedState',
      );
    }

    _logger.info('Authentication response validated successfully');
  }

  /// Updates the authentication status and notifies listeners
  void _updateStatus(InteractiveRequestStatus newStatus) {
    _status = newStatus;
    _statusController.add(newStatus);
    _logger.info('Authentication status updated to: $newStatus');
  }

  /// Starts the timeout timer
  void _startTimeoutTimer() {
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(parameters.timeout, () {
      _updateStatus(InteractiveRequestStatus.timeout);
      _logger.warning(
        'Authentication timed out after ${parameters.timeout.inSeconds} seconds',
      );
    });
  }

  /// Gets the PKCE code verifier if PKCE was used
  String? get pkceCodeVerifier => _pkceCodeVerifier;

  /// Gets the state parameter used in the request
  String get state => _state;

  /// Gets the nonce parameter used in the request
  String get nonce => _nonce;

  /// Cancels the authentication flow
  void cancel() {
    _timeoutTimer?.cancel();
    _updateStatus(InteractiveRequestStatus.cancelled);
    _logger.info('Authentication flow cancelled by user');
  }

  /// Disposes of resources
  void dispose() {
    _timeoutTimer?.cancel();
    _statusController.close();
    _logger.info('Interactive request disposed');
  }

  /// Validates the token response
  bool validateTokenResponse(Map<String, dynamic> response) {
    try {
      if (!response.containsKey('access_token')) {
        throw InteractiveRequestException(
          'Token response missing required access_token',
          code: 'missing_access_token',
        );
      }

      if (!response.containsKey('token_type')) {
        throw InteractiveRequestException(
          'Token response missing required token_type',
          code: 'missing_token_type',
        );
      }

      // Validate ID token nonce if OpenID Connect flow
      if (parameters.scopes.contains('openid') &&
          response.containsKey('id_token')) {
        // TODO: Implement ID token nonce validation
      }

      _logger.info('Token response validated successfully');
      return true;
    } catch (e) {
      _logger.severe('Token response validation failed', e);
      rethrow;
    }
  }
}
