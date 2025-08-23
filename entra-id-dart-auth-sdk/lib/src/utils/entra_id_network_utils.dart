import 'dart:io';

import '../exception/entra_id_network_exception.dart';

/// EntraIdNetworkUtils: Provides network utility methods for the SDK.
///
/// This utility class supports:
/// - Internet connectivity checks
/// - URL validation
/// - Retry logic for network operations
///
/// It is designed to be testable by allowing injection of a helper class
/// that wraps [InternetAddress.lookup].
class EntraIdNetworkUtils {
  /// Helper instance for DNS lookup, injected for testability.
  final NetworkUtilsHelper helper;

  /// Creates an instance of [EntraIdNetworkUtils].
  ///
  /// You can optionally pass a [NetworkUtilsHelper] to override the default
  /// behavior, which is helpful for mocking during tests.
  EntraIdNetworkUtils({this.helper = const NetworkUtilsHelper()});

  /// Checks if the device has an active internet connection.
  ///
  /// Attempts to resolve 'google.com' via DNS lookup.
  ///
  /// Returns `true` if the lookup succeeds and returns a non-empty IP address,
  /// otherwise returns `false`.
  ///
  /// Example:
  /// ```dart
  /// final isConnected = await utils.checkInternetConnectivity();
  /// ```
  Future<bool> checkInternetConnectivity() async {
    try {
      final result = await helper.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      // Throws a NetworkException if there is an issue with connectivity.
      throw NetworkException('Failed to check internet connectivity.', e);
    }
  }

  /// Validates whether a given [url] string is a well-formed absolute URL.
  ///
  /// Returns `true` if the URL has both a scheme (e.g., https) and authority (e.g., domain).
  ///
  /// Throws an [ArgumentError] if the URL is invalid.
  ///
  /// Example:
  /// ```dart
  /// utils.validateUrl("https://example.com"); // true
  /// utils.validateUrl("invalid-url"); // throws ArgumentError
  /// ```
  bool validateUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      throw ArgumentError('Invalid URL: $url');
    }
    return true;
  }

  /// Retries a network [operation] up to [retryCount] times if it fails.
  ///
  /// [operation] is a function that returns a [Future].
  /// [retryCount] defines how many retry attempts to make.
  /// [retryDelay] defines the delay (in milliseconds) between retries.
  ///
  /// Throws the last encountered exception if all retry attempts fail.
  ///
  /// Example:
  /// ```dart
  /// final result = await utils.retryRequest(() async => await httpCall());
  /// ```
  Future<T> retryRequest<T>(
    Future<T> Function() operation, {
    int retryCount = 3,
    int retryDelay = 1000,
  }) async {
    int attempt = 0;

    while (attempt < retryCount) {
      try {
        return await operation();
      } catch (e) {
        attempt++;
        if (attempt >= retryCount) {
          // Throws a NetworkException when retry limit is reached.
          throw NetworkException(
            'Failed to complete the operation after $retryCount attempts',
            e,
          );
        }
        await Future.delayed(Duration(milliseconds: retryDelay));
      }
    }

    // Throws a generic network exception if the loop ends without a successful operation.
    throw NetworkException(
      'Failed to complete the operation after $retryCount attempts',
    );
  }
}

/// Helper class to wrap the static [InternetAddress.lookup] method.
///
/// This abstraction allows the [EntraIdNetworkUtils] class to be
/// unit-tested by mocking DNS lookup behavior.
class NetworkUtilsHelper {
  /// Creates a constant [NetworkUtilsHelper] instance.
  const NetworkUtilsHelper();

  /// Performs DNS lookup for the given [host].
  ///
  /// Returns a list of [InternetAddress] objects.
  Future<List<InternetAddress>> lookup(String host) {
    return InternetAddress.lookup(host);
  }
}
