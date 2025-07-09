import 'dart:async';
import 'package:ds_standard_features/ds_standard_features.dart';
import 'package:entra_id_dart_auth_sdk/src/enum/aortem_entra_id_client_application_eum.dart';
import 'package:entra_id_dart_auth_sdk/src/exception/aortem_entra_id_client_application_exception.dart';
import '../cache/aortem_entra_id_cache_kv_store.dart';
import '../cache/aortem_entra_id_cache_options.dart';
import '../config/aortem_entra_id_configuration.dart';

/// Abstract base class for all client applications in the Entra ID SDK.
/// Provides core functionality for authentication and token management.
abstract class AortemEntraIdClientApplication {
  final Logger _logger = Logger('AortemEntraIdClientApplication');

  /// Configuration for the client application
  final AortemEntraIdConfiguration configuration;

  /// Cache store for tokens and other data
  late final AortemEntraIdCacheKVStore _cacheStore;

  /// Current status of the client application
  ClientApplicationStatus _status = ClientApplicationStatus.notInitialized;

  /// Stream controller for status changes
  final _statusController =
      StreamController<ClientApplicationStatus>.broadcast();

  /// Creates a new instance of AortemEntraIdClientApplication
  AortemEntraIdClientApplication(this.configuration) {
    _initializeApplication();
  }

  /// Stream of client application status changes
  Stream<ClientApplicationStatus> get statusChanges => _statusController.stream;

  /// Current status of the client application
  ClientApplicationStatus get status => _status;

  /// Initializes the client application and its dependencies
  void _initializeApplication() {
    try {
      _logger.info('Initializing client application');

      // Initialize cache store with default options
      _cacheStore = AortemEntraIdCacheKVStore(
        AortemEntraIdCacheOptions(namespace: configuration.clientId),
      );

      _updateStatus(ClientApplicationStatus.ready);
      _logger.info('Client application initialized successfully');
    } catch (e) {
      _logger.severe('Failed to initialize client application: $e');
      _updateStatus(ClientApplicationStatus.error);
      throw ClientApplicationException(
        'Failed to initialize client application',
        details: e,
      );
    }
  }

  /// Updates the application status and notifies listeners
  void _updateStatus(ClientApplicationStatus newStatus) {
    _status = newStatus;
    _statusController.add(newStatus);
  }

  /// Gets the authority host for the application
  String get authorityHost => configuration.authority;

  /// Gets the client ID for the application
  String get clientId => configuration.clientId;

  /// Gets the tenant ID for the application
  String get tenantId => configuration.tenantId;

  /// Validates whether the application is ready for use
  void _validateReady() {
    if (_status != ClientApplicationStatus.ready) {
      throw ClientApplicationException(
        'Client application is not ready',
        code: 'not_ready',
      );
    }
  }

  /// Acquires a token silently from the cache
  ///
  /// [scopes] The scopes required for the token
  /// Returns a token if found in cache, null otherwise
  Future<Map<String, dynamic>?> acquireTokenSilently(
    List<String> scopes,
  ) async {
    _validateReady();

    final cacheKey = _generateTokenCacheKey(scopes);
    return await _cacheStore.get(cacheKey);
  }

  /// Generates a cache key for token storage
  String _generateTokenCacheKey(List<String> scopes) {
    final scopeString = scopes.join(' ');
    return 'token:$clientId:$scopeString';
  }

  /// Clears the token cache
  Future<void> clearCache() async {
    _validateReady();
    await _cacheStore.clear();
  }

  /// Gets the redirect URI for the application
  String? get redirectUri => configuration.redirectUri;

  /// Validates the configuration for the specific client type
  /// Should be implemented by child classes
  @protected
  void validateConfiguration();

  /// Acquires a token using the appropriate flow
  /// Should be implemented by child classes
  @protected
  Future<Map<String, dynamic>> acquireToken();

  /// Handles token refresh
  /// Should be implemented by child classes
  @protected
  Future<Map<String, dynamic>> refreshToken(String refreshToken);

  /// Disposes of the client application resources
  Future<void> dispose() async {
    await _statusController.close();
    _cacheStore.dispose();
    _logger.info('Client application disposed');
  }

  /// Returns application metadata
  Map<String, dynamic> getApplicationMetadata() {
    return {
      'clientId': clientId,
      'authority': authorityHost,
      'status': status.toString(),
      'tenantId': tenantId,
      'redirectUri': redirectUri,
    };
  }

  /// Validates scopes for token requests
  @protected
  void validateScopes(List<String> scopes) {
    if (scopes.isEmpty) {
      throw ClientApplicationException(
        'Scopes cannot be empty',
        code: 'invalid_scopes',
      );
    }
  }

  /// Handles errors in a consistent way
  @protected
  Never handleError(String message, {String? code, dynamic details}) {
    _logger.severe('$message (Code: $code)', details);
    throw ClientApplicationException(message, code: code, details: details);
  }

  /// Updates application telemetry
  @protected
  void updateTelemetry(String eventName, Map<String, dynamic> properties) {
    _logger.fine('Telemetry event: $eventName, Properties: $properties');
  }
}
