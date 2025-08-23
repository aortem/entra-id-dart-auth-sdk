import 'dart:async';

/// EntraIdIPublicClientApplication: Interface for public client applications.
/// Defines the methods required for public client applications, such as acquiring tokens interactively
/// or through device code flow, and clearing token cache.
abstract class EntraIdIPublicClientApplication {
  /// Acquire a token interactively by prompting the user to authenticate.
  ///
  /// Parameters:
  /// - `scopes`: A list of scopes to request during the authentication process.
  ///
  /// Returns:
  /// - A `Future<Map<String, dynamic>>` containing the acquired token details such as `access_token`, `refresh_token`, etc.
  ///
  /// Throws:
  /// - `Exception` if the interactive authentication fails.
  Future<Map<String, dynamic>> acquireTokenInteractively(List<String> scopes);

  /// Acquire a token using the device code flow.
  ///
  /// Parameters:
  /// - `scopes`: A list of scopes to request.
  ///
  /// Returns:
  /// - A `Future<Map<String, dynamic>>` containing the acquired token details such as `access_token`, `refresh_token`, etc.
  ///
  /// Throws:
  /// - `Exception` if the device code authentication fails.
  Future<Map<String, dynamic>> acquireTokenByDeviceCode(List<String> scopes);

  /// Clear cached tokens and reset the application state.
  ///
  /// Returns:
  /// - A `Future<void>` that completes when the cache is cleared.
  ///
  /// Throws:
  /// - `Exception` if clearing the cache fails.
  Future<void> clearCache();
}

/// Example implementation of the EntraIdIPublicClientApplication interface
/// for managing public client authentication flows like interactive and device code.
/// EntraIdPublicClientApp: Represents a public client application for Aortem Entra ID.
///
/// This class implements the `EntraIdIPublicClientApplication` interface
/// and provides methods for acquiring tokens interactively or using the device code flow.
/// It also supports clearing the token cache.
class EntraIdPublicClientApp
    implements EntraIdIPublicClientApplication {
  /// The client ID of the application registered in Entra ID.
  final String clientId;

  /// The authority URL for the authentication endpoint.
  final String authority;

  /// The redirect URI where the application expects to receive the authentication response.
  final String redirectUri;

  /// Creates an instance of `EntraIdPublicClientApp`.
  ///
  /// - [clientId]: The application client ID.
  /// - [authority]: The authentication authority URL.
  /// - [redirectUri]: The redirect URI for handling authentication responses.
  EntraIdPublicClientApp({
    required this.clientId,
    required this.authority,
    required this.redirectUri,
  });

  /// Acquires a token interactively by launching an authentication flow.
  ///
  /// This method simulates the process of interactive authentication, such as
  /// opening a browser or displaying a login dialog to the user.
  ///
  /// Example:
  /// ```dart
  /// final token = await app.acquireTokenInteractively(['user.read']);
  /// print(token['access_token']);
  /// ```
  ///
  /// - [scopes]: A list of scopes required for the access token.
  /// - Returns: A map containing the access token, refresh token, ID token, and expiration details.
  @override
  Future<Map<String, dynamic>> acquireTokenInteractively(
    List<String> scopes,
  ) async {
    print("Launching interactive authentication...");
    await Future.delayed(Duration(seconds: 3)); // Simulated flow
    return {
      'access_token': 'mocked_access_token',
      'refresh_token': 'mocked_refresh_token',
      'id_token': 'mocked_id_token',
      'expires_in': 3600,
    };
  }

  /// Acquires a token using the device code flow.
  ///
  /// This method simulates the process of the device code flow, where a user is
  /// prompted to enter a code on a specified URL to authenticate.
  ///
  /// Example:
  /// ```dart
  /// final token = await app.acquireTokenByDeviceCode(['user.read']);
  /// print(token['access_token']);
  /// ```
  ///
  /// - [scopes]: A list of scopes required for the access token.
  /// - Returns: A map containing the access token, refresh token, ID token, and expiration details.
  @override
  Future<Map<String, dynamic>> acquireTokenByDeviceCode(
    List<String> scopes,
  ) async {
    print("Starting device code flow...");
    await Future.delayed(Duration(seconds: 3)); // Simulated flow
    return {
      'access_token': 'mocked_access_token',
      'refresh_token': 'mocked_refresh_token',
      'id_token': 'mocked_id_token',
      'expires_in': 3600,
    };
  }

  /// Clears the token cache.
  ///
  /// This method removes all stored tokens from the local cache to ensure no
  /// stale or invalid tokens remain.
  ///
  /// Example:
  /// ```dart
  /// await app.clearCache();
  /// print("Cache cleared.");
  /// ```
  @override
  Future<void> clearCache() async {
    print("Clearing token cache...");
    // Add cache clearing logic here, e.g., clearing stored tokens from a local storage
  }
}
