import 'package:logging/logging.dart';
import 'package:ds_standard_features/ds_standard_features.dart';

/// Configuration class for the Entra ID Authentication SDK.
/// Manages global settings and configurations for authentication workflows.
class AortemEntraIdConfiguration {
  final Logger _logger = Logger('AortemEntraIdConfiguration');

  /// The client ID of the application registered in Entra ID
  final String clientId;

  /// The tenant ID for the Entra ID instance
  final String tenantId;

  /// The authority URL for the Entra ID instance
  final String authority;

  /// The redirect URI for the application
  final String? redirectUri;

  /// Whether to enable debug logging
  final bool enableDebugLogging;

  /// The environment (e.g., 'production', 'staging')
  final String environment;

  /// Cache configuration settings
  final Map<String, dynamic> cacheOptions;

  /// Telemetry settings
  final Map<String, dynamic> telemetryOptions;

  /// Network timeout settings in seconds
  final int timeoutInSeconds;

  /// Custom headers to be included in requests
  final Map<String, String>? customHeaders;

  /// Creates a new instance of AortemEntraIdConfiguration
  ///
  /// Required parameters:
  /// - [clientId]: The client ID from Entra ID application registration
  /// - [tenantId]: The tenant ID for the Entra ID instance
  /// - [authority]: The authority URL for authentication
  AortemEntraIdConfiguration({
    required this.clientId,
    required this.tenantId,
    required this.authority,
    this.redirectUri,
    this.enableDebugLogging = false,
    this.environment = 'production',
    this.cacheOptions = const {},
    this.telemetryOptions = const {},
    this.timeoutInSeconds = 30,
    this.customHeaders,
  }) {
    _validateConfiguration();
    _initializeLogging();
  }

  /// Factory method to create configuration from JSON
  factory AortemEntraIdConfiguration.fromJson(Map<String, dynamic> json) {
    return AortemEntraIdConfiguration(
      clientId: json['clientId'] as String,
      tenantId: json['tenantId'] as String,
      authority: json['authority'] as String,
      redirectUri: json['redirectUri'] as String?,
      enableDebugLogging: json['enableDebugLogging'] as bool? ?? false,
      environment: json['environment'] as String? ?? 'production',
      cacheOptions: json['cacheOptions'] as Map<String, dynamic>? ?? {},
      telemetryOptions: json['telemetryOptions'] as Map<String, dynamic>? ?? {},
      timeoutInSeconds: json['timeoutInSeconds'] as int? ?? 30,
      customHeaders: (json['customHeaders'] as Map<String, dynamic>?)
          ?.cast<String, String>(),
    );
  }

  /// Converts configuration to JSON
  Map<String, dynamic> toJson() {
    return {
      'clientId': clientId,
      'tenantId': tenantId,
      'authority': authority,
      'redirectUri': redirectUri,
      'enableDebugLogging': enableDebugLogging,
      'environment': environment,
      'cacheOptions': cacheOptions,
      'telemetryOptions': telemetryOptions,
      'timeoutInSeconds': timeoutInSeconds,
      'customHeaders': customHeaders,
    };
  }

  /// Validates the configuration parameters
  void _validateConfiguration() {
    if (clientId.isEmpty) {
      throw ArgumentError('Client ID cannot be empty');
    }
    if (tenantId.isEmpty) {
      throw ArgumentError('Tenant ID cannot be empty');
    }
    if (authority.isEmpty) {
      throw ArgumentError('Authority cannot be empty');
    }
    if (!Uri.parse(authority).isAbsolute) {
      throw ArgumentError('Authority must be a valid URI');
    }

    _logger.info('Configuration validated successfully');
  }

  /// Initializes logging based on configuration
  void _initializeLogging() {
    if (enableDebugLogging) {
      Logger.root.level = Level.ALL;
      Logger.root.onRecord.listen((record) {
        print('${record.level.name}: ${record.time}: ${record.message}');
      });
      _logger.info('Debug logging enabled');
    }
  }

  /// Gets the complete authority URL including the tenant ID
  String get authorityUrl => '$authority/$tenantId';

  /// Gets the base API endpoint for Entra ID operations
  String get apiEndpoint => '$authority/$tenantId/oauth2/v2.0';

  /// Creates a copy of the configuration with updated values
  AortemEntraIdConfiguration copyWith({
    String? clientId,
    String? tenantId,
    String? authority,
    String? redirectUri,
    bool? enableDebugLogging,
    String? environment,
    Map<String, dynamic>? cacheOptions,
    Map<String, dynamic>? telemetryOptions,
    int? timeoutInSeconds,
    Map<String, String>? customHeaders,
  }) {
    return AortemEntraIdConfiguration(
      clientId: clientId ?? this.clientId,
      tenantId: tenantId ?? this.tenantId,
      authority: authority ?? this.authority,
      redirectUri: redirectUri ?? this.redirectUri,
      enableDebugLogging: enableDebugLogging ?? this.enableDebugLogging,
      environment: environment ?? this.environment,
      cacheOptions: cacheOptions ?? this.cacheOptions,
      telemetryOptions: telemetryOptions ?? this.telemetryOptions,
      timeoutInSeconds: timeoutInSeconds ?? this.timeoutInSeconds,
      customHeaders: customHeaders ?? this.customHeaders,
    );
  }
}
