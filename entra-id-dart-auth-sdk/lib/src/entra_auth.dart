import 'package:logging/logging.dart'; // Provides logging capabilities for the SDK.
import 'auth/auth_entra_id_configuration.dart'; // Imports the configuration class for Entra ID.

/// Main class providing access to all Entra ID authentication functionality.
///
/// The `EntraAuth` class acts as the entry point for interacting with the Entra ID SDK.
/// It provides methods for configuration, authentication flows, token management,
/// cache operations, and managing client applications.
class EntraAuth {
  /// Logger instance for tracking SDK activities.
  final Logger _logger = Logger('EntraAuth');

  /// Configuration object for the Entra ID SDK.
  final AortemEntraIdConfiguration _configuration;

  /// Creates an instance of `EntraAuth` with the given configuration.
  ///
  /// Logs the initialization process for debugging and tracking.
  EntraAuth(this._configuration) {
    _logger.info('Initializing EntraAuth with configuration');
  }

  /// Retrieves the current SDK configuration.
  ///
  /// This getter provides access to the configuration object used to
  /// initialize the SDK.
  ///
  /// Example:
  /// ```dart
  /// final config = entraAuth.configuration;
  /// print(config.clientId);
  /// ```
  AortemEntraIdConfiguration get configuration => _configuration;

  /// Initializes the SDK components.
  ///
  /// This method is responsible for setting up necessary SDK resources,
  /// such as initializing internal services or loading configurations.
  ///
  /// Example:
  /// ```dart
  /// await entraAuth.initialize();
  /// ```
  Future<void> initialize() async {
    _logger.info('Initializing SDK components');
    // TODO: Implement initialization logic
  }

  /// Retrieves the current version of the Entra ID SDK.
  ///
  /// The version string follows semantic versioning conventions, indicating
  /// the current development state and any pre-release identifiers.
  ///
  /// Example:
  /// ```dart
  /// final version = entraAuth.getVersion();
  /// print('SDK Version: $version');
  /// ```
  String getVersion() => SDK_VERSION;

  // TODO: Add method signatures for other features as they are implemented:
  // - Authentication flows (e.g., device code, authorization code, implicit flows).
  // - Token management (e.g., access token renewal, revocation).
  // - Cache operations (e.g., token cache storage and retrieval).
  // - Client applications (e.g., creating and managing app registrations).
}

/// SDK Version
///
/// Defines the current version of the Entra ID SDK. This constant helps track
/// the release state of the SDK and follows semantic versioning.
///
/// Example:
/// ```dart
/// print(SDK_VERSION); // Output: 0.0.1-pre+1
/// ```
const String SDK_VERSION = '0.0.1-pre+1';
