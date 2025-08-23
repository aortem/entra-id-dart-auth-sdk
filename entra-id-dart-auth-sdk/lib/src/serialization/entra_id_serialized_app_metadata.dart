import 'package:entra_id_dart_auth_sdk/src/enum/entra_id_app_enviroment_enum.dart';
import 'package:entra_id_dart_auth_sdk/src/enum/entra_id_application_type_enum.dart';
import 'package:entra_id_dart_auth_sdk/src/exception/entra_id_serialized_app_metadata_exception.dart';
import 'package:ds_standard_features/ds_standard_features.dart';

/// Represents application metadata for caching and configuration
class AortemEntraIdSerializedAppMetadataEntity {
  final Logger _logger = Logger('AortemEntraIdSerializedAppMetadataEntity');

  /// Client ID of the application
  final String clientId;

  /// Environment the application is running in
  final AppEnvironment environment;

  /// Display name of the application
  final String displayName;

  /// Application version
  final String version;

  /// Type of authentication used
  final AuthenticationType authenticationType;

  /// Redirect URIs configured for the application
  final List<String> redirectUris;

  /// Authority URL for authentication
  final String authority;

  /// Whether the application is a confidential client
  final bool isConfidentialClient;

  /// Allowed token issuers
  final List<String> allowedIssuers;

  /// Default scopes requested by the application
  final List<String> defaultScopes;

  /// Capabilities of the application
  final List<String> capabilities;

  /// Last metadata update time
  final DateTime lastUpdated;

  /// Whether PKCE is required
  final bool requiresPkce;

  /// Additional application properties
  final Map<String, dynamic> properties;

  /// Creates a new instance of AortemEntraIdSerializedAppMetadataEntity
  AortemEntraIdSerializedAppMetadataEntity({
    required this.clientId,
    required this.environment,
    required this.displayName,
    required this.version,
    required this.authenticationType,
    required this.redirectUris,
    required this.authority,
    required this.isConfidentialClient,
    required this.allowedIssuers,
    required this.defaultScopes,
    required this.capabilities,
    DateTime? lastUpdated,
    this.requiresPkce = true,
    this.properties = const {},
  }) : lastUpdated = lastUpdated ?? DateTime.now().toUtc() {
    _validateEntity();
  }

