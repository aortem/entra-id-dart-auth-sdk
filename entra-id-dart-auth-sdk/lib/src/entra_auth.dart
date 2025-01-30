import 'package:logging/logging.dart';
import 'auth/auth_entra_id_configuration.dart';
import 'auth/auth_crypto_provider.dart';
import 'auth/auth_entra_id_deserializer.dart';

/// Main class providing access to all Entra ID authentication functionality
class EntraAuth {
  final Logger _logger = Logger('EntraAuth');
  final AortemEntraIdConfiguration _configuration;

  EntraAuth(this._configuration) {
    _logger.info('Initializing EntraAuth with configuration');
  }

  /// Initialize configuration
  AortemEntraIdConfiguration get configuration => _configuration;

  /// Configuration methods
  Future<void> initialize() async {
    _logger.info('Initializing SDK components');
    // TODO: Implement initialization logic
  }

  /// Gets the current SDK version
  String getVersion() => SDK_VERSION;

  // TODO: Add method signatures for other features as they are implemented:
  // - Authentication flows
  // - Token management
  // - Cache operations
  // - Client applications
}

/// SDK Version
const String SDK_VERSION = '0.0.1-pre+1';
