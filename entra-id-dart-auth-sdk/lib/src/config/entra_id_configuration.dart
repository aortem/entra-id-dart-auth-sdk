/// EntraIdConfiguration: Centralized SDK Configuration Management.
/// This class manages global configuration settings for the Aortem EntraId Dart SDK.
class EntraIdConfiguration {
  // Singleton instance of the configuration.
  static EntraIdConfiguration? _instance;

  /// Required configuration properties.
  final String clientId;

  /// The client ID for the application.
  final String tenantId;

  /// The tenant ID of the Azure AD.
  final String authority;

  /// The authority URL for authentication.
  final String redirectUri;

  /// The redirect URI for the application.

  /// Optional configuration properties.
  final bool enableLogging;

  /// Flag to enable or disable logging.
  final int cacheExpirationInSeconds;

  /// Cache expiration time in seconds.

  /// Private constructor to restrict object creation.
  EntraIdConfiguration._internal({
    required this.clientId,

    /// Initializes the client ID.
    required this.tenantId,

    /// Initializes the tenant ID.
    required this.authority,

    /// Initializes the authority URL.
    required this.redirectUri,

    /// Initializes the redirect URI.
    this.enableLogging = false,

    /// Sets default logging to false.
    this.cacheExpirationInSeconds = 3600,

    /// Sets default cache expiration to 1 hour.
  });

  /// Factory constructor to initialize the singleton instance.
  /// If the instance already exists, it returns the existing instance.
  factory EntraIdConfiguration.initialize({
    required String clientId,

    /// Requires client ID as an input.
    required String tenantId,

    /// Requires tenant ID as an input.
    required String authority,

    /// Requires authority URL as an input.
    required String redirectUri,

    /// Requires redirect URI as an input.
    bool enableLogging = false,

    /// Optionally enables logging (default: false).
    int cacheExpirationInSeconds = 3600,

    /// Optionally sets cache expiration (default: 1 hour).
  }) {
    _instance ??= EntraIdConfiguration._internal(
      clientId: clientId,
      tenantId: tenantId,
      authority: authority,
      redirectUri: redirectUri,
      enableLogging: enableLogging,
      cacheExpirationInSeconds: cacheExpirationInSeconds,
    );
    return _instance!;

    /// Returns the initialized instance.
  }

  /// Checks if the configuration has been initialized.
  static bool get isInitialized => _instance != null;

  /// Resets the configuration (useful for testing or re-initialization).
  static void reset() {
    _instance = null;

    /// Clears the singleton instance.
  }
}