  /// Creates an app metadata entity from JSON
  factory AortemEntraIdSerializedAppMetadataEntity.fromJson(
    Map<String, dynamic> json,
  ) {
    return AortemEntraIdSerializedAppMetadataEntity(
      clientId: json['clientId'] as String,
      environment: AppEnvironment.values.firstWhere(
        (e) => e.toString() == 'AppEnvironment.${json['environment']}',
      ),
      displayName: json['displayName'] as String,
      version: json['version'] as String,
      authenticationType: AuthenticationType.values.firstWhere(
        (t) =>
            t.toString() == 'AuthenticationType.${json['authenticationType']}',
      ),
      redirectUris: List<String>.from(json['redirectUris'] as List),
      authority: json['authority'] as String,
      isConfidentialClient: json['isConfidentialClient'] as bool,
      allowedIssuers: List<String>.from(json['allowedIssuers'] as List),
      defaultScopes: List<String>.from(json['defaultScopes'] as List),
      capabilities: List<String>.from(json['capabilities'] as List),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      requiresPkce: json['requiresPkce'] as bool? ?? true,
      properties: Map<String, dynamic>.from(
        json['properties'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  /// Converts the entity to JSON
  Map<String, dynamic> toJson() {
    return {
      'clientId': clientId,
      'environment': environment.toString().split('.').last,
      'displayName': displayName,
      'version': version,
      'authenticationType': authenticationType.toString().split('.').last,
      'redirectUris': redirectUris,
      'authority': authority,
      'isConfidentialClient': isConfidentialClient,
      'allowedIssuers': allowedIssuers,
      'defaultScopes': defaultScopes,
      'capabilities': capabilities,
      'lastUpdated': lastUpdated.toUtc().toIso8601String(),
      'requiresPkce': requiresPkce,
      'properties': properties,
    };
  }

  /// Validates the entity's required fields
  void _validateEntity() {
    try {
      if (clientId.isEmpty) {
        throw AppMetadataEntityException(
          'Client ID cannot be empty',
          code: 'empty_client_id',
        );
      }
      if (displayName.isEmpty) {
        throw AppMetadataEntityException(
          'Display name cannot be empty',
          code: 'empty_display_name',
        );
      }
      if (version.isEmpty) {
        throw AppMetadataEntityException(
          'Version cannot be empty',
          code: 'empty_version',
        );
      }
      if (authority.isEmpty) {
        throw AppMetadataEntityException(
          'Authority cannot be empty',
          code: 'empty_authority',
        );
      }
      if (redirectUris.isEmpty) {
        throw AppMetadataEntityException(
          'At least one redirect URI is required',
          code: 'empty_redirect_uris',
        );
      }
      if (allowedIssuers.isEmpty) {
        throw AppMetadataEntityException(
          'At least one allowed issuer is required',
          code: 'empty_issuers',
        );
      }
      if (defaultScopes.isEmpty) {
        throw AppMetadataEntityException(
          'At least one default scope is required',
          code: 'empty_scopes',
        );
      }

      // Validate redirect URIs format
      for (final uri in redirectUris) {
        if (!Uri.parse(uri).isAbsolute) {
          throw AppMetadataEntityException(
            'Invalid redirect URI format: $uri',
            code: 'invalid_redirect_uri',
          );
        }
      }

      _logger.fine('App metadata entity validated successfully');
    } catch (e) {
      _logger.severe('App metadata entity validation failed', e);
      rethrow;
    }
  }

  /// Creates a copy of the entity with updated fields
  AortemEntraIdSerializedAppMetadataEntity copyWith({
    String? clientId,
    AppEnvironment? environment,
    String? displayName,
    String? version,
    AuthenticationType? authenticationType,
    List<String>? redirectUris,
    String? authority,
    bool? isConfidentialClient,
    List<String>? allowedIssuers,
    List<String>? defaultScopes,
    List<String>? capabilities,
    DateTime? lastUpdated,
    bool? requiresPkce,
    Map<String, dynamic>? properties,
  }) {
    return AortemEntraIdSerializedAppMetadataEntity(
      clientId: clientId ?? this.clientId,
      environment: environment ?? this.environment,
      displayName: displayName ?? this.displayName,
      version: version ?? this.version,
      authenticationType: authenticationType ?? this.authenticationType,
      redirectUris: redirectUris ?? this.redirectUris,
      authority: authority ?? this.authority,
      isConfidentialClient: isConfidentialClient ?? this.isConfidentialClient,
      allowedIssuers: allowedIssuers ?? this.allowedIssuers,
      defaultScopes: defaultScopes ?? this.defaultScopes,
      capabilities: capabilities ?? this.capabilities,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      requiresPkce: requiresPkce ?? this.requiresPkce,
      properties: properties ?? this.properties,
    );
  }

  /// Checks if a redirect URI is allowed
  bool isRedirectUriAllowed(String uri) {
    return redirectUris.contains(uri);
  }

  /// Checks if an issuer is allowed
  bool isIssuerAllowed(String issuer) {
    return allowedIssuers.contains(issuer);
  }

  /// Checks if the application has a specific capability
  bool hasCapability(String capability) {
    return capabilities.contains(capability);
  }

  /// Gets a property value with optional default
  T? getProperty<T>(String key, {T? defaultValue}) {
    return properties[key] as T? ?? defaultValue;
  }

  /// Gets the tenant ID from the authority
  String? get tenantId {
    final uri = Uri.parse(authority);
    final pathSegments = uri.pathSegments;
    return pathSegments.isNotEmpty ? pathSegments.first : null;
  }

  /// Gets a formatted string representation of the entity
  @override
  String toString() {
    return 'AppMetadata(clientId: $clientId, '
        'displayName: $displayName, '
        'version: $version, '
        'environment: $environment)';
  }
}
